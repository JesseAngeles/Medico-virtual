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

middaySnack(D1, D2, D3, D4, KCal) :-
    bakery(D1, K1),
    dairy(D2, K2),
    fruit(D3, K3),
    nut(D4, K4),
    KCal is K1 + K2 + K3 + K4.

lunch(D1, D2, D3, D4, D5, D6, KCal) :-
    vegetable(D1, K1),
    meat_or_fish(D2, K2), 
    legume(D3, K3),
    cereal(D4, K4),
    sauce(D5, K5),
    drink(D6, K6),
    KCal is K1 + K2 + K3 + K4 + K5 + K6.

afternoonSnack(D1, D2, KCal) :-
    fruit(D1, K1),
    dairy_or_nut(D2, K2), 
    KCal is K1 + K2.

dinner(D1, D2, D3, D4, D5, D6, KCal) :-
    vegetable(D1, K1),
    meat_or_fish(D2, K2),
    cereal_or_legume(D3, K3),  % Depending on the meal balance.
    sauce(D4, K4),
    drink(D5, K5),
    fruit_or_legume(D6, K6),  
    KCal is K1 + K2 + K3 + K4 + K5 + K6.
