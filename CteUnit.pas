unit CteUnit;

interface

uses
  System.SysUtils, System.Classes, BaseUnit, System.JSON, ClientUnit;

type
  ECteException = class(EBaseException);

  TCte = class(TBase)
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

{ TCte }

function TCte.Status: TJSONObject;
begin
  Result := FClient.Send('GET', '/cte/status', nil);
end;

function TCte.Consulta(const Payload: TJSONObject): TJSONObject;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', Format('/cte/%s', [Key]), nil);
end;

function TCte.Pdf(const Payload: TJSONObject): TJSONObject;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', Format('/cte/pdf/%s', [Key]), nil);
end;

function TCte.Cria(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/cte', Payload);
end;

function TCte.Busca(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/cte/busca', Payload);
end;

function TCte.Cancela(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/cte/cancela', Payload);
end;

function TCte.Correcao(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/cte/correcao', Payload);
end;

function TCte.Inutiliza(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/cte/inutiliza', Payload);
end;

function TCte.Backup(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/cte/backup', Payload);
end;

function TCte.Importa(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/cte/importa', Payload);
end;

function TCte.Preview(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/cte/preview', Payload);
end;

function TCte.Desacordo(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/cte/desacordo', Payload);
end;

end.
