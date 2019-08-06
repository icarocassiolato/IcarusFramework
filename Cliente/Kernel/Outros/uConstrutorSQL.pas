unit uConstrutorSQL;

interface

uses
  Classes;

type
  TConstrutorSQL = class
  private
    FCampos: TStringList;
    FCondicoes: TStringList;
    FTabela: string;
    FJuncoes: TStringList;
    FCamposTabelaSecundaria: TStringList;
    function JuncaoFormatada(psTabelaPrincipal, psTabelaSecundaria: string): string;
  public
    constructor Create;
    destructor Destroy;
    property Condicoes: TStringList read FCondicoes write FCondicoes;
    property CamposTabelaSecundaria: TStringList read FCamposTabelaSecundaria;
    procedure Construir(poClasse: TObject);
    function SQLGerado: string;
  end;

implementation

uses
  SysUtils, StrUtils, RTTI, uAtributosCustomizados;

{ TConstrutorSQL }

constructor TConstrutorSQL.Create;
begin
  FCampos := TStringList.Create;
  FCondicoes := TStringList.Create;
  FJuncoes := TStringList.Create;
  FCamposTabelaSecundaria := TStringList.Create;
end;

destructor TConstrutorSQL.Destroy;
begin
  FreeAndNil(FCampos);
  FreeAndNil(FCondicoes);
  FreeAndNil(FJuncoes);
  FreeAndNil(FCamposTabelaSecundaria);
end;

function TConstrutorSQL.JuncaoFormatada(psTabelaPrincipal, psTabelaSecundaria: string): string;
begin
  Result := ' LEFT JOIN %S ON (%P.ID%S = %S.ID%S) '
            .Replace('%P', psTabelaPrincipal)
            .Replace('%S', psTabelaSecundaria);
end;

function CampoSecundarioFormatado(psNomeTabela, psNomeCampo: string): string;
begin
  Result := ', %T.%C %T_%C'
            .Replace('%T', psNomeTabela)
            .Replace('%C', psNomeCampo);
end;

procedure TConstrutorSQL.Construir(poClasse: TObject);
var
  Ctx: TRttiContext;
  rpPropriedade: TRttiProperty;
  caAtributo: TCustomAttribute;
  bFazJuncao: boolean;
begin
  FTabela := poClasse.ClassName.Substring(1);
  FCampos.Clear;
  FJuncoes.Clear;
  FCamposTabelaSecundaria.Clear;
  for rpPropriedade in Ctx.GetType(poClasse.ClassType).GetDeclaredProperties do
  begin
    bFazJuncao := False;
    for caAtributo in rpPropriedade.GetAttributes do
    begin
      if caAtributo is TCampoTabelaExterna then
      begin
        FCamposTabelaSecundaria.Add(CampoSecundarioFormatado(rpPropriedade.Name, (caAtributo as TCampoTabelaExterna).Nome));
        bFazJuncao := True;
      end;
    end;

    if (rpPropriedade.GetValue(poClasse).Kind = tkClass) then
    begin
      if bFazJuncao then
        FJuncoes.Add(JuncaoFormatada(FTabela, rpPropriedade.Name));
      continue;
    end;

    FCampos.Add(',' + FTabela + '.' + rpPropriedade.Name);
  end;
  FCampos.Text := FCampos.Text.Remove(0, 1);
end;

function TConstrutorSQL.SQLGerado: string;
var
  i: integer;
begin
  Result :=
    ' SELECT ' + FCampos.Text + FCamposTabelaSecundaria.Text +
      ' FROM ' + FTabela;

  Result := Result + FJuncoes.Text;

  if FCondicoes.Count > 0 then
  begin
    Result := Result + ' WHERE ';
    for i := 0 to Pred(FCondicoes.Count) do
      Result := Result + IfThen(i > 0, ' AND ') + FCondicoes[i];
  end;
end;

end.
