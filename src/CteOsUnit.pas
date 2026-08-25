unit CteOsUnit;

interface

uses
  System.SysUtils, System.Classes, BaseUnit, System.JSON, ClientUnit;

type
  ECteOsException = class(EBaseException);

  TIntegraCteOs = class(TBase)
  public
    function Status: string;
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

{ TIntegraCteOs }

function TIntegraCteOs.Status: string;
begin
  Result := FClient.Send('GET', '/cteos/status');
end;

function TIntegraCteOs.Consulta(const Payload: TJSONObject): string;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', '/cteos/' + Key);
end;

function TIntegraCteOs.Pdf(const Payload: TJSONObject): string;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', '/cteos/pdf/' + Key);
end;

function TIntegraCteOs.Cria(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/cteos', Payload);
end;

function TIntegraCteOs.Busca(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/cteos/busca', Payload);
end;

function TIntegraCteOs.Cancela(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/cteos/cancela', Payload);
end;

function TIntegraCteOs.Correcao(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/cteos/correcao', Payload);
end;

function TIntegraCteOs.Inutiliza(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/cteos/inutiliza', Payload);
end;

function TIntegraCteOs.Backup(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/cteos/backup', Payload);
end;

function TIntegraCteOs.Importa(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/cteos/importa', Payload);
end;

function TIntegraCteOs.Preview(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/cteos/preview', Payload);
end;

function TIntegraCteOs.Desacordo(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/cteos/desacordo', Payload);
end;

end.
