unit ClientUnit;

interface

uses
  System.SysUtils, System.Classes, ServicesUnit, System.JSON, System.StrUtils;

type
  EClientException = class(Exception);

  TClient = class
  private
    const
      URL_PRODUCAO = 'https://api.integranotas.com.br';
      URL_HOMOLOGACAO = 'https://hom-api.integranotas.com.br';

      AMBIENTE_PRODUCAO = 1;
      AMBIENTE_HOMOLOGACAO = 2;

    var
      FAmbiente: Integer;
      FToken: string;
      FTimeout: Integer;
      FPort: Integer;
      FDebug: Boolean;
      FDefaultVersion: string;
      FServices: TServices;

    function BuildRoute(const Route, Version: string): string;

  public
    constructor Create(Ambiente: Integer; Token: string; Timeout: Integer = 60; Port: Integer = 443; Debug: Boolean = False; DefaultVersion: string = '1'); overload;
    constructor Create(Params: TJSONObject); overload;
    destructor Destroy; override;

    function Send(Method, Route: string; Payload: TJSONObject = nil; Version: string = ''): string; overload;
    function Send(Method, Route: string; const PayloadJson: string; Version: string = ''): string; overload;

    property Services: TServices read FServices;
    property Ambiente: Integer read FAmbiente;
    property Token: string read FToken;
    property Timeout: Integer read FTimeout;
    property Port: Integer read FPort;
    property Debug: Boolean read FDebug;
    property DefaultVersion: string read FDefaultVersion write FDefaultVersion;
  end;

implementation

{ TClient }

constructor TClient.Create(Ambiente: Integer; Token: string; Timeout: Integer = 60; Port: Integer = 443; Debug: Boolean = False; DefaultVersion: string = '1');
var
  Config: TConfigServices;
  BaseURL: string;
begin
  if Token.Trim.IsEmpty then
    raise EClientException.Create('O token é obrigatório.');

  if not (Ambiente in [AMBIENTE_PRODUCAO, AMBIENTE_HOMOLOGACAO]) then
    raise EClientException.Create('O ambiente deve ser 1 (produção) ou 2 (homologação).');

  FAmbiente := Ambiente;
  FToken := Token;
  FTimeout := Timeout;
  FPort := Port;
  FDebug := Debug;
  if DefaultVersion.Trim.IsEmpty then
    FDefaultVersion := '1'
  else
    FDefaultVersion := DefaultVersion;

  if FAmbiente = AMBIENTE_PRODUCAO then
    BaseURL := URL_PRODUCAO
  else
    BaseURL := URL_HOMOLOGACAO;

  Config.BaseUri := BaseURL;
  Config.Timeout := FTimeout;
  Config.Port := FPort;
  Config.Debug := FDebug;

  FServices := TServices.Create(Config);
end;

constructor TClient.Create(Params: TJSONObject);
var
  AmbienteParam, TimeoutParam, PortParam: Integer;
  TokenParam, VersionParam: string;
  DebugParam: Boolean;
  OptionsObj: TJSONObject;
  Val: TJSONValue;
begin
  if not Assigned(Params) then
    raise EClientException.Create('Devem ser passados os parametros básicos.');

  AmbienteParam := AMBIENTE_HOMOLOGACAO;
  Val := Params.GetValue<TJSONValue>('ambiente', nil);
  if Val <> nil then
    AmbienteParam := StrToIntDef(Val.Value, AMBIENTE_HOMOLOGACAO);

  TokenParam := '';
  Val := Params.GetValue<TJSONValue>('token', nil);
  if Val <> nil then
    TokenParam := Val.Value;

  TimeoutParam := 60;
  Val := Params.GetValue<TJSONValue>('timeout', nil);
  if Val <> nil then
    TimeoutParam := StrToIntDef(Val.Value, 60);

  PortParam := 443;
  Val := Params.GetValue<TJSONValue>('port', nil);
  if Val <> nil then
    PortParam := StrToIntDef(Val.Value, 443);

  DebugParam := False;
  Val := Params.GetValue<TJSONValue>('debug', nil);
  if Val <> nil then
    DebugParam := SameText(Val.Value, 'true') or (Val.Value = '1');

  VersionParam := '1';
  Val := Params.GetValue<TJSONValue>('version', nil);
  if Val <> nil then
    VersionParam := Val.Value;

  OptionsObj := Params.GetValue<TJSONObject>('options', nil);
  if Assigned(OptionsObj) then
  begin
    Val := OptionsObj.GetValue<TJSONValue>('timeout', nil);
    if Val <> nil then
      TimeoutParam := StrToIntDef(Val.Value, TimeoutParam);

    Val := OptionsObj.GetValue<TJSONValue>('port', nil);
    if Val <> nil then
      PortParam := StrToIntDef(Val.Value, PortParam);

    Val := OptionsObj.GetValue<TJSONValue>('debug', nil);
    if Val <> nil then
      DebugParam := SameText(Val.Value, 'true') or (Val.Value = '1');
  end;

  Create(AmbienteParam, TokenParam, TimeoutParam, PortParam, DebugParam, VersionParam);
end;

destructor TClient.Destroy;
begin
  if Assigned(FServices) then
    FServices.Free;
  inherited;
end;

function TClient.BuildRoute(const Route, Version: string): string;
var
  V: string;
  R: string;
begin
  R := Route.Trim;
  if (R <> '') and (R[1] <> '/') then
    R := '/' + R;

  // Se a rota ja comecar explicitamente com /v1/, /v2/, etc., mantem
  if R.StartsWith('/v1/', True) or R.StartsWith('/v2/', True) or R.StartsWith('/v3/', True) then
    Exit(R);

  if Version.Trim.IsEmpty then
    V := FDefaultVersion
  else
    V := Version.Trim;

  Result := '/v' + V + R;
end;

function TClient.Send(Method, Route: string; Payload: TJSONObject = nil; Version: string = ''): string;
var
  PayloadStr: string;
begin
  PayloadStr := '';
  if Assigned(Payload) then
    PayloadStr := Payload.ToJSON;
  Result := Send(Method, Route, PayloadStr, Version);
end;

function TClient.Send(Method, Route: string; const PayloadJson: string; Version: string = ''): string;
var
  Headers: TStrings;
  PayloadList: TStringList;
  FullRoute: string;
begin
  Headers := TStringList.Create;
  PayloadList := TStringList.Create;
  try
    Headers.Add('Authorization: ' + FToken);
    Headers.Add('Content-Type: application/json');
    Headers.Add('Accept: application/json');

    if not PayloadJson.IsEmpty then
      PayloadList.Text := PayloadJson;

    FullRoute := BuildRoute(Route, Version);
    Result := FServices.Request(Method, FullRoute, PayloadList, Headers);
  finally
    Headers.Free;
    PayloadList.Free;
  end;
end;

end.
