unit uPaiControle;

interface


{    for caAtributo in rpPropriedade.GetAttributes do
      if caAtributo is TCampoTabelaExterna then
        fCampo.ProviderFlags := fCampo.ProviderFlags + [pfInUpdate];}

uses
  uConexaoBanco, uLigacao, uConstrutorSQL, uAtributosCustomizados,
  SysUtils, Classes, Variants, uRESTDWPoolerDB, Data.DB;

type
  TControle = class(TRESTDWClientSQL)
  private
    FDataSource: TDataSource;
    FFormulario: TComponent;
    FLigacao: TLigacao;
    procedure OnAfterScroll(DataSet: TDataSet);
    procedure OnBeforePost(DataSet: TDataSet);
    procedure AbrirQuery(psWhere: string = '');
    procedure CriarLigacao(psNomePropriedade: string);
    function WhereCodigo(pnCodigo: integer): string;
    function LigarComponente(psPrefixoComponente, psPropriedadeComponente,
      psNomeCampo: string): boolean;
    procedure PreencherDataSet;
    procedure PreencherPropriedades;
    procedure DesabilitarCamposTabelaSecundaria(pslCampos: TStringList);
  protected
    FTabela: string;
  public
    constructor Create(poFormulario: TComponent); overload;
    constructor Create(pnCodigo: integer); overload;
    destructor Destroy; override;
    procedure PesquisarPorCodigo(pnCodigoAntigo, pnCodigoNovo: integer);
    property DataSource: TDataSource read FDataSource write FDataSource;
end;

implementation

uses
  System.RTTI;

{ TControle }

constructor TControle.Create(pnCodigo: integer);
begin
  inherited Create(nil);
  FTabela := ClassName.Substring(1);

  DataBase := TConexaoBanco.GetInstance.Conexao;
  UpdateTableName := FTabela;
  AfterScroll := OnAfterScroll;
  BeforePost := OnBeforePost;

  FDataSource := TDataSource.Create(nil);
  FDataSource.DataSet := Self;

  FLigacao := TLigacao.Create(Self);

  if (pnCodigo > 0) or not Assigned(FFormulario) then
    AbrirQuery(WhereCodigo(pnCodigo))
  else
    AbrirQuery;
end;

constructor TControle.Create(poFormulario: TComponent);
begin
  FFormulario := poFormulario;
  Create(0);
end;

destructor TControle.Destroy;
begin
  if Assigned(FDataSource) then
    FreeAndNil(FDataSource);

  FreeAndNil(FLigacao);
  inherited;
end;

procedure TControle.OnAfterScroll(DataSet: TDataSet);
begin
  PreencherPropriedades;
end;

procedure TControle.OnBeforePost(DataSet: TDataSet);
begin
  PreencherDataSet;
end;

procedure TControle.DesabilitarCamposTabelaSecundaria(pslCampos: TStringList);
var
  i: Integer;
  oCampo: TField;
  sNomeCampo: string;
begin
  for i := 0 to Pred(pslCampos.Count) do
  begin
    sNomeCampo := pslCampos[i].Substring(pslCampos[i].LastDelimiter(' ') + 1);
    oCampo := FindField(sNomeCampo);
    if Assigned(oCampo) then
      oCampo.ProviderFlags := [];
  end;
end;

procedure TControle.AbrirQuery(psWhere: string = '');
var
  FConstrutorSQL: TConstrutorSQL;
begin
  FConstrutorSQL := TConstrutorSQL.Create;
  try
    FConstrutorSQL.Construir(Self);
    FConstrutorSQL.Condicoes.Text := psWhere;

    if Active then
      Close;

    Open(FConstrutorSQL.SQLGerado);
    First;
    DesabilitarCamposTabelaSecundaria(FConstrutorSQL.CamposTabelaSecundaria);
  finally
    FreeAndNil(FConstrutorSQL);
  end;
end;

function TControle.WhereCodigo(pnCodigo: integer): string;
begin
  Result := 'ID' + FTabela + ' = ' + VarToStr(pnCodigo);
end;

procedure TControle.PesquisarPorCodigo(pnCodigoAntigo, pnCodigoNovo: integer);
begin
  if pnCodigoAntigo <> pnCodigoNovo then
    AbrirQuery(WhereCodigo(pnCodigoNovo));
end;

procedure TControle.PreencherPropriedades;
var
  Ctx: TRttiContext;
  rpPropriedade: TRttiProperty;
  fCampo: TField;
begin
  for rpPropriedade in Ctx.GetType(Self.ClassType).GetDeclaredProperties do
  begin
    fCampo := FindField(rpPropriedade.Name);

    if fCampo = nil then
      continue;

    if (rpPropriedade.GetValue(Self).Kind = tkClass) then
      continue;

    rpPropriedade.SetValue(Self, TValue.FromVariant(fCampo.Value));
    //passar só uma vez
    CriarLigacao(rpPropriedade.Name);
  end;
end;

procedure TControle.PreencherDataSet;
var
  Ctx: TRttiContext;
  rpPropriedade: TRttiProperty;
  fCampo: TField;
begin
  for rpPropriedade in Ctx.GetType(Self.ClassType).GetDeclaredProperties do
  begin
    fCampo := FindField(rpPropriedade.Name);

    if fCampo = nil then
      continue;

    fCampo.Value := rpPropriedade.GetValue(Self).AsVariant;
  end;
end;

function TControle.LigarComponente(psPrefixoComponente, psPropriedadeComponente, psNomeCampo: string): boolean;
var
  oComponent: TComponent;
begin
  Result := False;
  oComponent := FFormulario.FindComponent(psPrefixoComponente+psNomeCampo);

  if not Assigned(oComponent) then
    Exit;

  FLigacao.Ligar(psNomeCampo, oComponent, psPropriedadeComponente);
  Result := True;
end;

procedure TControle.CriarLigacao(psNomePropriedade: string);
begin
  if not Assigned(FFormulario) then
    Exit;

  if LigarComponente('Edt', 'Text', psNomePropriedade) then
    Exit;

  if LigarComponente('Mmo', 'Text', psNomePropriedade) then
    Exit;
end;

end.
