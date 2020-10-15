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
  new(RightDialogGroup, dialog_group(right_dialog_group, group)),
  new(ButtonsDialogGroup, dialog_group('Botões', group)),
  new(SuspeitosBrowser, browser('Lista', size(50, 40))),

  % Posicionamento dos elementos
  send(MainDialog, append, LeftDialogGroup),
  send(MainDialog, append, RightDialogGroup, right),
  send(ButtonsDialogGroup, below, LeftDialogGroup),

  % SuspeitosBrowser com os suspeitos
  send(LeftDialogGroup, append, SuspeitosBrowser),

  % Elementos no dialog group de acoes
  new(ActionsDialogGroup, dialog_group('Ações', box)),
  send(RightDialogGroup, append, ActionsDialogGroup),

  new(AddSuspectButton, button('Adicionar Suspeito',
    message(@prolog, adiciona_suspeito, SuspeitosBrowser, DirObj))),
  get(AddSuspectButton, area, AreaAddSuspectButton),
  send(AreaAddSuspectButton, size, size(125, 20)),

  send(ActionsDialogGroup, append, AddSuspectButton),

  % Elementos no dialog group de relatos
  new(ReportsDialogGroup, dialog_group('Relatos', box)),
  send(RightDialogGroup, append, ReportsDialogGroup),
  new(AddLocalButton, button('Local', message(@prolog, local_form, MainDialog))),
  get(AddLocalButton, area, AreaAddLocalButton),
  send(AreaAddLocalButton, size, size(125, 20)),

  new(AddEnvyButton, button('Inveja', message(@prolog, envy_form, MainDialog))),
  get(AddEnvyButton, area, AreaAddEnvyButton),
  send(AreaAddEnvyButton, size, size(125, 20)),
  
  send(ReportsDialogGroup,append(AddLocalButton, next_row)),
  send(ReportsDialogGroup,append(AddEnvyButton, next_row)),

  % dialog group de Resultados
  new(ResultsDialogGroup, dialog_group('Principais Suspeitos', box)),
  send(RightDialogGroup, append, ResultsDialogGroup),
  new(ResultMenu, menu(result_menu, toggle)),
  send(ResultMenu, layout, orientation:=vertical),
  send(ResultMenu, show_label, false),
  send(ResultsDialogGroup,  append, ResultMenu),

  atualiza_resultado_suspeitos_menu(MainDialog),

  % Criacao de botoes no dialog group inferior
  send(ButtonsDialogGroup,append(button('Abrir Relatorio do Suspeito', message(@prolog, visualiza_fatos, DirObj, SuspeitosBrowser?selection?key)))),
  send(ButtonsDialogGroup,append(button('Sair', message(MainDialog, destroy)))),

  % Preenchimento dos arquivos encontrados no SuspeitosBrowser
  send(SuspeitosBrowser, members(DirObj?files)),

  send(MainDialog, open).

teste3(ARRAY):- writeln('Teste').

atualiza_resultado_suspeitos_menu(MainDialog) :-
  get(MainDialog,  member, right_dialog_group, RightDialogGroup),
  get(RightDialogGroup, member, 'Principais Suspeitos', ResultsDialog),
  get(ResultsDialog, member, result_menu, ResultsMenu),
  send(ResultsMenu,  clear),
  principal_suspeito(Pessoa, _),
  new(SuspeitoText, text(Pessoa)),
  get(SuspeitoText, area, AreaSuspeitoText),
  send(AreaSuspeitoText, size, size(125, 20)),
  send(ResultsMenu, append(SuspeitoText)), fail.
atualiza_resultado_suspeitos_menu(_).

visualiza_fatos(DirObj, Frame) :-
  new(SuspeitosBrowser, browser('Fatos sobre o Suspeito', size(100, 40))),
  get(DirObj, file(Frame), FileObj),
  get(FileObj, name, FilePath),
  ler_dados_arquivo(FilePath, Lines),
  send(SuspeitosBrowser, members(Lines)),
  send(SuspeitosBrowser, open).

adiciona_suspeito(SuspeitosBrowser, DirObj) :-
  adiciona_suspeito_form(Name),
  adiciona_fato(possivel_suspeito(Name)),
  gera_fatos_sobre_suspeitos(_),
  send(SuspeitosBrowser, members(DirObj?files)).

