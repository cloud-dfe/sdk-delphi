unit ClientUnit;

interface

uses
  System.SysUtils, System.Classes, ServicesUnit, IdHTTP, System.JSON, System.StrUtils; // Adicionei System.StrUtils

type
  EClientException = class(Exception);

  TClient = class
  private
    const
      URL_PRODUCAO = 'https://api.integranotas.com.br/v1';
      URL_HOMOLOGACAO = 'https://hom-api.integranotas.com.br/v1';

      AMBIENTE_PRODUCAO = 1;
      AMBIENTE_HOMOLOGACAO = 2;

    var
      FAmbiente: Integer;
      FToken: string;
      FTimeout: Integer;
      FPort: Integer;
      FDebug: Boolean;
      FServices: TServices;

  public
    constructor Create(Ambiente: Integer; Token: string; Timeout: Integer = 60; Port: Integer = 443; Debug: Boolean = False);
    destructor Destroy; override;

    function Send(Method, Route: string; Payload: TJSONObject = nil): string;
    function SendMultipart(Route: string; Payload: TJSONObject): string;
  end;

implementation

{ TClient }

constructor TClient.Create(Ambiente: Integer; Token: string; Timeout: Integer = 60; Port: Integer = 443; Debug: Boolean = False);
var
  Config: TConfigServices;
begin
  if Token.IsEmpty then
    raise EClientException.Create('O token é obrigatório.');

  if not (Ambiente in [AMBIENTE_PRODUCAO, AMBIENTE_HOMOLOGACAO]) then
    raise EClientException.Create('O ambiente deve ser 1 (produção) ou 2 (homologação).');

  FAmbiente := Ambiente;
  FToken := Token;
  FTimeout := Timeout;
  FPort := Port;
  FDebug := Debug;

  // Corrigindo o uso de IfThen para configurar BaseUri
  Config.BaseUri := IfThen(FAmbiente = AMBIENTE_PRODUCAO, URL_PRODUCAO, URL_HOMOLOGACAO);
  Config.Timeout := FTimeout;
  Config.Port := FPort;
  Config.Debug := FDebug;

  FServices := TServices.Create(Config);
end;

destructor TClient.Destroy;
begin
  FServices.Free;
  inherited;
end;

function TClient.Send(Method, Route: string; Payload: TJSONObject = nil): string;
var
  Headers: TStrings;
  PayloadStr: TStringList;
begin
  Headers := TStringList.Create;
  PayloadStr := TStringList.Create;
  try
    Headers.Add('Authorization: ' + FToken);
    Headers.Add('Content-Type: application/json');
    Headers.Add('Accept: application/json');

    if Payload <> nil then
      PayloadStr.Text := Payload.ToJSON;

    Result := FServices.Request(Method, Route, PayloadStr, Headers);
  finally
    Headers.Free;
    PayloadStr.Free;
  end;
end;

function TClient.SendMultipart(Route: string; Payload: TJSONObject): string;
var
  Headers: TStrings;
  PayloadStr: TStringList;
begin
  Headers := TStringList.Create;
  PayloadStr := TStringList.Create;
  try
    Headers.Add('Authorization: ' + FToken);
    Headers.Add('Content-Type: multipart/form-data');
    Headers.Add('Accept: application/json');

    if Payload <> nil then
      PayloadStr.Text := Payload.ToJSON;

    Result := FServices.Request('POST', Route, PayloadStr, Headers);
  finally
    Headers.Free;
    PayloadStr.Free;
  end;
end;

end.

