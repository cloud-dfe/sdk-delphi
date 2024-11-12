unit EmitenteUnit;

interface

uses
  System.SysUtils, System.Classes, BaseUnit, System.JSON, ClientUnit;

type
  EEmitenteException = class(EBaseException);

  TIntegraEmitente = class(TBase)
  public
    function Token: TJSONObject;
    function Atualiza(const Payload: TJSONObject): string;
    function Mostra: TJSONObject;
  end;

implementation

{ TIntegraEmitente }

function TIntegraEmitente.Token: string;
begin
  Result := FClient.Send('GET', '/emitente/token', nil);
end;

function TIntegraEmitente.Atualiza(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('PUT', '/emitente', Payload);
end;

function TIntegraEmitente.Mostra: string;
begin
  Result := FClient.Send('GET', '/emitente', nil);
end;

end.
