:- [base_dados].

principal_suspeito(Pessoa, Crime) :-
  crime(Crime,Vitima,Dia,Lugar),
  possivel_suspeito(Pessoa),
  estava(Pessoa,Dia,Lugar),
  tem_motivo_contra(Pessoa,Vitima).
principal_suspeito(desconhecido,_).

tem_motivo_contra(Pessoa,Vitima):-
  inveja(Pessoa,Vitima).
