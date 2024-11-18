unit CteOSUnit;

interface

uses
  System.SysUtils, System.Classes, BaseUnit, System.JSON, ClientUnit;

type
  ECteOSException = class(EBaseException);

  TIntegraCteOS = class(TBase)
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

{ TIntegraCteOS }

function TIntegraCteOS.Status: TJSONObject;
begin
  Result := FClient.Send('GET', '/cteos/status', nil);
end;

function TIntegraCteOS.Consulta(const Payload: TJSONObject): string;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', Format('/cteos/%s', [Key]), nil);
end;

function TIntegraCteOS.Pdf(const Payload: TJSONObject): string;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', Format('/cteos/pdf/%s', [Key]), nil);
end;

function TIntegraCteOS.Cria(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/cteos', Payload);
end;

function TIntegraCteOS.Busca(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/cteos/busca', Payload);
end;

function TIntegraCteOS.Cancela(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/cteos/cancela', Payload);
end;

function TIntegraCteOS.Correcao(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/cteos/correcao', Payload);
end;

function TIntegraCteOS.Inutiliza(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/cteos/inutiliza', Payload);
end;

function TIntegraCteOS.Backup(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/cteos/backup', Payload);
end;

function TIntegraCteOS.Importa(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/cteos/importa', Payload);
end;

function TIntegraCteOS.Preview(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/cteos/preview', Payload);
end;

function TIntegraCteOS.Desacordo(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/cteos/desacordo', Payload);
end;

end.
