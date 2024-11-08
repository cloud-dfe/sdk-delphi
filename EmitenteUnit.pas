unit EmitenteUnit;

interface

uses
  System.SysUtils, System.Classes, BaseUnit, System.JSON, ClientUnit;

type
  EEmitenteException = class(EBaseException);

  TEmitente = class(TBase)
  public
    function Token: TJSONObject;
    function Atualiza(const Payload: TJSONObject): TJSONObject;
    function Mostra: TJSONObject;
  end;

implementation

{ TEmitente }

function TEmitente.Token: TJSONObject;
begin
  Result := FClient.Send('GET', '/emitente/token', nil);
end;

function TEmitente.Atualiza(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('PUT', '/emitente', Payload);
end;

function TEmitente.Mostra: TJSONObject;
begin
  Result := FClient.Send('GET', '/emitente', nil);
end;

end.
