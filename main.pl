:- use_module(library(pce)).
:- [regras].

iniciar :-
  gera_fatos_sobre_suspeitos(_),
  interface.

interface :-
  % Auxiliares
  caminho_diretorio_fatos_sobre_suspeitos(Diretorio),
  new(DirObj, directory(Diretorio)),

  % Criacao dos elementos da tela
  new(MainDialog, dialog('Investigacao Criminal', size(800, 800))),
  new(LeftDialogGroup, dialog_group('Suspeitos', box)),
  new(RightDialogGroup, dialog_group('Ações', box)),
  new(ButtonsDialogGroup, dialog_group('Botões', group)),
  new(Browser, browser('Lista', size(50, 40))),

  % Posicionamento dos elementos
  send(MainDialog, append, LeftDialogGroup),
  send(MainDialog, append, RightDialogGroup, right),
  send(MainDialog, append, ButtonsDialogGroup, next_row),
  
  send(LeftDialogGroup, append, Browser),
  
  % Criacao dos elementos no dialog group direito
  new(AddSuspectButton, button('Adicionar Suspeito', message(@prolog, adiciona_suspeito_form))),
  new(AddFactButton, button('Adicionar Fato')),
  get(AddFactButton, area, AreaAddFactButton),
  send(AreaAddFactButton, size, size(125, 20)),
  get(AddSuspectButton, area, AreaAddSuspectButton),
  send(AreaAddSuspectButton, size, size(125, 20)),
  send(RightDialogGroup,append(AddSuspectButton, next_row)), 
  send(RightDialogGroup,append(AddFactButton, next_row)),

  % Criacao de botoes no dialog group inferior
  send(ButtonsDialogGroup,append(button('Visualizar Fato', message(@prolog, visualiza_fatos, DirObj, Browser?selection?key)))),
  send(ButtonsDialogGroup, append(button('Sair', message(MainDialog, destroy)))),

  % Preenchimento dos arquivos encontrados no Browser
  send(Browser, members(DirObj?files)),

  send(MainDialog, open).

visualiza_fatos(DirObj, Frame) :-
  new(Browser, browser('Fatos sobre o Suspeito', size(100, 40))),
  get(DirObj, file(Frame), FileObj),
  get(FileObj, name, FilePath),
  ler_dados_arquivo(FilePath, Lines),
  send(Browser, members(Lines)),
  send(Browser, open).

adiciona_suspeito_form :-
  new(FormDialog, dialog('Adicionar Suspeito', size(800, 800))),
  new(DialogGroup, dialog_group(' ')),
  send(FormDialog, append, DialogGroup),

  new(SuspectName, text_item('Nome do Suspeito:')),
  send(DialogGroup, append, SuspectName),

  send(DialogGroup, append, button('Cancelar', message(FormDialog, destroy))),
  send(DialogGroup, append, button('Salvar',
    and(message(@prolog, cria_suspeito, SuspectName?selection),
        message(FormDialog, destroy)))),

  send(FormDialog, open).

cria_suspeito(Name) :-
  write(Name), nl.

% Regras Auxiliares
ler_dados_arquivo(FilePath, Lines) :-
  open(FilePath, read, Stream),
  ler_linhas_arquivo(Stream, Lines),
  close(Stream).

ler_linhas_arquivo(Stream, Lines) :-
  read_string(Stream, _, Str),
  split_string(Str, "\n", "\n", Lines).

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
  format(SaidaArquivo, '~w tem inveja de ~w\n', [Pessoa, Vitima]), fail.
transcricao_motivos_contra_vitima(_,_,_).

transcricao_local_dia_crime(SaidaArquivo, Pessoa, Dia, Crime) :-
  estava(Pessoa,Dia,Lugar),
  format(SaidaArquivo,
    '~w estava em ~w no dia em que ocorreu o(a) ~w\n',
    [Pessoa, Lugar, Crime]).

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
