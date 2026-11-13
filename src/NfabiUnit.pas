unit NfabiUnit;

interface

uses
  System.SysUtils, System.Classes, BaseUnit, System.JSON, ClientUnit;

type
  ENfabiException = class(EBaseException);

  TIntegraNfabi = class(TBase)
  public
    function Status: string;
    function Cria(const Payload: TJSONObject): string;
    function Consulta(const Payload: TJSONObject): string;
    function Cancela(const Payload: TJSONObject): string;
    function Parcela(const Payload: TJSONObject): string;
    function Desfazimento(const Payload: TJSONObject): string;
    function Busca(const Payload: TJSONObject): string;
    function Pdf(const Payload: TJSONObject): string;
    function Preview(const Payload: TJSONObject): string;
    function Backup(const Payload: TJSONObject): string;
    function Importa(const Payload: TJSONObject): string;
  end;

implementation

{ TIntegraNfabi }

function TIntegraNfabi.Status: string;
begin
  Result := FClient.Send('GET', '/nfabi/status');
end;

function TIntegraNfabi.Cria(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfabi', Payload);
end;

function TIntegraNfabi.Consulta(const Payload: TJSONObject): string;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', '/nfabi/' + Key);
end;

function TIntegraNfabi.Cancela(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfabi/cancela', Payload);
end;

function TIntegraNfabi.Parcela(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfabi/parcela', Payload);
end;

function TIntegraNfabi.Desfazimento(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfabi/desfazimento', Payload);
end;

function TIntegraNfabi.Busca(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfabi/busca', Payload);
end;

function TIntegraNfabi.Pdf(const Payload: TJSONObject): string;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', '/nfabi/pdf/' + Key);
end;

function TIntegraNfabi.Preview(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfabi/preview', Payload);
end;

function TIntegraNfabi.Backup(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfabi/backup', Payload);
end;

function TIntegraNfabi.Importa(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfabi/importa', Payload);
end;

end.
