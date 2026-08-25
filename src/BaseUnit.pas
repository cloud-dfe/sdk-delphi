unit BaseUnit;

interface

uses
  System.SysUtils, System.Classes, ClientUnit, ServicesUnit, System.RegularExpressions, System.JSON;

type
  EBaseException = class(Exception);

  TBase = class
  protected
    FClient: TClient;

    const
      AMBIENTE_PRODUCAO = 1;
      AMBIENTE_HOMOLOGACAO = 2;

    function CheckKey(const Payload: TJSONObject): string; overload;
    function CheckKey(const Chave: string): string; overload;

  public
    constructor Create(Params: TJSONObject);
    destructor Destroy; override;

    property Client: TClient read FClient;
  end;

implementation

{ TBase }

constructor TBase.Create(Params: TJSONObject);
begin
  if not Assigned(Params) then
    raise EBaseException.Create('Devem ser passados os parametros básicos.');

  FClient := TClient.Create(Params);
end;

destructor TBase.Destroy;
begin
  if Assigned(FClient) then
    FClient.Free;
  inherited;
end;

function TBase.CheckKey(const Payload: TJSONObject): string;
var
  Val: TJSONValue;
  ChaveStr: string;
begin
  if not Assigned(Payload) then
    raise EBaseException.Create('O payload não pode ser nulo.');

  ChaveStr := '';
  Val := Payload.GetValue<TJSONValue>('chave', nil);
  if Val <> nil then
    ChaveStr := Val.Value;

  Result := CheckKey(ChaveStr);
end;

function TBase.CheckKey(const Chave: string): string;
var
  Key: string;
begin
  Key := TRegEx.Replace(Chave, '\D', '');

  if (Key = '') or ((Key.Length <> 44) and (Key.Length <> 50)) then
    raise EBaseException.Create('A chave deve ter 44 digitos para DFe as NFSe possui 50 digitos');

  Result := Key;
end;

end.
