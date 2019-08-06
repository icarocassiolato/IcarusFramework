program IcarusFramework;

uses
  System.StartUpCopy,
  FMX.Forms,
  uLigacao in 'Kernel\Outros\uLigacao.pas',
  uPaiControle in 'Kernel\Controle\uPaiControle.pas',
  uConexaoBanco in 'Kernel\Outros\uConexaoBanco.pas',
  uConstrutorSQL in 'Kernel\Outros\uConstrutorSQL.pas',
  uAtributosCustomizados in 'Kernel\Outros\uAtributosCustomizados.pas',
  uPaiVisual in 'Kernel\Visual\uPaiVisual.pas' {PaiFrm},
  uUsuario in 'Cadastros\Modelo\uUsuario.pas',
  uCidade in 'Cadastros\Modelo\uCidade.pas',
  uEstado in 'Cadastros\Modelo\uEstado.pas',
  uUsuarioVisual in 'Cadastros\Visual\uUsuarioVisual.pas' {UsuarioFrm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TUsuarioFrm, UsuarioFrm);
  Application.Run;
  FreeMemory(TConexaoBanco.Conexao);
  FreeMemory(TConexaoBanco.GetInstance);
end.
