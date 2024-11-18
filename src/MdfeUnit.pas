unit MdfeUnit;

interface

uses
  System.SysUtils, System.Classes, BaseUnit, System.JSON, ClientUnit;

type
  EMdfeException = class(EBaseException);

  TIntegraMdfe = class(TBase)
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

{ TIntegraMdfe }

function TIntegraMdfe.Cria(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/mdfe', Payload);
end;

function TIntegraMdfe.Preview(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/mdfe/preview', Payload);
end;

function TIntegraMdfe.Status: string;
begin
  Result := FClient.Send('GET', '/mdfe/status', nil);
end;

function TIntegraMdfe.Consulta(const Payload: TJSONObject): string;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', Format('/mdfe/%s', [Key]), nil);
end;

function TIntegraMdfe.Busca(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/mdfe/busca', Payload);
end;

function TIntegraMdfe.Cancela(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/mdfe/cancela', Payload);
end;

function TIntegraMdfe.Encerra(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/mdfe/encerra', Payload);
end;

function TIntegraMdfe.Condutor(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/mdfe/condutor', Payload);
end;

function TIntegraMdfe.Offline: string;
begin
  Result := FClient.Send('GET', '/mdfe/offline', nil);
end;

function TIntegraMdfe.Pdf(const Payload: TJSONObject): string;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', Format('/mdfe/pdf/%s', [Key]), nil);
end;

function TIntegraMdfe.Backup(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/mdfe/backup', Payload);
end;

function TIntegraMdfe.Nfe(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/mdfe/nfe', Payload);
end;

function TIntegraMdfe.Abertos: string;
begin
  Result := FClient.Send('GET', '/mdfe/abertos', nil);
end;

function TIntegraMdfe.Importa(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/mdfe/importa', Payload);
end;

end.
