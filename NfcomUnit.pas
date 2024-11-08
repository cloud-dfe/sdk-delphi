unit NfcomUnit;

interface

uses
  System.SysUtils, System.Classes, BaseUnit, System.JSON, ClientUnit;

type
  ENfcomException = class(EBaseException);

  TNfcom = class(TBase)
  public
    function Status: TJSONObject;
    function Cria(const Payload: TJSONObject): TJSONObject;
    function Consulta(const Payload: TJSONObject): TJSONObject;
    function Cancela(const Payload: TJSONObject): TJSONObject;
    function Busca(const Payload: TJSONObject): TJSONObject;
    function Pdf(const Payload: TJSONObject): TJSONObject;
    function Preview(const Payload: TJSONObject): TJSONObject;
    function Backup(const Payload: TJSONObject): TJSONObject;
    function Importa(const Payload: TJSONObject): TJSONObject;
  end;

implementation

{ TNfcom }

function TNfcom.Status: TJSONObject;
begin
  Result := FClient.Send('GET', '/nfcom/status', nil);
end;

function TNfcom.Cria(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/nfcom', Payload);
end;

function TNfcom.Consulta(const Payload: TJSONObject): TJSONObject;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', Format('/nfcom/%s', [Key]), Payload);
end;

function TNfcom.Cancela(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/nfcom/cancela', Payload);
end;

function TNfcom.Busca(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/nfcom/busca', Payload);
end;

function TNfcom.Pdf(const Payload: TJSONObject): TJSONObject;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', Format('/nfcom/pdf/%s', [Key]), nil);
end;

function TNfcom.Preview(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/nfcom/preview', Payload);
end;

function TNfcom.Backup(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/nfcom/backup', Payload);
end;

function TNfcom.Importa(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/nfcom/importa', Payload);
end;

end.
