unit AverbacaoUnit;

interface

uses
  System.SysUtils, System.Classes, BaseUnit, System.JSON, ClientUnit;

type
  EAverbacaoException = class(EBaseException);

  TAverbacao = class(TBase)
  public
    function Atm(const Payload: TJSONObject): TJSONObject;
    function AtmCancela(const Payload: TJSONObject): TJSONObject;
    function Elt(const Payload: TJSONObject): TJSONObject;
    function PortoSeguro(const Payload: TJSONObject): TJSONObject;
    function PortoSeguroCancela(const Payload: TJSONObject): TJSONObject;
  end;

implementation

{ TAverbacao }

function TAverbacao.Atm(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/averbacao/atm', Payload);
end;

function TAverbacao.AtmCancela(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/averbacao/atm/cancela', Payload);
end;

function TAverbacao.Elt(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/averbacao/elt', Payload);
end;

function TAverbacao.PortoSeguro(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/averbacao/portoseguro', Payload);
end;

function TAverbacao.PortoSeguroCancela(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/averbacao/portoseguro/cancela', Payload);
end;

end.
