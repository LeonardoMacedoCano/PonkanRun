program PonkanRun;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain in 'uMain.pas' {frmMain},
  uAvatar in 'classes\uAvatar.pas',
  uObst in 'classes\uObst.pas',
  uChao in 'classes\uChao.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
