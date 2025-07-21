unit CteUnit;

interface

uses
  System.SysUtils, System.Classes, BaseUnit, System.JSON, ClientUnit;

type
  ECteException = class(EBaseException);

  TIntegraCte = class(TBase)
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

{ TIntegraCte }

function TIntegraCte.Status: string;
begin
  Result := FClient.Send('GET', '/cte/status', nil);
end;

function TIntegraCte.Consulta(const Payload: TJSONObject): string;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', '/cte/' + Key);
end;

function TIntegraCte.Pdf(const Payload: TJSONObject): string;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', '/cte/pdf/' + Key);
end;

function TIntegraCte.Cria(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/cte', Payload);
end;

function TIntegraCte.Busca(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/cte/busca', Payload);
end;

function TIntegraCte.Cancela(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/cte/cancela', Payload);
end;

function TIntegraCte.Correcao(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/cte/correcao', Payload);
end;

function TIntegraCte.Inutiliza(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/cte/inutiliza', Payload);
end;

function TIntegraCte.Backup(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/cte/backup', Payload);
end;

function TIntegraCte.Importa(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/cte/importa', Payload);
end;

function TIntegraCte.Preview(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/cte/preview', Payload);
end;

function TIntegraCte.Desacordo(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/cte/desacordo', Payload);
end;

end.
