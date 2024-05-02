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
    breakfastMin(BrMin),
    breakfastMax(BrMax),
    breakfast(A1, A2, A3, A4, A5, A6, A7, A8, K1),
    K1 >= Waste * BrMin,
    K1 < Waste * BrMax,

    middaySnackMin(MsMin),
    middaySnackMax(MsMax),
    middaySnack(B1, B2, B3, B4, K2),
    A3 \= B2, A6 \= B3, A6 \= B4,
    K2 >= Waste * MsMin,
    K2 < Waste * MsMax,

    lunchMin(LuMin),
    lunchMax(LuMax),
    lunch(C1, C2, C3, C4, C5, C6, K3),
    A2 \= C4, A4 \= C6,
    K3 >= Waste * LuMin,
    K3 < Waste * LuMax,

    afternoonSnackMin(AsMin),
    afternoonSnackMax(AsMax),
    afternoonSnack(D1, D2, K4),
    B2 \= D2, A3 \= D2, B3 \= D1, B4 \= D2, A6 \= D2, 
    K4 >= Waste * AsMin,
    K4 < Waste * AsMax,

    dinnerMin(DiMin),
    dinnerMax(DiMax),
    dinner(E1, E2, E3, E4, E5, E6, K5),
    C4 \= E3, A2 \= E3, C6 \= E5, A4 \= E5, D1 \= E6, A6 \= E6, 
    C1 \= E1, C2 \= E2, C3 \= E3, E3 \= E6, C3 \= E6, C5 \= E4,  
    K5 >= Waste * DiMin,
    K5 < Waste * DiMax,

    %Ignore_repeated_food
    % A2 \= C4, C4 \= E3, A2 \= E3,           %Cereal
    % A3 \= B2, B2 \= D2, A3 \= D2,           %Dairy
    % A4 \= C6, C6 \= E5, A4 \= E5,           %Drink
    % A6 \= B3, B3 \= D1, D1 \= E6, A6 \= E6, %Fruit
    % A6 \= B4, B4 \= D2, A6 \= D2,           %Nut
    % C1 \= E1,                               %Vegetable
    % C2 \= E2,                               %Meat_or_Fish
    % C3 \= E3, E3 \= E6, C3 \= E6,           %Legume
    % C5 \= E4,                               %Sauce


    KCal is K1 + K2 + K3 + K4 + K5,
    UnderLimit is Waste - (Waste * 0.5),
    OverLimit is Waste + (Waste * 0.5),

    KCal >= UnderLimit, 
    KCal < OverLimit,
    
    !,  % Prevent backtracking   
    
    formatResults([A1, A2, A3, A4, A5, A6, A7, A8, K1], 
        [B1, B2, B3, B4, K2], 
        [C1, C2, C3, C4, C5, C6, K3], 
        [D1, D2, K4], 
        [E1, E2, E3, E4, E5, E6, K5], 
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
