:- [base_dados].

principal_suspeito(Pessoa, Crime) :-
  crime(Crime,Vitima,Dia,Lugar, Objeto),
  possivel_suspeito(Pessoa),
  frequenta(Pessoa, Lugar),
  estava(Pessoa,Dia,Lugar),
  tem_motivo_contra(Pessoa,Vitima).
principal_suspeito(desconhecido,_).

tem_motivo_contra(Pessoa,Vitima):-
  inveja(Pessoa,Vitima).

objetos_no_lugar(Lugar) :-
  tem_objeto(Lugar, Objeto).

