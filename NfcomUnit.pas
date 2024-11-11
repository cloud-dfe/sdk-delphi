unit NfcomUnit;

interface

uses
  System.SysUtils, System.Classes, BaseUnit, System.JSON, ClientUnit;

type
  ENfcomException = class(EBaseException);

  TNfcom = class(TBase)
  public
    function Status: string;
    function Cria(const Payload: TJSONObject): string;
    function Consulta(const Payload: TJSONObject): string;
    function Cancela(const Payload: TJSONObject): string;
    function Busca(const Payload: TJSONObject): string;
    function Pdf(const Payload: TJSONObject): string;
    function Preview(const Payload: TJSONObject): string;
    function Backup(const Payload: TJSONObject): string;
    function Importa(const Payload: TJSONObject): string;
  end;

implementation

{ TNfcom }

function TNfcom.Status: string;
begin
  Result := FClient.Send('GET', '/nfcom/status', nil);
end;

function TNfcom.Cria(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfcom', Payload);
end;

function TNfcom.Consulta(const Payload: TJSONObject): string;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', Format('/nfcom/%s', [Key]), Payload);
end;

function TNfcom.Cancela(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfcom/cancela', Payload);
end;

function TNfcom.Busca(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfcom/busca', Payload);
end;

function TNfcom.Pdf(const Payload: TJSONObject): string;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', Format('/nfcom/pdf/%s', [Key]), nil);
end;

function TNfcom.Preview(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfcom/preview', Payload);
end;

function TNfcom.Backup(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfcom/backup', Payload);
end;

function TNfcom.Importa(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfcom/importa', Payload);
end;

end.
