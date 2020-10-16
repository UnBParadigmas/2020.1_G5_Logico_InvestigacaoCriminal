:- [base_dados].

principal_suspeito(Pessoa, Crime) :-  crime(Vitima,Dia,Lugar, Objeto),
  possivel_suspeito(Pessoa),
  frequenta(Pessoa, Lugar),
  estava(Pessoa,Dia,Lugar),
  tem_motivo_contra(Pessoa,Vitima).
principal_suspeito(desconhecido,_).

tem_motivo_contra(Pessoa,Vitima) :-
  inveja(Pessoa,Vitima).
tem_motivo_contra(Pessoa,Vitima) :-
  tem_dinheiro(Vitima).
tem_motivo_contra(Pessoa,Vitima) :-
  tem_objeto_de_valor(Vitima).
tem_motivo_contra(Pessoa,Vitima) :-
  psicopatia(Pessoa).
tem_motivo_contra(Pessoa,Vitima) :-
  esta_devendo(Pessoa, Vitima).

objetos_no_lugar(Lugar) :-
  tem_objeto(Lugar, Objeto).

dia_da_semana(seg).
dia_da_semana(ter).
dia_da_semana(qua).
dia_da_semana(qui).
dia_da_semana(sex).
dia_da_semana(sab).
dia_da_semana(dom).

tipo_crime(roubo).
tipo_crime(furto).
tipo_crime(agressao).
tipo_crime(sequestro).
tipo_crime(assasinato).

nome_local(parque).
nome_local(hotel).
nome_local(loja).
nome_local(bar).
nome_local(banco).
nome_local(restaurante).
nome_local(academia).
nome_local(bibilioteca).