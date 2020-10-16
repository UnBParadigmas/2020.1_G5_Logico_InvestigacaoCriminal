:- use_module(library(pce)).
:- [regras].

investigacao :-
  gera_fatos_sobre_suspeitos(_),
  prompt_informacoes_crime,
  interface.

prompt_informacoes_crime :-
  not(crime(_, _, _, _)), % Somente pede as informacoes se nao houver crime cadastrado

  new(MainDialog, dialog('Investigacao Criminal')),
  send(MainDialog, append, text('Forneça as informações sobre o crime:')),

  send(MainDialog, append,
      new(TipoCrimeMenu, menu('Tipo de crime', cycle))),
  tipos_crimes_menu(TipoCrimeMenu),

  send(MainDialog, append,
      new(VitimaText, text_item('Vitima', ''))),
      
  send(MainDialog, append,
      new(DiaSemanaMenu, menu('Dia', cycle))),
  dias_semana_menu(DiaSemanaMenu),

  send(MainDialog, append,
    new(LocalMenu, menu('Local', cycle))),
  locais_menu(LocalMenu),

  send(MainDialog, append,
       button(ok, message(MainDialog, return, ok))),
  send(MainDialog, append,
       button(cancel, message(MainDialog, destroy))),

  % Procedimento de confirmacao dos dados
  send(MainDialog, default_button, ok),
  get(MainDialog, confirm, _),
  get(TipoCrimeMenu, selection, TipoCrime),
  get(VitimaText, selection, Vitima),
  get(DiaSemanaMenu, selection, DiaSemana),
  get(LocalMenu, selection, Local),
  novo_crime(TipoCrime, Vitima, DiaSemana, Local),
  send(MainDialog, destroy).
prompt_informacoes_crime.

novo_crime(TipoCrime, Vitima, DiaSemana, Local) :-
  adiciona_fato(crime(TipoCrime, Vitima, DiaSemana, Local)).

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

  % Informacoes do crime
  new(CrimeDialogGroup, dialog_group('Crime', box)),
  send(RightDialogGroup, append, CrimeDialogGroup),
  informacoes_crime_dialog(CrimeDialogGroup),

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

  new(AddMotivacaoButton, button('Possível Motivação', message(@prolog, motivacao_form, MainDialog))),
  get(AddMotivacaoButton, area, AreaAddMotivacaoButton),
  send(AreaAddMotivacaoButton, size, size(125, 20)),
  
  send(ReportsDialogGroup,append(AddLocalButton, next_row)),
  send(ReportsDialogGroup,append(AddMotivacaoButton, next_row)),

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

informacoes_crime_dialog(DialogGroup) :-
  crime(Tipo, Vitima, Dia, Lugar),

  send(DialogGroup, append, new(TipoTxt, text_item(crime, Tipo))),
  send(TipoTxt,  editable, false),
  get(TipoTxt, area, AreaTipoTxt),
  send(AreaTipoTxt, size, size(125, 20)),

  send(DialogGroup, append, new(VitimaTxt, text_item(vitima, Vitima))),
  send(VitimaTxt,  editable, false),
  get(VitimaTxt, area, AreaVitimaTxt),
  send(AreaVitimaTxt, size, size(125, 20)),

  send(DialogGroup, append, new(DiaTxt, text_item(dia, Dia))),
  send(DiaTxt,  editable, false),
  get(DiaTxt, area, AreaDiaTxt),
  send(AreaDiaTxt, size, size(125, 20)),

  send(DialogGroup, append, new(LugarTxt, text_item('Lugar', Lugar))),
  send(LugarTxt,  editable, false),
  get(LugarTxt, area, AreaLugarTxt),
  send(AreaLugarTxt, size, size(125, 20)).

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

  send(FormDialog, append, text('Foi visto no Local')),

  send(FormDialog, append, new(SuspeitoMenu, menu('Suspeito:', cycle))),
  suspeitos_menu(SuspeitoMenu),

  send(FormDialog, append, new(DiaMenu, menu('Dia:', cycle))),
  dias_semana_menu(DiaMenu),

  send(FormDialog, append, new(LugarMenu, menu('Lugar:', cycle))),
  locais_menu(LugarMenu),

  send(FormDialog, append, button(ok,
    and(message(@prolog,  add_local, MainDialog, SuspeitoMenu?selection, DiaMenu?selection, LugarMenu?selection),
        message(FormDialog, destroy)))),
  send(FormDialog, append, button(cancel, message(FormDialog, destroy))),

  send(FormDialog, open).

motivacao_form(MainDialog) :-
  crime(_, Vitima, _, _),

  new(FormDialog, dialog('Local', size(800, 800))),
  string_concat('Tem motivo contra ', Vitima, Titulo),
  send(FormDialog, append, text(Titulo)),

  send(FormDialog, append, new(SuspeitoMenu, menu('Suspeito:', cycle))),
  suspeitos_menu(SuspeitoMenu),

  send(FormDialog, append, new(MotivoMenu, menu('Motivação:', cycle))),
  motivacoes_menu(MotivoMenu),

  send(FormDialog, append, button(ok,
    and(message(@prolog,  add_motivacao, MainDialog, SuspeitoMenu?selection, Vitima, inveja),
        message(FormDialog, destroy)))),
  send(FormDialog, append, button(cancel, message(FormDialog, destroy))),

  send(FormDialog, open).

suspeitos_menu(SuspeitoMenu) :-
  possivel_suspeito(Pessoa),
  send(SuspeitoMenu, append, menu_item(Pessoa)), fail.
suspeitos_menu(_).

motivacoes_menu(MotivoMenu) :-
  tem_motivo_contra(_, _, Motivo),
  send(MotivoMenu, append, menu_item(Motivo)), fail.
motivacoes_menu(_).

tipos_crimes_menu(CrimeMenu) :-
  tipo_crime(Crime),
  send(CrimeMenu, append, menu_item(Crime)), fail.
tipos_crimes_menu(_).

dias_semana_menu(DiaMenu) :-
  dia(Dia),
  send(DiaMenu, append, menu_item(Dia)), fail.
dias_semana_menu(_).

locais_menu(LocalMenu) :-
  local(Local),
  send(LocalMenu, append, menu_item(Local)), fail.
locais_menu(_).

add_local(MainDialog, Pessoa, Dia, Lugar) :-
  adiciona_fato(estava(Pessoa, Dia, Lugar)),
  gera_fatos_sobre_suspeitos(_),
  atualiza_resultado_suspeitos_menu(MainDialog).

add_motivacao(MainDialog, Suspeito, Vitima, inveja) :-
  adiciona_fato(inveja(Suspeito, Vitima)),
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