adiciona_suspeito_form(Name) :-
  new(FormDialog, dialog('Adicionar Suspeito', size(800, 800))),

  new(SuspectName, text_item('Nome do Suspeito:')),
  send(FormDialog, append, SuspectName),

  send(FormDialog, append, button(cancel, message(FormDialog, return, @nil))),
  send(FormDialog, append, button(ok, message(FormDialog, return, SuspectName?selection))),

  send(FormDialog, default_button, ok),
  get(FormDialog, confirm, Answer),
  send(FormDialog, destroy),
  Answer \== @nil,
  Name = Answer.

local_form(MainDialog) :-
  new(FormDialog, dialog('Local', size(800, 800))),

  send(FormDialog, append, new(SuspeitoMenu, menu('Pessoa:', cycle))),
  suspeitos_menu(SuspeitoMenu),

  send(FormDialog, append, new(DiaMenu, menu('Dia:'))),
  send(DiaMenu, append, menu_item('segunda')),
  send(DiaMenu, append, menu_item('terca')),
  send(DiaMenu, append, menu_item('quarta')),
  send(DiaMenu, append, menu_item('quinta')),
  send(DiaMenu, append, menu_item('sexta')),
  send(DiaMenu, append, menu_item('sabado')),
  send(DiaMenu, append, menu_item('domingo')),

  send(FormDialog, append, new(LugarText, text_item('Lugar:'))),

  send(FormDialog, append, button(ok,
    and(message(@prolog,  add_local, MainDialog, SuspeitoMenu?selection, DiaMenu?selection, LugarText?selection),
        message(FormDialog, destroy)))),
  send(FormDialog, append, button(cancel, message(FormDialog, destroy))),

  send(FormDialog, open).

envy_form(MainDialog) :-
  new(FormDialog, dialog('Local', size(800, 800))),

  send(FormDialog, append, new(SuspeitoMenu, menu('Pessoa:', cycle))),
  suspeitos_menu(SuspeitoMenu),

  send(FormDialog, append, button(ok,
    and(message(@prolog,  add_envy, MainDialog, SuspeitoMenu?selection, SuspeitoMenu?selection),
        message(FormDialog, destroy)))),
  send(FormDialog, append, button(cancel, message(FormDialog, destroy))),

  send(FormDialog, open).

suspeitos_menu(SuspeitoMenu) :-
  possivel_suspeito(Pessoa),
  send(SuspeitoMenu, append, menu_item(Pessoa)), fail.
suspeitos_menu(_).

add_local(MainDialog, Pessoa, Dia, Lugar) :-
  adiciona_fato(estava(Pessoa, Dia, Lugar)),
  gera_fatos_sobre_suspeitos(_),
  atualiza_resultado_suspeitos_menu(MainDialog).

add_envy(MainDialog, Suspeito, Vitima) :-
  adiciona_fato(inveja(Suspeito, john)),
  gera_fatos_sobre_suspeitos(_),
  atualiza_resultado_suspeitos_menu(MainDialog).

% Regras Auxiliares
ler_dados_arquivo(FilePath, Lines) :-
  open(FilePath, read, Stream),
  ler_linhas_arquivo(Stream, Lines),
  close(Stream).

ler_linhas_arquivo(Stream, Lines) :-
  read_string(Stream, _, Str),
  split_string(Str, "\n", "\n", Lines).

gera_fatos_sobre_suspeitos(Pessoa) :-
  caminho_diretorio_fatos_sobre_suspeitos(Diretorio),
  verifica_diretorio(Diretorio),

  possivel_suspeito(Pessoa),
  abre_arquivo_fatos_sobre_suspeitos(Pessoa, Diretorio, SaidaArquivo),
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
    '~w esteve em ~w no dia em que ocorreu o(a) ~w\n',
    [Pessoa, Lugar, Crime]), fail.
transcricao_local_dia_crime(_, _, _, _).

abre_arquivo_fatos_sobre_suspeitos(Pessoa, Diretorio, Out) :-
  string_concat(Diretorio, Pessoa, CaminhoArquivo),
  open(CaminhoArquivo,write,Out).

verifica_diretorio(Diretorio) :-
  not(exists_directory(Diretorio)),
  make_directory(Diretorio).
verifica_diretorio(Diretorio) :-
  exists_directory(Diretorio),
  delete_directory_contents(Diretorio).

caminho_diretorio_fatos_sobre_suspeitos('suspeitos/').
