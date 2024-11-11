unit MdfeUnit;

interface

uses
  System.SysUtils, System.Classes, BaseUnit, System.JSON, ClientUnit;

type
  EMdfeException = class(EBaseException);

  TMdfe = class(TBase)
  public
    function Cria(const Payload: TJSONObject): string;
    function Preview(const Payload: TJSONObject): string;
    function Status: string;
    function Consulta(const Payload: TJSONObject): string;
    function Busca(const Payload: TJSONObject): string;
    function Cancela(const Payload: TJSONObject): string;
    function Encerra(const Payload: TJSONObject): string;
    function Condutor(const Payload: TJSONObject): string;
    function Offline: string;
    function Pdf(const Payload: TJSONObject): string;
    function Backup(const Payload: TJSONObject): string;
    function Nfe(const Payload: TJSONObject): string;
    function Abertos: string;
    function Importa(const Payload: TJSONObject): string;
  end;

implementation

{ TMdfe }

function TMdfe.Cria(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/mdfe', Payload);
end;

function TMdfe.Preview(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/mdfe/preview', Payload);
end;

function TMdfe.Status: string;
begin
  Result := FClient.Send('GET', '/mdfe/status', nil);
end;

function TMdfe.Consulta(const Payload: TJSONObject): string;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', Format('/mdfe/%s', [Key]), nil);
end;

function TMdfe.Busca(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/mdfe/busca', Payload);
end;

function TMdfe.Cancela(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/mdfe/cancela', Payload);
end;

function TMdfe.Encerra(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/mdfe/encerra', Payload);
end;

function TMdfe.Condutor(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/mdfe/condutor', Payload);
end;

function TMdfe.Offline: string;
begin
  Result := FClient.Send('GET', '/mdfe/offline', nil);
end;

function TMdfe.Pdf(const Payload: TJSONObject): string;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', Format('/mdfe/pdf/%s', [Key]), nil);
end;

function TMdfe.Backup(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/mdfe/backup', Payload);
end;

function TMdfe.Nfe(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/mdfe/nfe', Payload);
end;

function TMdfe.Abertos: string;
begin
  Result := FClient.Send('GET', '/mdfe/abertos', nil);
end;

function TMdfe.Importa(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/mdfe/importa', Payload);
end;

end.
