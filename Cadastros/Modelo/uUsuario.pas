unit uUsuario;

interface

uses
  uPaiControle, uCidade, uAtributosCustomizados;

type
  TUsuario = class(TControle)
    private
      FIdUsuario: Integer;
      FSenha: string;
      FEmail: string;
      FNome: string;
      FIdCidade: integer;
      FCidade: TCidade;
      function GetCidade: TCidade;
    public
      destructor Destroy; override;
      property IdUsuario: Integer read FIdUsuario write FIdUsuario;
      property Senha: string read FSenha write FSenha;
      property Email: string read FEmail write FEmail;
      property Nome: string read FNome write FNome;
      property IdCidade: integer read FIdCidade write FIdCidade;
      [TCampoTabelaExterna('NOME')]
      [TCampoTabelaExterna('IDESTADO')]
      property Cidade: TCidade read GetCidade;
    end;

implementation

uses
  SysUtils;

{ TUsuario }

destructor TUsuario.Destroy;
begin
  if FCidade <> nil then
    FreeAndNil(FCidade);

  inherited;
end;

function TUsuario.GetCidade: TCidade;
begin
  if FCidade = nil then
    FCidade := TCidade.Create(FIdCidade)
  else
    FCidade.PesquisarPorCodigo(FCidade.IdCidade, FIdCidade);

  Result := FCidade;
end;

end.
