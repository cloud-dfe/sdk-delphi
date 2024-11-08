unit DfeUnit;

interface

uses
  System.SysUtils, System.Classes, BaseUnit, System.JSON, ClientUnit;

type
  EDfeException = class(EBaseException);

  TDfe = class(TBase)
  public
    function BuscaCte(const Payload: TJSONObject): TJSONObject;
    function BuscaNfe(const Payload: TJSONObject): TJSONObject;
    function DownloadNfe(const Payload: TJSONObject): TJSONObject;
    function BuscaNfse(const Payload: TJSONObject): TJSONObject;
    function DownloadNfse(const Payload: TJSONObject): TJSONObject;
    function DownloadCte(const Payload: TJSONObject): TJSONObject;
    function Eventos(const Payload: TJSONObject): TJSONObject;
    function Backup(const Payload: TJSONObject): TJSONObject;
  end;

implementation

{ TDfe }

function TDfe.BuscaCte(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/dfe/cte', Payload);
end;

function TDfe.BuscaNfe(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/dfe/nfe', Payload);
end;

function TDfe.DownloadNfe(const Payload: TJSONObject): TJSONObject;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', Format('/dfe/nfe/%s', [Key]), nil);
end;

function TDfe.BuscaNfse(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/dfe/nfse', Payload);
end;

function TDfe.DownloadNfse(const Payload: TJSONObject): TJSONObject;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', Format('/dfe/nfse/%s', [Key]), nil);
end;

function TDfe.DownloadCte(const Payload: TJSONObject): TJSONObject;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', Format('/dfe/cte/%s', [Key]), nil);
end;

function TDfe.Eventos(const Payload: TJSONObject): TJSONObject;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', Format('/dfe/eventos/%s', [Key]), nil);
end;

function TDfe.Backup(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/dfe/backup', Payload);
end;

end.
