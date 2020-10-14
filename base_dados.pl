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
estava(mary,quarta,bar).

inveja(fred,john).
inveja(mary,jim).

tem_objeto(bar, garrafa).
tem_objeto(parque, cano).

frequenta(john, parque).
frequenta(mary, parque).
frequenta(jane, bar).
frequenta(fred, bar).