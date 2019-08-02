unit uPaiControle;

interface

uses
  uConexaoBanco, uLigacao,
  SysUtils, Classes, Variants, uRESTDWPoolerDB, Data.DB;

type
  TTipoOperacao = (toPreencherDataSet, toPreencherPropriedades, toCriarLink);

  TControle = class(TLigacao)
  private
    FDataSource: TDataSource;
    FQuery: TRESTDWClientSQL;
    FFormulario: TComponent;
    procedure VarrerPropriedades(pTipoOperacao: TTipoOperacao);
    procedure AfterScroll(DataSet: TDataSet);
    procedure BeforePost(DataSet: TDataSet);
    procedure AbrirQuery(psWhere: string = '');
    procedure CriarLigacao(psNomePropriedade: string);
    function FormatarSQL(psWhere: string = ''): string;
    function WhereCodigo(pnCodigo: integer): string;
    function LigarComponente(psPrefixoComponente, psPropriedadeComponente,
      psNomeCampo: string): boolean;
  protected
    FTabela: string;
  public
    constructor Create(poFormulario: TComponent); overload;
    constructor Create(pnCodigo: integer); overload;
    destructor Destroy; override;
    procedure PesquisarPorCodigo(pnCodigo: integer);
    property Query: TRESTDWClientSQL read FQuery write FQuery;
    property DataSource: TDataSource read FDataSource write FDataSource;
end;

implementation

uses
  System.RTTI;

{ TControle }

constructor TControle.Create(pnCodigo: integer);
begin
  inherited Create;
  FTabela := ClassName.Substring(1);

  FQuery := TRESTDWClientSQL.Create(nil);
  FQuery.DataBase := TConexaoBanco.GetInstance.Conexao;
  FQuery.UpdateTableName := FTabela;
  FQuery.AfterScroll := AfterScroll;
  FQuery.BeforePost := BeforePost;

  FDataSource := TDataSource.Create(nil);
  FDataSource.DataSet := FQuery;

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

  FreeAndNil(FQuery);

  inherited;
end;

procedure TControle.AfterScroll(DataSet: TDataSet);
begin
  inherited;
  VarrerPropriedades(toPreencherPropriedades);
end;

procedure TControle.BeforePost(DataSet: TDataSet);
begin
  inherited;
  VarrerPropriedades(toPreencherDataSet);
end;

function TControle.FormatarSQL(psWhere: string = ''): string;
begin
  Result := Format('SELECT * FROM %s ', [FTabela]);
  if psWhere.Length > 0 then
    Result := Result + ' WHERE ' + psWhere;
end;

procedure TControle.AbrirQuery(psWhere: string = '');
begin
  if FQuery.Active then
    FQuery.Close;

  FQuery.Open(FormatarSQL(psWhere));
  FQuery.First;
end;

function TControle.WhereCodigo(pnCodigo: integer): string;
begin
  Result := 'ID' + FTabela + ' = ' + VarToStr(pnCodigo);
end;

procedure TControle.PesquisarPorCodigo(pnCodigo: integer);
begin
  AbrirQuery(WhereCodigo(pnCodigo));
  VarrerPropriedades(toPreencherPropriedades);
end;

procedure TControle.VarrerPropriedades(pTipoOperacao: TTipoOperacao);
var
  Ctx: TRttiContext;
  rpPropriedade: TRttiProperty;
  fCampo: TField;
begin
  Ctx := TRttiContext.Create;
  try
    for rpPropriedade in Ctx.GetType(Self.ClassType).GetDeclaredProperties do
    begin
      fCampo := FQuery.FindField(rpPropriedade.Name);

      if fCampo = nil then
        continue;

      case pTipoOperacao of
        toPreencherPropriedades: begin
          //se não é FK
          if (rpPropriedade.GetValue(Self).Kind = tkUnknown) then
            continue;

          rpPropriedade.SetValue(Self, TValue.FromVariant(fCampo.Value));
          //passar só uma vez
          CriarLigacao(rpPropriedade.Name);
        end;
        toPreencherDataSet: fCampo.Value := rpPropriedade.GetValue(Self).AsVariant;
      end;
    end;
  finally
    Ctx.Free;
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

  Ligar(psNomeCampo, oComponent, psPropriedadeComponente);
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
