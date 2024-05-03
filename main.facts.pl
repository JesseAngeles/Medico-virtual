:- consult('facts.bakery.pl'),
   consult('facts.cereal.pl'),
   consult('facts.dairy.pl'),
   consult('facts.drink.pl'),
   consult('facts.egg.pl'),
   consult('facts.fish.pl'),
   consult('facts.fruit.pl'),
   consult('facts.legume.pl'),
   consult('facts.meat.pl'),
   consult('facts.nut.pl'),
   consult('facts.oil.pl'),
   consult('facts.sauce.pl'),
   consult('facts.sugar.pl'),
   consult('facts.vegetable.pl').

breakfastMin(0.20).
breakfastMax(0.30).
middaySnackMin(0.10).
middaySnackMax(0.15).
lunchMin(0.30).
lunchMax(0.40).
afternoonSnackMin(0.10).
afternoonSnackMax(0.15).
dinnerMin(0.20).
dinnerMax(0.25).

middayKsnackAverage(10).
lunchAverage(35).
afternoonSnackKaverage(10).
dinnerAverage(20).

metabolism_expenditure_female(21.6).
metabolism_expenditure_male(24).


meat_or_fish(D, K) :-
    meat(D, K);
    fish(D, K).

dairy_or_nut(D, K) :-
    dairy(D, K);
    nut(D, K).

 cereal_or_legume(D, K) :-
    cereal(D, K);
    legume(D, K).

fruit_or_legume(D, K) :-
    fruit(D, k);
    legume(D, K).

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


breakfast(D1, D2, D3, D4, D5, D6, D7, D8, KCal) :-
    bakery(D1, K1),
    cereal(D2, K2),
    dairy(D3, K3),
    drink(D4, K4),
    egg(D5, K5),
    fruit(D6, K6),
    nut(D7, K7),
    sugar(D8, K8),
    KCal is K1 + K2 + K3 + K4 + K5 + K6 + K7 + K8.

middaySnack(D1, D2, D3, D4, KCal) :- %R2, R3, R4) :-
    bakery(D1, K1),
    dairy(D2, K2), %D2 \= R2, 
    fruit(D3, K3), %D3 \= R3,
    nut(D4, K4), %D4 \= R4,
    KCal is K1 + K2 + K3 + K4.

lunch(D1, D2, D3, D4, D5, D6, KCal) :- %, R4, R6) :-
    vegetable(D1, K1),
    meat_or_fish(D2, K2), 
    legume(D3, K3),
    cereal(D4, K4), %D4 \= R4,
    sauce(D5, K5), 
    drink(D6, K6), %D6 \= R6,
    KCal is K1 + K2 + K3 + K4 + K5 + K6.

afternoonSnack(D1, D2, KCal) :- %, R1, R21, R22) :-
    fruit(D1, K1), %D1 \= R1,
    dairy_or_nut(D2, K2), %D2 \= R21, D2 \= R22,
    KCal is K1 + K2.

dinner(D1, D2, D3, D4, D5, D6, KCal) :- %y, R1, R2, R31, R32, R4, R5, R6) :-
    vegetable(D1, K1),  %D1 \= R1,
    meat_or_fish(D2, K2), %D2 \= R2,
    cereal_or_legume(D3, K3), %D3 \= R31, D3 \= R32, 
    sauce(D4, K4), %D4 \= R4,
    drink(D5, K5), %D5 \= R5,
    fruit_or_legume(D6, K6),% D6 \= R6,  
    KCal is K1 + K2 + K3 + K4 + K5 + K6.
