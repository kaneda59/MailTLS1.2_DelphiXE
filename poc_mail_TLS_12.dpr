program poc_mail_TLS_12;

uses
  Forms,
  main in 'main.pas' {forMain};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TforMain, forMain);
  Application.Run;
end.
