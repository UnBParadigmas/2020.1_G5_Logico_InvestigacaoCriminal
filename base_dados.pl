:- dynamic possivel_suspeito/1.
:- dynamic crime/4.
:- dynamic tem_motivo_contra/3.
:- dynamic relacionamento_com/3.
:- dynamic esteve_local/4.
:- dynamic tem_objeto/2.
:- dynamic tipo_crime/1.

% Fato a ser desvendado
% crime(roubo,john,terca,parque).

/* FATOS DEFAULT */

dia(segunda).
dia(terca).
dia(quarta).
dia(quinta).
dia(sexta).
dia(sabado).
dia(doming).

tipo_crime(roubo).
tipo_crime(furto).
tipo_crime(agressao).
tipo_crime(sequestro).
tipo_crime(assassinato).

motivacao('inveja').
motivacao('nao se darem bem').
motivacao('dividas').
motivacao('ciumes').
motivacao('brigas').

local(parque).
local(hotel).
local(bar).
local(loja).
local(banco).
local(cinema).
local(restaurante).
local(academia).
local(biblioteca).
local(aeroporto).
local(festa).
local(faculdade).
local(trabalho).

local_frequencia('frequenta regularmente').
local_frequencia('frequenta raramente').
local_frequencia('nunca foi visto').

relacionamento(amigos).
relacionamento(casados).
relacionamento(namorados).
relacionamento(conhecidos).
relacionamento('talvez nao se conhecam').
relacionamento(inimigos).

/* FATOS DINAMICOS */

% Pessoas inicio
possivel_suspeito(fred).
possivel_suspeito(mary).
possivel_suspeito(jane).
possivel_suspeito(george).

% Fatos sobre Local
esteve_local(fred, parque, 'nunca foi visto no local', terca).
esteve_local(mary, parque, 'frequenta raramente', segunda).
esteve_local(george, parque, 'frequenta raramente', terca).
esteve_local(jane, academia, 'frequenta regularmente', segunda).

% Relacionamento
relacionamento_com(fred, john, inimigos).

% Motivacao
tem_motivo_contra(fred,john,inveja).
tem_motivo_contra(george,mary,'brigas').

tem_objeto(bar, garrafa).
tem_objeto(parque, cano).
