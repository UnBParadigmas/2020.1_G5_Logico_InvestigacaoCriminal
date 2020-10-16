:- dynamic possivel_suspeito/1.
:- dynamic crime/4.
:- dynamic estava/3.
:- dynamic inveja/2.
:- dynamic tem_objeto/2.
:- dynamic frequenta/2.
:- dynamic tipo_crime/1.

possivel_suspeito(fred).
possivel_suspeito(mary).
possivel_suspeito(jane).
possivel_suspeito(george).

dia(segunda).
dia(terca).
dia(quarta).
dia(quinta).
dia(sexta).
dia(sabado).
dia(doming).

local(parque).
local(bar).
local(hotel).
local(cinema).
local(aeroporto).
local(festa).
local(faculdade).
local(trabalho).

tipo_crime(roubo).
tipo_crime(assassinato).
tipo_crime(transito).

crime(roubo,john,terca,parque).

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

remove_fato(X):-
    remove_fato1(X), fail.
  remove_fato(X).
  
remove_fato1(X):-
    retract(X).
remove_fato1(X).
  
adiciona_fato(X):-
    remove_fato(X), assert(X).
  
adiciona_fato(X):-
    assert(X).
