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

  EServiceException = class(Exception);

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
    function Request(Method, Route: string; Payload: TStringList = nil; Headers: TStrings = nil): string;
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

function TServices.Request(Method, Route: string; Payload: TStringList = nil; Headers: TStrings = nil): string;
var
  ResponseStream: TStringStream;
  RequestStream: TStringStream;
  URL: string;
  HeaderItem: string;
  SepPos: Integer;
  HeaderName, HeaderValue: string;
begin
  ResponseStream := TStringStream.Create('', TEncoding.UTF8);
  RequestStream := TStringStream.Create('', TEncoding.UTF8);
  try
    URL := FBaseUri + Route;

    HTTP.Request.CustomHeaders.Clear;
    if Headers <> nil then
    begin
      for HeaderItem in Headers do
      begin
        SepPos := Pos(':', HeaderItem);
        if SepPos > 0 then
        begin
          HeaderName := Trim(Copy(HeaderItem, 1, SepPos - 1));
          HeaderValue := Trim(Copy(HeaderItem, SepPos + 1, MaxInt));
          if SameText(HeaderName, 'Content-Type') then
            HTTP.Request.ContentType := HeaderValue
          else if SameText(HeaderName, 'Accept') then
            HTTP.Request.Accept := HeaderValue
          else
            HTTP.Request.CustomHeaders.Values[HeaderName] := HeaderValue;
        end
        else
          HTTP.Request.CustomHeaders.Add(HeaderItem);
      end;
    end;

    if (Payload <> nil) and (Payload.Text <> '') then
      RequestStream.WriteString(Payload.Text);
    RequestStream.Position := 0;

    try
      if Method = 'GET' then
      begin
        HTTP.Get(URL, ResponseStream);
        Result := ResponseStream.DataString;
      end
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
        HTTP.Delete(URL, ResponseStream);
        Result := ResponseStream.DataString;
        if Result = '' then
          Result := HTTP.ResponseText;
      end
      else
        raise EServiceException.Create('Método HTTP não suportado: ' + Method);

    except
      on E: EIdHTTPProtocolException do
      begin
        FError.Code := IntToStr(E.ErrorCode);
        FError.Message := E.Message;
        Result := E.ErrorMessage;
        if Result = '' then
          Result := Format('{"error": {"code": "%d", "message": "%s"}}', [E.ErrorCode, E.Message]);
      end;
      on E: Exception do
      begin
        FError.Code := '500';
        FError.Message := E.Message;
        Result := Format('{"error": {"code": "%s", "message": "%s"}}', [FError.Code, FError.Message]);
      end;
    end;
  finally
    ResponseStream.Free;
    RequestStream.Free;
  end;
end;

end.
