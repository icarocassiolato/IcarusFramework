unit uEstado;

interface

uses 
  uPaiControle;

type                        
  TEstado = class(TControle)  
    private                 
      FIdEstado: Integer;
      FSigla: string;
      FNome: string;
    public
      property IdEstado: Integer read FIdEstado write FIdEstado;
      property Sigla: string read FSigla write FSigla;
      property Nome: string read FNome write FNome;
    end;                    

implementation              

{ TEstado }

end.
