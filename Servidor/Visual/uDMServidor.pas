unit uDMServidor;

interface

uses
  System.SysUtils, System.Classes, uDWDataModule, uDWAbout, uRESTDWBase,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, Data.DB, FireDAC.Comp.Client, uRESTDWPoolerDB, uRestDWDriverFD,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef;

type
  TDMServidor = class(TServermethodDataModule)
    RESTDWPoolerDB: TRESTDWPoolerDB;
    RESTDWDriverFD: TRESTDWDriverFD;
    FDConnection: TFDConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMServidor: TDMServidor;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

{ TDMServidor }

procedure TDMServidor.DataModuleCreate(Sender: TObject);
begin
  FDConnection.Open;
end;

end.
