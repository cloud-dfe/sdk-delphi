unit CteOSUnit;

interface

uses
  System.SysUtils, System.Classes, BaseUnit, System.JSON, ClientUnit;

type
  ECteOSException = class(EBaseException);

  TCteOS = class(TBase)
  public
    function Status: TJSONObject;
    function Consulta(const Payload: TJSONObject): TJSONObject;
    function Pdf(const Payload: TJSONObject): TJSONObject;
    function Cria(const Payload: TJSONObject): TJSONObject;
    function Busca(const Payload: TJSONObject): TJSONObject;
    function Cancela(const Payload: TJSONObject): TJSONObject;
    function Correcao(const Payload: TJSONObject): TJSONObject;
    function Inutiliza(const Payload: TJSONObject): TJSONObject;
    function Backup(const Payload: TJSONObject): TJSONObject;
    function Importa(const Payload: TJSONObject): TJSONObject;
    function Preview(const Payload: TJSONObject): TJSONObject;
    function Desacordo(const Payload: TJSONObject): TJSONObject;
  end;

implementation

{ TCteOS }

function TCteOS.Status: TJSONObject;
begin
  Result := FClient.Send('GET', '/cteos/status', nil);
end;

function TCteOS.Consulta(const Payload: TJSONObject): TJSONObject;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', Format('/cteos/%s', [Key]), nil);
end;

function TCteOS.Pdf(const Payload: TJSONObject): TJSONObject;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', Format('/cteos/pdf/%s', [Key]), nil);
end;

function TCteOS.Cria(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/cteos', Payload);
end;

function TCteOS.Busca(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/cteos/busca', Payload);
end;

function TCteOS.Cancela(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/cteos/cancela', Payload);
end;

function TCteOS.Correcao(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/cteos/correcao', Payload);
end;

function TCteOS.Inutiliza(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/cteos/inutiliza', Payload);
end;

function TCteOS.Backup(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/cteos/backup', Payload);
end;

function TCteOS.Importa(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/cteos/importa', Payload);
end;

function TCteOS.Preview(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/cteos/preview', Payload);
end;

function TCteOS.Desacordo(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/cteos/desacordo', Payload);
end;

end.
