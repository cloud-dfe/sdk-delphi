unit DfeUnit;

interface

uses
  System.SysUtils, System.Classes, BaseUnit, System.JSON, ClientUnit;

type
  EDfeException = class(EBaseException);

  TIntegraDfe = class(TBase)
  public
    function BuscaCte(const Payload: TJSONObject): string;
    function BuscaNfe(const Payload: TJSONObject): string;
    function DownloadNfe(const Payload: TJSONObject): string;
    function BuscaNfse(const Payload: TJSONObject): string;
    function DownloadNfse(const Payload: TJSONObject): string;
    function DownloadCte(const Payload: TJSONObject): string;
    function Eventos(const Payload: TJSONObject): string;
    function Backup(const Payload: TJSONObject): string;
  end;

implementation

{ TIntegraDfe }

function TIntegraDfe.BuscaCte(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/dfe/cte', Payload);
end;

function TIntegraDfe.BuscaNfe(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/dfe/nfe', Payload);
end;

function TIntegraDfe.DownloadNfe(const Payload: TJSONObject): string;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', Format('/dfe/nfe/%s', [Key]), nil);
end;

function TIntegraDfe.BuscaNfse(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/dfe/nfse', Payload);
end;

function TIntegraDfe.DownloadNfse(const Payload: TJSONObject): string;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', Format('/dfe/nfse/%s', [Key]), nil);
end;

function TIntegraDfe.DownloadCte(const Payload: TJSONObject): string;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', Format('/dfe/cte/%s', [Key]), nil);
end;

function TIntegraDfe.Eventos(const Payload: TJSONObject): string;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', Format('/dfe/eventos/%s', [Key]), nil);
end;

function TIntegraDfe.Backup(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/dfe/backup', Payload);
end;

end.
