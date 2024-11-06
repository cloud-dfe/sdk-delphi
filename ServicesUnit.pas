unit ServicesUnit;

interface

uses
  System.SysUtils, System.Classes, IdHTTP, IdSSLOpenSSL, System.JSON;

type
  TConfigServices = record
    BaseUri: string;
    Timeout: Integer;
    Port: Integer;
    Debug: Boolean;
  end;

  TErrorService = record
    Code: string;
    Message: string;
  end;

  TServices = class
  private
    FBaseUri: string;
    FTimeout: Integer;
    FPort: Integer;
    FDebug: Boolean;
    FError: TErrorService;
    HTTP: TIdHTTP;
    IOHandle: TIdSSLIOHandlerSocketOpenSSL;
    procedure InitializeHTTP;
  public
    constructor Create(Config: TConfigServices);
    destructor Destroy; override;
    function Request(Method, Route: string; Payload: TJSONObject = nil; Headers: TStrings = nil): string;
    property Error: TErrorService read FError;
  end;

implementation

constructor TServices.Create(Config: TConfigServices);
begin
  FBaseUri := Config.BaseUri;
  FTimeout := Config.Timeout * 1000;
  FPort := Config.Port;
  FDebug := Config.Debug;
  HTTP := TIdHTTP.Create(nil);
  IOHandle := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  InitializeHTTP;
end;

destructor TServices.Destroy;
begin
  HTTP.Free;
  IOHandle.Free;
  inherited;
end;

procedure TServices.InitializeHTTP;
begin
  HTTP.Request.BasicAuthentication := False;
  HTTP.Request.UserAgent := 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.96 Safari/537.36';
  HTTP.IOHandler := IOHandle;
  HTTP.Request.ContentType := 'application/json';
  HTTP.Request.Accept := 'application/json';
  HTTP.Request.CharSet := 'UTF-8';
  HTTP.ConnectTimeout := FTimeout;
  HTTP.ReadTimeout := FTimeout;

  IOHandle.SSLOptions.Method := sslvTLSv1_2;
  IOHandle.SSLOptions.Mode := sslmClient;
end;

function TServices.Request(Method, Route: string; Payload: TJSONObject = nil; Headers: TStrings = nil): string;
var
  ResponseStream: TStringStream;
  RequestStream: TStringStream;
  URL: string;
begin
  ResponseStream := TStringStream.Create;
  RequestStream := TStringStream.Create;
  try
    URL := FBaseUri + Route;

    if Headers <> nil then
      HTTP.Request.CustomHeaders.AddStrings(Headers);

    if Payload <> nil then
      RequestStream.WriteString(Payload.ToString);

    try
      if Method = 'GET' then
        Result := HTTP.Get(URL)
      else if Method = 'POST' then
      begin
        HTTP.Post(URL, RequestStream, ResponseStream);
        Result := ResponseStream.DataString;
      end
      else if Method = 'PUT' then
      begin
        HTTP.Put(URL, RequestStream, ResponseStream);
        Result := ResponseStream.DataString;
      end
      else if Method = 'DELETE' then
      begin
        HTTP.Delete(URL);
        Result := 'Requisi��o DELETE bem-sucedida';
      end
      else
        raise Exception.Create('M�todo HTTP n�o suportado.');

    except
      on E: EIdHTTPProtocolException do
      begin
        FError.Code := IntToStr(E.ErrorCode);
        FError.Message := E.Message;
        raise Exception.CreateFmt('Erro na requisi��o: %s', [FError.Message]);
      end;
      on E: Exception do
      begin
        FError.Code := '500';
        FError.Message := E.Message;
        raise Exception.CreateFmt('Erro desconhecido: %s', [E.Message]);
      end;
    end;
  finally
    ResponseStream.Free;
    RequestStream.Free;
  end;
end;

end.

