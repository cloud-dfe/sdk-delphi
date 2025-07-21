unit NfcomUnit;

interface

uses
  System.SysUtils, System.Classes, BaseUnit, System.JSON, ClientUnit;

type
  ENfcomException = class(EBaseException);

  TIntegraNfcom = class(TBase)
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

{ TIntegraNfcom }

function TIntegraNfcom.Status: string;
begin
  Result := FClient.Send('GET', '/nfcom/status');
end;

function TIntegraNfcom.Cria(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfcom', Payload);
end;

function TIntegraNfcom.Consulta(const Payload: TJSONObject): string;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', '/nfcom/' + Key);
end;

function TIntegraNfcom.Cancela(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfcom/cancela', Payload);
end;

function TIntegraNfcom.Busca(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfcom/busca', Payload);
end;

function TIntegraNfcom.Pdf(const Payload: TJSONObject): string;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', '/nfcom/pdf/' + Key);
end;

function TIntegraNfcom.Preview(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfcom/preview', Payload);
end;

function TIntegraNfcom.Backup(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfcom/backup', Payload);
end;

function TIntegraNfcom.Importa(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfcom/importa', Payload);
end;

end.
