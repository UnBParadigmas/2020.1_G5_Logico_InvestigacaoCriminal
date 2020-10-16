:- [base_dados].

principal_suspeito(Pessoa, Crime, Lista) :-
  setof(Pessoa, avalia_principal_suspeito(Pessoa, Crime), Lista).

avalia_principal_suspeito(Pessoa, Crime) :-
  possivel_suspeito(Pessoa),
  crime(Crime,Vitima,Dia, Lugar),
  esteve_local(Pessoa,Lugar, Frequencia, Dia),
  tem_motivo_contra(Pessoa,Vitima, Motivo),
  relacionamento_com(Pessoa, Vitima, Relacionamento),
  relacao_motivo_crime(Motivo, Crime),
  cenario_relacionamento(Frequencia, Relacionamento, Motivo).

% Acusacoes a partir dos relacionamentos
cenario_relacionamento(_, amigos, Motivo) :-
  motivo_amigo(Motivo).

cenario_relacionamento(_, casados, Motivo) :-
  motivo_passional(Motivo).

cenario_relacionamento( _, namorados, Motivo) :-
  motivo_passional(Motivo).

cenario_relacionamento(_, conhecidos, Motivo) :-
  Motivo \== 'ciumes'.

cenario_relacionamento(FrequenciaLocal, 'talvez nao se conhecam', Motivo) :-
  Motivo == 'inveja',
  suspeito_nao_constuma_aparecer_local(FrequenciaLocal).

cenario_relacionamento(FrequenciaLocal, inimigos, Motivo) :-
  Motivo \== 'ciumes',
  suspeito_nao_constuma_aparecer_local(FrequenciaLocal).

suspeito_nao_constuma_aparecer_local(Frequencia) :-
  Frequencia \==  'frequenta regularmente'.

relacao_motivo_crime(inveja, roubo).
relacao_motivo_crime(inveja, furto).
relacao_motivo_crime(inveja, agressao).
relacao_motivo_crime(inveja, assassinato).
relacao_motivo_crime('nao se darem bem', agressao).
relacao_motivo_crime('nao se darem bem', assassinato).
relacao_motivo_crime(dividas, roubo).
relacao_motivo_crime(dividas, furto).
relacao_motivo_crime(dividas, agressao).
relacao_motivo_crime(dividas, sequestro).
relacao_motivo_crime(dividas, assassinato).
relacao_motivo_crime(ciumes, agressao).
relacao_motivo_crime(ciumes, assassinato).
relacao_motivo_crime(brigas, agressao).
relacao_motivo_crime(brigas, assassinato).


motivo_amigo('inveja').
motivo_amigo('dividas').
motivo_amigo('brigas').

motivo_passional('ciumes').
motivo_passional('brigas').

/* CONTROLE DINAMICO DA BASE */
% Remove a tupla X
remove_fato(X) :- remove_fato1(X), fail.
remove_fato(_).

remove_fato1(X) :- retract(X).
remove_fato1(_).

% Insere a tupla X, se já não estiver lá
adiciona_fato(X):-
  remove_fato(X), assert(X).
