unit uLigacao;

interface

uses
  Generics.Collections, System.Bindings.Expression, System.Bindings.Helper,
  //FMX
  FMX.Edit, FMX.Memo
  ;

type
  TLigacao = class
  protected
    type
      TExpressionList = TObjectList<TBindingExpression>;
  private
    FBindings: TExpressionList;
    FOwner: TObject;
    procedure OnChangeTracking(Sender: TObject);
  protected
    procedure Notify(const APropertyName: string = '');
    property Bindings: TExpressionList read FBindings;
  public
    constructor Create(poOwner: TObject);
    destructor Destroy; override;
    procedure Ligar(const AProperty: string; const ABindToObject: TObject;
        const ABindToProperty: string; const ACreateOptions:
        TBindings.TCreateOptions = [coNotifyOutput, coEvaluate]);
    procedure ClearBindings;
  end;

implementation

uses
  SysUtils;

constructor TLigacao.Create(poOwner: TObject);
begin
  FOwner := poOwner;
  FBindings := TExpressionList.Create(False);
end;

destructor TLigacao.Destroy;
begin
  FreeAndNil(FBindings);
  inherited;
end;

procedure TLigacao.ClearBindings;
var
  i: TBindingExpression;
begin
  for i in FBindings do
    TBindings.RemoveBinding(i);

  FBindings.Clear;
end;

procedure TLigacao.Ligar(const AProperty: string;
  const ABindToObject: TObject; const ABindToProperty: string;
  const ACreateOptions: TBindings.TCreateOptions);
var
  oExpressaoIda,
  oExpressaoVolta: TBindingExpression;
begin
  oExpressaoIda := TBindings.CreateManagedBinding(
    [TBindings.CreateAssociationScope([Associate(FOwner, 'src')])], 'src.' + AProperty,
    [TBindings.CreateAssociationScope([Associate(ABindToObject, 'dst')])], 'dst.' + ABindToProperty,
    nil, nil, ACreateOptions);

  if FBindings.IndexOf(oExpressaoIda) > 0 then
  begin
    FreeAndNil(oExpressaoIda);
    Exit;
  end;

  FBindings.Add(oExpressaoIda);

  oExpressaoVolta := TBindings.CreateManagedBinding(
    [TBindings.CreateAssociationScope([Associate(ABindToObject, 'src')])], 'src.' + ABindToProperty,
    [TBindings.CreateAssociationScope([Associate(FOwner, 'dst')])], 'dst.' + AProperty,
    nil, nil, ACreateOptions);

  FBindings.Add(oExpressaoVolta);

  if ABindToObject is TEdit then
    TEdit(ABindToObject).OnChangeTracking := OnChangeTracking;

  if ABindToObject is TMemo then
    TMemo(ABindToObject).OnChangeTracking := OnChangeTracking;
end;

procedure TLigacao.OnChangeTracking(Sender: TObject);
begin
  TBindings.Notify(Sender, 'Text');
end;

procedure TLigacao.Notify(const APropertyName: string);
begin
  TBindings.Notify(FOwner, APropertyName);
end;

end.
