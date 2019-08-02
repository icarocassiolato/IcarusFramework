program IcarusFramework;

uses
  System.StartUpCopy,
  FMX.Forms,
  uPaiVisual in 'Kernel\Visual\uPaiVisual.pas' {PaiFrm},
  uPaiControle in 'Kernel\Controle\uPaiControle.pas',
  uConexaoBanco in 'Outros\uConexaoBanco.pas',
  uLigacao in 'Outros\uLigacao.pas',
  uUsuario in 'Cadastros\Modelo\uUsuario.pas',
  uCidade in 'Cadastros\Modelo\uCidade.pas',
  uEstado in 'Cadastros\Modelo\uEstado.pas',
  uUsuarioVisual in 'Cadastros\Visual\uUsuarioVisual.pas' {UsuarioFrm};

{$R *.res}

begin
  Application.Initialize;
  ReportMemoryLeaksOnShutdown := True;
  Application.CreateForm(TUsuarioFrm, UsuarioFrm);
  Application.Run;
  FreeMemory(TConexaoBanco.Conexao);
  FreeMemory(TConexaoBanco.GetInstance);
end.
