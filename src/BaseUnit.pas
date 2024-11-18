unit BaseUnit;

interface

uses
  System.SysUtils, System.Classes, ClientUnit, ServicesUnit, IdHTTP, System.RegularExpressions, System.JSON;

type
  EBaseException = class(Exception);

  TBase = class
  protected
    FClient: TClient;

    const
      AMBIENTE_PRODUCAO = 1;
      AMBIENTE_HOMOLOGACAO = 2;

    function CheckKey(const Payload: TJSONObject): string;

  public
    constructor Create(Params: TJSONObject);
    destructor Destroy; override;
  end;

implementation

{ TBase }

constructor TBase.Create(Params: TJSONObject);
var
  Token: string;
  Ambiente: Integer;
  Timeout, Port: Integer;
  Debug: Boolean;
begin
  if not Assigned(Params) then
    raise EBaseException.Create('Os parâmetros não podem ser nulos.');

  Token := Params.GetValue<string>('token', '');
  if Token.IsEmpty then
    raise EBaseException.Create('O token é obrigatório.');

  Ambiente := Params.GetValue<Integer>('ambiente', AMBIENTE_HOMOLOGACAO);
  Timeout := Params.GetValue<Integer>('timeout', 60);
  Port := Params.GetValue<Integer>('port', 443);
  Debug := Params.GetValue<Boolean>('debug', False);

  FClient := TClient.Create(Ambiente, Token, Timeout, Port, Debug);
end;

destructor TBase.Destroy;
begin
  FClient.Free;
  inherited;
end;

function TBase.CheckKey(const Payload: TJSONObject): string;
var
  Key: string;
begin
  if not Assigned(Payload) then
    raise EBaseException.Create('O payload não pode ser nulo.');

  Key := TRegEx.Replace(Payload.GetValue<string>('chave', ''), '\D', '');

  if (Key = '') or (Key.Length <> 44) then
    raise EBaseException.Create('A chave deve ter 44 dígitos numéricos.');

  Result := Key;
end;

end.
