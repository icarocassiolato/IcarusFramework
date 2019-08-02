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
    public
      class function GetInstance: TConexaoBanco;
      class property Conexao: TRESTDWDataBase read FConexao;
  end;

implementation

uses
  SysUtils;

constructor TConexaoBanco.CreatePrivate;
begin
  inherited Create;

  FConexao := TRESTDWDataBase.Create(nil);
  FConexao.PoolerService := '127.0.0.1';
  FConexao.PoolerPort := 8081;
  FConexao.PoolerName := 'TDMServidor.RESTDWPoolerDB';
  FConexao.Login := 'testserver';
  FConexao.Password := 'testserver';
  FConexao.Open;
end;

class function TConexaoBanco.GetInstance: TConexaoBanco;
begin
  if not Assigned(FInstance) then
    FInstance := TConexaoBanco.CreatePrivate;
  Result := FInstance;
end;

end.
