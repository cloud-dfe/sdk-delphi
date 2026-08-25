unit EmitenteUnit;

interface

uses
  System.SysUtils, System.Classes, BaseUnit, System.JSON, ClientUnit;

type
  EEmitenteException = class(EBaseException);

  TIntegraEmitente = class(TBase)
  public
    function Token: string;
    function Atualiza(const Payload: TJSONObject): string;
    function Mostra: string;
    function Webhook(const Payload: TJSONObject): string;
  end;

implementation

{ TIntegraEmitente }

function TIntegraEmitente.Token: string;
begin
  Result := FClient.Send('GET', '/emitente/token');
end;

function TIntegraEmitente.Atualiza(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('PUT', '/emitente', Payload);
end;

function TIntegraEmitente.Mostra: string;
begin
  Result := FClient.Send('GET', '/emitente');
end;

function TIntegraEmitente.Webhook(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/webhook', Payload);
end;

end.
