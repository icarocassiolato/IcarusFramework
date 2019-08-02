unit uUsuarioVisual;

interface

uses
  uPaiVisual, uUsuario,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Edit, FMX.Controls.Presentation;

type
  TUsuarioFrm = class(TPaiFrm)
    EdtIdUsuario: TEdit;
    EdtNome: TEdit;
    EdtEmail: TEdit;
    EdtSenha: TEdit;
    BtnCidade: TButton;
    procedure FormCreate(Sender: TObject);
    procedure BtnCidadeClick(Sender: TObject);
  private
    FUsuario: TUsuario;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  UsuarioFrm: TUsuarioFrm;

implementation

{$R *.fmx}

procedure TUsuarioFrm.BtnCidadeClick(Sender: TObject);
begin
  ShowMessage(FUsuario.Cidade.Nome + ' - ' + FUsuario.Cidade.Estado.Sigla);
end;

procedure TUsuarioFrm.FormCreate(Sender: TObject);
begin
  FUsuario := TUsuario.Create(Self);
  FControle := FUsuario;
  inherited;
end;

end.
