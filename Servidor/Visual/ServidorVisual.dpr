program ServidorVisual;

uses
  System.StartUpCopy,
  FMX.Forms,
  uFrmServidor in 'uFrmServidor.pas' {FrmServidor},
  uDMServidor in 'uDMServidor.pas' {DMServidor: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmServidor, FrmServidor);
  Application.Run;
end.
