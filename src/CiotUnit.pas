unit CiotUnit;

interface

uses
  System.SysUtils, System.Classes, BaseUnit, System.JSON, ClientUnit;

type
  ECiotException = class(EBaseException);

  TIntegraCiot = class(TBase)
  public
    function Cria(const Payload: TJSONObject): string;
    function Consulta(const Payload: TJSONObject): string;
    function Busca(const Payload: TJSONObject): string;
    function Cancela(const Payload: TJSONObject): string;
    function Encerra(const Payload: TJSONObject): string;
    function Retifica(const Payload: TJSONObject): string;
    function Pdf(const Payload: TJSONObject): string;
    function Transportador(const Payload: TJSONObject): string;
  end;

implementation

{ TIntegraCiot }

function TIntegraCiot.Cria(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/ciot', Payload);
end;

function TIntegraCiot.Consulta(const Payload: TJSONObject): string;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', '/ciot/' + Key);
end;

function TIntegraCiot.Busca(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/ciot/busca', Payload);
end;

function TIntegraCiot.Cancela(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/ciot/cancela', Payload);
end;

function TIntegraCiot.Encerra(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/ciot/encerra', Payload);
end;

function TIntegraCiot.Retifica(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/ciot/retifica', Payload);
end;

function TIntegraCiot.Pdf(const Payload: TJSONObject): string;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', '/ciot/pdf/' + Key);
end;

function TIntegraCiot.Transportador(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/ciot/transportador', Payload);
end;

end.
