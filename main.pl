:- consult('main.facts.pl').

diagnostic(0, BodyMass, Result) :-
    (   BodyMass < 16 -> Result = malnutrition;
        BodyMass < 20 -> Result = low_weight;
        BodyMass < 24 -> Result = normal;
        BodyMass < 29 -> Result = slight_overweight;
        BodyMass < 37 -> Result = severe_obesity;
        Result = morbid_obesity
    ).

diagnostic(1, BodyMass, Result) :-
    (   BodyMass < 17 -> Result = malnutrition;
        BodyMass < 20 -> Result = low_weight;
        BodyMass < 25 -> Result = normal;
        BodyMass < 30 -> Result = slight_overweight;
        BodyMass < 40 -> Result = severe_obesity;
        Result = morbid_obesity
    ).

main :-
    menu,
    writeln("Goodbye :)").

menu :-
    repeat,
    writeln("\nMenu:"),
    writeln("1. Calculate body mass index"),
    writeln("2. Recommend diet"),
    writeln("3. Exit"),
    read(Option),
    (   Option = 3
    ->  !, writeln("Exiting..."), fail  % Use cut (!) to prevent backtracking.
    ;   Option = 1
    ->  bodyMass, fail
    ;   Option = 2
    ->  recommendDiet, fail
    ;   writeln("Invalid option"), fail  % Handle invalid options
    ).

bodyMass :-
    set_gender(Gender),
    set_weight(Weight),
    set_height(Height),
    BodyMass is Weight / (Height * Height),
    diagnostic(Gender, BodyMass, Result),
    format("Body mass index: ~2f\nDiagnostic: ~w\n", [BodyMass, Result]).

recommendDiet :-
    calculate_basal_metabolism(BasalMetabolism),
    diet(BasalMetabolism), fail.

calculate_basal_metabolism(Result) :-
    set_gender(Gender),
    set_weight(Weight),
    set_age(Age),
    (Gender = 0 ->  
        metabolism_expenditure_female(Female),
        R1 is Female * Weight;   
    metabolism_expenditure_male(Male),
    R1 is Male * Weight),

    (Age < 25 ->  
        Result is R1 + 300;   
    Age < 45 ->  
        Result is R1;   
    Rest is floor((Age - 45) / 10) * 100,
    Result is R1 - Rest).

diet(Waste) :-
    breakfastMin(Bmin),
    breakfastMax(Bmax),
    breakfast(Bbakery, Bcereal, Bdairy, Bdrink, Begg, Bfruit, Bnut, Bsugar, Bkc),
    Bkc >= Waste * Bmin,
    Bkc < Waste * Bmax,

    middaySnackMin(Mmin),
    middaySnackMax(Mmax),
    middaySnack(Mbakery, Mdairy, Mfruit, Mnut, Mkc),
    Mkc >= Waste * Mmin,
    Mkc < Waste * Mmax,

    lunchMin(LuMin),
    lunchMax(LuMax),
    lunch(Lvegetable, Lmeat_or_fish, Llegume, Lcereal, Lsauce, Ldrink, Lkc),
    Lkc >= Waste * LuMin,
    Lkc < Waste * LuMax,

    afternoonSnackMin(AsMin),
    afternoonSnackMax(AsMax),
    afternoonSnack(Afruit, Adairy, K4),
    K4 >= Waste * AsMin,
    K4 < Waste * AsMax,

    dinnerMin(DiMin),
    dinnerMax(DiMax),
    dinner(Dvegetables, Dmeat_or_fish, Dcereal_or_legume, Dsauce, Ddrink, Dfruit_or_legume, K5),
    K5 >= Waste * DiMin,
    K5 < Waste * DiMax,

    %Ignore_repeated_food
    % Bcereal \= Lcereal, Lcereal \= Dcereal_or_legume, Bcereal \= Dcereal_or_legume,                   %Cereal
    % Bdairy \= Mdairy, Mdairy \= Adairy, Bdairy \= Adairy,                                             %Dairy
    % Bdrink \= Ldrink, Ldrink \= Ddrink, Bdrink \= Ddrink,                                             %Drink
    % Bfruit \= Mfruit, Mfruit \= Afruit, Afruit \= Dfruit_or_legume, Bfruit \= Dfruit_or_legume,       %Fruit
    % Bfruit \= Mnut, Mnut \= Adairy, Bfruit \= Adairy,                                                 %Nut
    % Lvegetable \= Dvegetables,                                                                        %Vegetable
    % Lmeat_or_fish \= Dmeat_or_fish,                                                                   %Meat_or_Fish
    % Llegume \= Dcereal_or_legume, Dcereal_or_legume \= Dfruit_or_legume, Llegume \= Dfruit_or_legume, %Legume
    % Lsauce \= Dsauce,                                                                                 %Sauce


    KCal is Bkc + Mkc + Lkc + K4 + K5,
    UnderLimit is Waste - (Waste * 0.5),
    OverLimit is Waste + (Waste * 0.5),

    KCal >= UnderLimit, 
    KCal < OverLimit,
    
    !,  % Prevent backtracking   
    
    formatResults([Bbakery, Bcereal, Bdairy, Bdrink, Begg, Bfruit, Bnut, Bsugar, Bkc], 
        [Mbakery, Mdairy, Mfruit, Mnut, Mkc], 
        [Lvegetable, Lmeat_or_fish, Llegume, Lcereal, Lsauce, Ldrink, Lkc], 
        [Afruit, Adairy, K4], 
        [Dvegetables, Dmeat_or_fish, Dcereal_or_legume, Dsauce, Ddrink, Dfruit_or_legume, K5], 
        KCal).

formatResults(Breakfast, MiddaySnack, Lunch, AfternoonSnack, Dinner, KCal) :-
    format("\nBreakfast:        ~s, ~s, ~s, ~s, ~s, ~s, ~s, ~s: ~d\n", Breakfast),
    format("Midday snack:       ~s, ~s, ~s, ~s: ~d\n", MiddaySnack),
    format("Lunch:              ~s, ~s, ~s, ~s, ~s, ~s: ~d\n", Lunch),
    format("Afternoon snack:    ~s, ~s: ~d\n", AfternoonSnack),
    format("Dinner:             ~s, ~s, ~s, ~s, ~s, ~s: ~d\n", Dinner),
    format("Kilocalories: ~d\n", [KCal]).

%SETTING_VALUES
set_gender(Gender) :-
    nl, write("Gender (0: Female / 1: Male): "),
    read(Gender).

set_weight(Weight) :-
    nl, write("Weight in kg: "),
    read(Weight).

set_height(Height) :-
    nl, write("Height in m: "),
    read(Height).

set_age(Age) :-
    nl, write("Age in years: "),
    read(Age).

%consult('main.pl').
