unit CteOSUnit;

interface

uses
  System.SysUtils, System.Classes, BaseUnit, System.JSON, ClientUnit;

type
  ECteOSException = class(EBaseException);

  TCteOS = class(TBase)
  public
    function Status: TJSONObject;
    function Consulta(const Payload: TJSONObject): string;
    function Pdf(const Payload: TJSONObject): string;
    function Cria(const Payload: TJSONObject): string;
    function Busca(const Payload: TJSONObject): string;
    function Cancela(const Payload: TJSONObject): string;
    function Correcao(const Payload: TJSONObject): string;
    function Inutiliza(const Payload: TJSONObject): string;
    function Backup(const Payload: TJSONObject): string;
    function Importa(const Payload: TJSONObject): string;
    function Preview(const Payload: TJSONObject): string;
    function Desacordo(const Payload: TJSONObject): string;
  end;

implementation

{ TCteOS }

function TCteOS.Status: TJSONObject;
begin
  Result := FClient.Send('GET', '/cteos/status', nil);
end;

function TCteOS.Consulta(const Payload: TJSONObject): string;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', Format('/cteos/%s', [Key]), nil);
end;

function TCteOS.Pdf(const Payload: TJSONObject): string;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', Format('/cteos/pdf/%s', [Key]), nil);
end;

function TCteOS.Cria(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/cteos', Payload);
end;

function TCteOS.Busca(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/cteos/busca', Payload);
end;

function TCteOS.Cancela(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/cteos/cancela', Payload);
end;

function TCteOS.Correcao(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/cteos/correcao', Payload);
end;

function TCteOS.Inutiliza(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/cteos/inutiliza', Payload);
end;

function TCteOS.Backup(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/cteos/backup', Payload);
end;

function TCteOS.Importa(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/cteos/importa', Payload);
end;

function TCteOS.Preview(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/cteos/preview', Payload);
end;

function TCteOS.Desacordo(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/cteos/desacordo', Payload);
end;

end.
