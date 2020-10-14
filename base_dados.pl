:- dynamic possivel_suspeito/1.
:- dynamic crime/5.
:- dynamic estava/3.
:- dynamic inveja/2.
:- dynamic tem_objeto/2.
:- dynamic frequenta/2.

possivel_suspeito(fred).
possivel_suspeito(mary).
possivel_suspeito(jane).
possivel_suspeito(george).

crime(roubo,john,terca,parque, garrafa).
crime(roubo,robin,quinta,bar, cano).
crime(assalto,jim,quarta,bar, cano).

estava(fred,terca,parque).
estava(mary,terca,parque).
estava(mary,quarta,parque).
estava(jane,terca,bar).
estava(george,quarta,parque).

inveja(fred,john).
inveja(mary,jim).

amigos(fred, mary).

tem_objeto(bar, garrafa).
tem_objeto(parque, cano).

frequenta(john, parque).
frequenta(mary, parque).
frequenta(jane, bar).
frequenta(fred, bar).

esquece(X):-
    esquece1(X), fail.
  esquece(X).
  
esquece1(X):-
    retract(X).
esquece1(X).
  
memoriza(X):-
    esquece(X), assert(X).
  
memoriza(X):-
    assert(X).