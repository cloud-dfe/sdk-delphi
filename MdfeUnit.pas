unit MdfeUnit;

interface

uses
  System.SysUtils, System.Classes, BaseUnit, System.JSON, ClientUnit;

type
  EMdfeException = class(EBaseException);

  TMdfe = class(TBase)
  public
    function Cria(const Payload: TJSONObject): TJSONObject;
    function Preview(const Payload: TJSONObject): TJSONObject;
    function Status: TJSONObject;
    function Consulta(const Payload: TJSONObject): TJSONObject;
    function Busca(const Payload: TJSONObject): TJSONObject;
    function Cancela(const Payload: TJSONObject): TJSONObject;
    function Encerra(const Payload: TJSONObject): TJSONObject;
    function Condutor(const Payload: TJSONObject): TJSONObject;
    function Offline: TJSONObject;
    function Pdf(const Payload: TJSONObject): TJSONObject;
    function Backup(const Payload: TJSONObject): TJSONObject;
    function Nfe(const Payload: TJSONObject): TJSONObject;
    function Abertos: TJSONObject;
    function Importa(const Payload: TJSONObject): TJSONObject;
  end;

implementation

{ TMdfe }

function TMdfe.Cria(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/mdfe', Payload);
end;

function TMdfe.Preview(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/mdfe/preview', Payload);
end;

function TMdfe.Status: TJSONObject;
begin
  Result := FClient.Send('GET', '/mdfe/status', nil);
end;

function TMdfe.Consulta(const Payload: TJSONObject): TJSONObject;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', Format('/mdfe/%s', [Key]), nil);
end;

function TMdfe.Busca(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/mdfe/busca', Payload);
end;

function TMdfe.Cancela(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/mdfe/cancela', Payload);
end;

function TMdfe.Encerra(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/mdfe/encerra', Payload);
end;

function TMdfe.Condutor(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/mdfe/condutor', Payload);
end;

function TMdfe.Offline: TJSONObject;
begin
  Result := FClient.Send('GET', '/mdfe/offline', nil);
end;

function TMdfe.Pdf(const Payload: TJSONObject): TJSONObject;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', Format('/mdfe/pdf/%s', [Key]), nil);
end;

function TMdfe.Backup(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/mdfe/backup', Payload);
end;

function TMdfe.Nfe(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/mdfe/nfe', Payload);
end;

function TMdfe.Abertos: TJSONObject;
begin
  Result := FClient.Send('GET', '/mdfe/abertos', nil);
end;

function TMdfe.Importa(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/mdfe/importa', Payload);
end;

end.
