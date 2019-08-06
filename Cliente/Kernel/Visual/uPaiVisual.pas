unit uPaiVisual;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.StdCtrls, uPaiControle, FMX.Objects,
  uRESTDWPoolerDB, Data.DB;

type
  TSentidoDados = (sdObjetoCampo, sdCampoObjeto);
  TTipoAcao = (taIncluir, taAlterar, taCancelar, taSalvar, taDeletar,
    taPrimeiro, taAnterior, taProximo, taUltimo);

  TPaiFrm = class(TForm)
    RecCabecalho: TRectangle;
    BtnIncluir: TButton;
    BtnAlterar: TButton;
    BtnExcluir: TButton;
    BtnCancelar: TButton;
    BtnSalvar: TButton;
    BtnUltimo: TButton;
    BtnProximo: TButton;
    BtnAnterior: TButton;
    BtnPrimeiro: TButton;
    PnlAreaCadastro: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure OnClick(Sender: TObject);
  private
    FAfterScroll: TOnAfterScroll;
    FStateChange: TNotifyEvent;
    procedure HabilitarEdicao(pbInserindoEditando: boolean);
    procedure AtribuirEventos;
  protected
    FControle: TControle;
    procedure StateChange(Sender: TObject); virtual;
    procedure AfterScroll(DataSet: TDataSet); virtual;
  end;

var
  PaiFrm: TPaiFrm;

implementation

{$R *.fmx}

procedure TPaiFrm.AfterScroll(DataSet: TDataSet);
begin
  if Assigned(FAfterScroll) then
    FAfterScroll(DataSet);

  HabilitarEdicao(DataSet.State in dsEditModes);
end;

procedure TPaiFrm.StateChange(Sender: TObject);
begin
  if Assigned(FStateChange) then
    FStateChange(Sender);

  HabilitarEdicao(TDataSource(Sender).State in dsEditModes);
end;

procedure TPaiFrm.AtribuirEventos;
begin
  FAfterScroll := FControle.AfterScroll;
  FControle.AfterScroll := AfterScroll;

  FStateChange := FControle.DataSource.OnStateChange;
  FControle.DataSource.OnStateChange := StateChange;
end;

procedure TPaiFrm.FormCreate(Sender: TObject);
begin
  if not Assigned(FControle) then
    raise Exception.Create('Desenvolvedor, atribuir a variável de controle ao criar o formulário ' + TForm(Sender).Name);

  AtribuirEventos;

  HabilitarEdicao(False);
end;

procedure TPaiFrm.FormDestroy(Sender: TObject);
begin
  FAfterScroll := nil;
  FStateChange := nil;
  FreeAndNil(FControle);
end;

procedure TPaiFrm.OnClick(Sender: TObject);
begin
  case TTipoAcao(TRectangle(Sender).Tag) of
    taIncluir: FControle.Insert;
    taAlterar: FControle.Edit;
    taCancelar: FControle.Cancel;
    taSalvar: begin
      FControle.Post;
      if FControle.MassiveCount > 0 then
        FControle.ApplyUpdates;
    end;
    taDeletar: begin
      FControle.Delete;
      FControle.ApplyUpdates;
    end;
    taPrimeiro: FControle.First;
    taAnterior: FControle.Prior;
    taProximo: FControle.Next;
    taUltimo: FControle.Last;
  end;
end;

procedure TPaiFrm.HabilitarEdicao(pbInserindoEditando: boolean);
var
  bInserindoEditandoVazio: boolean;
begin
  bInserindoEditandoVazio := pbInserindoEditando or FControle.IsEmpty;

  BtnIncluir.Enabled := not pbInserindoEditando;
  BtnAlterar.Enabled := not bInserindoEditandoVazio;
  BtnCancelar.Enabled := pbInserindoEditando;
  BtnSalvar.Enabled := pbInserindoEditando;
  BtnExcluir.Enabled := not bInserindoEditandoVazio;

  BtnPrimeiro.Enabled := not bInserindoEditandoVazio;
  BtnAnterior.Enabled := not bInserindoEditandoVazio;
  BtnProximo.Enabled := not bInserindoEditandoVazio;
  BtnUltimo.Enabled := not bInserindoEditandoVazio;

  PnlAreaCadastro.Enabled := pbInserindoEditando;
end;

end.
