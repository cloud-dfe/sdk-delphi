unit NfceUnit;

interface

uses
  System.SysUtils, System.Classes, BaseUnit, System.JSON, ClientUnit;

type
  ENfceException = class(EBaseException);

  TIntegraNfce = class(TBase)
  public
    function Cria(const Payload: TJSONObject): string;
    function Preview(const Payload: TJSONObject): string;
    function Status: string;
    function Consulta(const Payload: TJSONObject): string;
    function Busca(const Payload: TJSONObject): string;
    function Cancela(const Payload: TJSONObject): string;
    function Offline: string;
    function Inutiliza(const Payload: TJSONObject): string;
    function Pdf(const Payload: TJSONObject): string;
    function Substitui(const Payload: TJSONObject): string;
    function Backup(const Payload: TJSONObject): string;
    function Importa(const Payload: TJSONObject): string;
  end;

implementation

{ TIntegraNfce }

function TIntegraNfce.Cria(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfce', Payload);
end;

function TIntegraNfce.Preview(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfce/preview', Payload);
end;

function TIntegraNfce.Status: string;
begin
  Result := FClient.Send('GET', '/nfce/status', nil);
end;

function TIntegraNfce.Consulta(const Payload: TJSONObject): string;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', Format('/nfce/%s', [Key]), nil);
end;

function TIntegraNfce.Busca(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfce/busca', Payload);
end;

function TIntegraNfce.Cancela(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfce/cancela', Payload);
end;

function TIntegraNfce.Offline: string;
begin
  Result := FClient.Send('GET', '/nfce/offline', nil);
end;

function TIntegraNfce.Inutiliza(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfce/inutiliza', Payload);
end;

function TIntegraNfce.Pdf(const Payload: TJSONObject): string;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', Format('/nfce/pdf/%s', [Key]), nil);
end;

function TIntegraNfce.Substitui(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfce/substitui', Payload);
end;

function TIntegraNfce.Backup(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfce/backup', Payload);
end;

function TIntegraNfce.Importa(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfce/importa', Payload);
end;

end.
