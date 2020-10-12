:- dynamic possivel_suspeito/1.
:- dynamic crime/4.
:- dynamic estava/3.
:- dynamic inveja/2.

possivel_suspeito(fred).
possivel_suspeito(mary).
possivel_suspeito(jane).
possivel_suspeito(george).

crime(roubo,john,terca,parque).
crime(roubo,robin,quinta,bar).
crime(assalto,jim,quarta,bar).

estava(fred,terca,parque).
estava(mary,quarta,bar).

inveja(fred,john).
inveja(mary,jim).
