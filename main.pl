:- use_module(library(pce)).
:- [regras].

iniciar :-
  gera_fatos_sobre_suspeitos(_),
  abre_visualizacao.

abre_visualizacao :-
  caminho_diretorio_fatos_sobre_suspeitos(Diretorio),
  new(DirObj, directory(Diretorio)),
  new(Window, window('Investigacao Criminal', size(800, 800))),
  send(Window, below, new(Browser, browser('Lista', size(200, 200)))),
  send(new(Dialog, dialog), below(Browser)),
  send(Dialog, append(button('Abrir', message(@prolog, visualiza_arquivo, DirObj, Browser?selection?key)))),
  send(Dialog, append(button('Fechar', message(Window, destroy)))),
  send(Browser, members(DirObj?files)),
  send(Window, open).

visualiza_arquivo(DirObj, Frame) :-
  send(new(View, view(Frame)), open),
  get(DirObj, file(Frame), FileObj),
  send(View, load(FileObj)).

gera_fatos_sobre_suspeitos(Pessoa) :-
  possivel_suspeito(Pessoa),
  abre_arquivo_fatos_sobre_suspeitos(Pessoa, SaidaArquivo),
  crime(Crime,Vitima,Dia,_),
  transcricao_local_dia_crime(SaidaArquivo, Pessoa, Dia, Crime),
  transcricao_motivos_contra_vitima(SaidaArquivo, Pessoa, Vitima),
  close(SaidaArquivo), fail.
gera_fatos_sobre_suspeitos(_).

transcricao_motivos_contra_vitima(SaidaArquivo, Pessoa, Vitima) :-
  inveja(Pessoa,Vitima),
  write(SaidaArquivo, Pessoa),
  write(SaidaArquivo, ' tem inveja de '),
  writeln(SaidaArquivo, Vitima),fail.
transcricao_motivos_contra_vitima(_,_,_).

transcricao_local_dia_crime(SaidaArquivo, Pessoa, Dia, Crime) :-
  estava(Pessoa,Dia,Lugar),
  write(SaidaArquivo, Pessoa),
  write(SaidaArquivo, ' estava em '),
  write(SaidaArquivo, Lugar),
  write(SaidaArquivo, ' no dia em que ocorreu o(a) '),
  writeln(SaidaArquivo, Crime).

abre_arquivo_fatos_sobre_suspeitos(Pessoa, Out) :-
  caminho_diretorio_fatos_sobre_suspeitos(Diretorio),
  verifica_diretorio(Diretorio),
  string_concat(Diretorio, Pessoa, CaminhoArquivo),
  open(CaminhoArquivo,write,Out).

verifica_diretorio(Diretorio) :-
  not(exists_directory(Diretorio)),
  make_directory(Diretorio).
verifica_diretorio(_).

caminho_diretorio_fatos_sobre_suspeitos('suspeitos/').
