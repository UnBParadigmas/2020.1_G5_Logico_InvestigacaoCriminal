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

nome_local(parque).
nome_local(hotel).
nome_local(loja).
nome_local(bar).
nome_local(banco).
nome_local(restaurante).
nome_local(academia).
nome_local(bibilioteca).
nome_local(aeroporto).

tipo_crime(roubo).
tipo_crime(furto).
tipo_crime(agressao).
tipo_crime(sequestro).
tipo_crime(assassinato).

estava(fred,terca,parque).
estava(mary,terca,parque).
estava(mary,quarta,parque).
estava(jane,terca,bar).
estava(george,quarta,parque).

inveja(fred,john).

amigos(fred, mary).

tem_objeto(bar, garrafa).
tem_objeto(parque, cano).

frequenta(john, parque).
frequenta(mary, parque).
frequenta(jane, bar).
frequenta(fred, bar).

% crime(roubo,john,terca,parque).
