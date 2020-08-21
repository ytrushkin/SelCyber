program SelCyber;

uses
  Forms,
  main in 'main.pas' {Frm_Main},
  Options in 'Options.pas' {Frm_Options},
  AppData in 'AppData.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrm_Main, Frm_Main);
  Application.CreateForm(TFrm_Options, Frm_Options);
  Application.Run;
end.
