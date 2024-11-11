unit AverbacaoUnit;

interface

uses
  System.SysUtils, System.Classes, BaseUnit, System.JSON, ClientUnit;

type
  EAverbacaoException = class(EBaseException);

  TAverbacao = class(TBase)
  public
    function Atm(const Payload: TJSONObject): string;
    function AtmCancela(const Payload: TJSONObject): string;
    function Elt(const Payload: TJSONObject): string;
    function PortoSeguro(const Payload: TJSONObject): string;
    function PortoSeguroCancela(const Payload: TJSONObject): string;
  end;

implementation

{ TAverbacao }

function TAverbacao.Atm(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/averbacao/atm', Payload);
end;

function TAverbacao.AtmCancela(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/averbacao/atm/cancela', Payload);
end;

function TAverbacao.Elt(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/averbacao/elt', Payload);
end;

function TAverbacao.PortoSeguro(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/averbacao/portoseguro', Payload);
end;

function TAverbacao.PortoSeguroCancela(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/averbacao/portoseguro/cancela', Payload);
end;

end.
