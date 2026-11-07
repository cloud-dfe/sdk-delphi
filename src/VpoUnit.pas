unit VpoUnit;

interface

uses
  System.SysUtils, System.Classes, BaseUnit, System.JSON, ClientUnit;

type
  EVpoException = class(EBaseException);

  TIntegraVpo = class(TBase)
  public
    function Cria(const Payload: TJSONObject): string;
    function Consulta(const Payload: TJSONObject): string;
    function Busca(const Payload: TJSONObject): string;
    function Cancela(const Payload: TJSONObject): string;
    function Reemite(const Payload: TJSONObject): string;
    function Rota(const Payload: TJSONObject): string;
    function Pdf(const Payload: TJSONObject): string;
    function Veiculo(const Payload: TJSONObject): string;
  end;

implementation

{ TIntegraVpo }

function TIntegraVpo.Cria(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/vpo/ailog', Payload);
end;

function TIntegraVpo.Consulta(const Payload: TJSONObject): string;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', '/vpo/ailog/' + Key);
end;

function TIntegraVpo.Busca(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/vpo/ailog/busca', Payload);
end;

function TIntegraVpo.Cancela(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/vpo/ailog/cancela', Payload);
end;

function TIntegraVpo.Reemite(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/vpo/ailog/reemite', Payload);
end;

function TIntegraVpo.Rota(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/vpo/ailog/rota', Payload);
end;

function TIntegraVpo.Pdf(const Payload: TJSONObject): string;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', '/vpo/ailog/pdf/' + Key);
end;

function TIntegraVpo.Veiculo(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/vpo/ailog/veiculo', Payload);
end;

end.
