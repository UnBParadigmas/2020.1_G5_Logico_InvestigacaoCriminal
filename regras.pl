:- [base_dados].

principal_suspeito(Pessoa, Crime) :-
  possivel_suspeito(Pessoa),
  crime(Crime,Vitima,Dia, Lugar),
  % frequenta(Pessoa, Lugar),
  estava(Pessoa,Dia,Lugar),
  tem_motivo_contra(Pessoa,Vitima, _).
principal_suspeito(desconhecido,_).

tem_motivo_contra(Pessoa, Vitima, inveja) :-
  inveja(Pessoa,Vitima).

% tem_motivo_contra(Pessoa,Vitima) :-
%   tem_dinheiro(Vitima).
% tem_motivo_contra(Pessoa,Vitima) :-
%   tem_objeto_de_valor(Vitima).
% tem_motivo_contra(Pessoa,Vitima) :-
%   psicopatia(Pessoa).
% tem_motivo_contra(Pessoa,Vitima) :-
%   esta_devendo(Pessoa, Vitima).

% objetos_no_lugar(Lugar) :-
%   tem_objeto(Lugar, Objeto).

% Remove a tupla X
remove_fato(X) :- remove_fato1(X), fail.
remove_fato(_).

remove_fato1(X) :- retract(X).
remove_fato1(_).

% Insere a tupla X, se já não estiver lá
adiciona_fato(X):-
  remove_fato(X), assert(X).
