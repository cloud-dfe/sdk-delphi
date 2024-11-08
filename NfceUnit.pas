unit NfceUnit;

interface

uses
  System.SysUtils, System.Classes, BaseUnit, System.JSON, ClientUnit;

type
  ENfceException = class(EBaseException);

  TNfce = class(TBase)
  public
    function Cria(const Payload: TJSONObject): TJSONObject;
    function Preview(const Payload: TJSONObject): TJSONObject;
    function Status: TJSONObject;
    function Consulta(const Payload: TJSONObject): TJSONObject;
    function Busca(const Payload: TJSONObject): TJSONObject;
    function Cancela(const Payload: TJSONObject): TJSONObject;
    function Offline: TJSONObject;
    function Inutiliza(const Payload: TJSONObject): TJSONObject;
    function Pdf(const Payload: TJSONObject): TJSONObject;
    function Substitui(const Payload: TJSONObject): TJSONObject;
    function Backup(const Payload: TJSONObject): TJSONObject;
    function Importa(const Payload: TJSONObject): TJSONObject;
  end;

implementation

{ TNfce }

function TNfce.Cria(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/nfce', Payload);
end;

function TNfce.Preview(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/nfce/preview', Payload);
end;

function TNfce.Status: TJSONObject;
begin
  Result := FClient.Send('GET', '/nfce/status', nil);
end;

function TNfce.Consulta(const Payload: TJSONObject): TJSONObject;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', Format('/nfce/%s', [Key]), nil);
end;

function TNfce.Busca(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/nfce/busca', Payload);
end;

function TNfce.Cancela(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/nfce/cancela', Payload);
end;

function TNfce.Offline: TJSONObject;
begin
  Result := FClient.Send('GET', '/nfce/offline', nil);
end;

function TNfce.Inutiliza(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/nfce/inutiliza', Payload);
end;

function TNfce.Pdf(const Payload: TJSONObject): TJSONObject;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', Format('/nfce/pdf/%s', [Key]), nil);
end;

function TNfce.Substitui(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/nfce/substitui', Payload);
end;

function TNfce.Backup(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/nfce/backup', Payload);
end;

function TNfce.Importa(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/nfce/importa', Payload);
end;

end.
