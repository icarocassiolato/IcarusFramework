unit uConexaoBanco;

interface

uses
  uRESTDWPoolerDB;

type
  TConexaoBanco = class
  private
    class var FConexao: TRESTDWDataBase;

    class var FInstance: TConexaoBanco;
    constructor CreatePrivate;
    procedure PreencherDadosConexao;
  public
    class function GetInstance: TConexaoBanco;
    class property Conexao: TRESTDWDataBase read FConexao;
  end;

implementation

uses
  SysUtils, IniFiles;

procedure TConexaoBanco.PreencherDadosConexao;
const
  SECAO = 'CONEXAO_CLIENTE';
begin
  with TIniFile.Create(ExtractFilePath(ParamStr(0))+'Config.ini') do
  begin
    FConexao.PoolerService := ReadString(SECAO, 'Service', EmptyStr);
    FConexao.PoolerPort := ReadInteger(SECAO, 'Port', 0);
    FConexao.PoolerName := ReadString(SECAO, 'Name', EmptyStr);
    FConexao.Login := ReadString(SECAO, 'Login', EmptyStr);
    FConexao.Password := ReadString(SECAO, 'Password', EmptyStr);
    FConexao.Open;
    Free;
  end;
end;

constructor TConexaoBanco.CreatePrivate;

begin
  inherited Create;

  FConexao := TRESTDWDataBase.Create(nil);
  PreencherDadosConexao;
end;

class function TConexaoBanco.GetInstance: TConexaoBanco;
begin
  if not Assigned(FInstance) then
    FInstance := TConexaoBanco.CreatePrivate;
  Result := FInstance;
end;

end.
