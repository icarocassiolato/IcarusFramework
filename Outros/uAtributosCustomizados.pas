unit uAtributosCustomizados;

interface

type
  TCampoTabelaExterna = class(TCustomAttribute)
  private
    FNome: string;
  public
    constructor Create(const psNome: string);
    property Nome: string read FNome;
  end;

implementation

{ TCampoTabelaExterna }

constructor TCampoTabelaExterna.Create(const psNome: string);
begin
  FNome := psNome;
end;

end.
