:- [regras].

iniciar :-
  new(Frame, frame('Investigacao Criminal')),
  send(Frame, append(new(Browser, browser))),
  send(new(Dialog, dialog), below(Browser)),
  send(Dialog, append(button("fechar", message(Frame, destroy)))),
  forall(possivel_suspeito(Pessoa), send(Browser, append, Pessoa)),
  send(Frame, open).
