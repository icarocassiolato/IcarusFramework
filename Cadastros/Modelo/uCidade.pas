unit uCidade;

interface

uses
  uPaiControle, uEstado;

type
  TCidade = class(TControle)
    private
      FIdCidade: Integer;
      FNome: string;
      FIdEstado: integer;
      FEstado: TEstado;
      function GetEstado: TEstado;
    public
      destructor Destroy; override;
      property IdCidade: Integer read FIdCidade write FIdCidade;
      property Nome: string read FNome write FNome;
      property IdEstado: integer read FIdEstado write FIdEstado;
      property Estado: TEstado read GetEstado;
    end;

implementation

uses
  SysUtils;

{ TCidade }

destructor TCidade.Destroy;
begin
  if FEstado <> nil then
    FreeAndNil(FEstado);

  inherited;
end;

{$REGION 'Getters'}
function TCidade.GetEstado: TEstado;
begin
  if FEstado = nil then
    FEstado := TEstado.Create(FIdEstado)
  else
    if FEstado.IdEstado <> FIdEstado then
      FEstado.PesquisarPorCodigo(FIdEstado);

  Result := FEstado;
end;
{$ENDREGION}

end.
