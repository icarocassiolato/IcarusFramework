unit uFrmServidor;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, uDWAbout,
  uRESTDWBase, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit;

type
  TFrmServidor = class(TForm)
    RESTServicePooler: TRESTServicePooler;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmServidor: TFrmServidor;

implementation

uses
  uDMServidor;

{$R *.fmx}

procedure TFrmServidor.FormCreate(Sender: TObject);
begin
  RESTServicePooler.ServerMethodClass := TDMServidor;
  RESTServicePooler.Active := True;
end;

end.
