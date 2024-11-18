unit AverbacaoUnit;

interface

uses
  System.SysUtils, System.Classes, BaseUnit, System.JSON, ClientUnit;

type
  EAverbacaoException = class(EBaseException);

  TIntegraAverbacao = class(TBase)
  public
    function Atm(const Payload: TJSONObject): string;
    function AtmCancela(const Payload: TJSONObject): string;
    function Elt(const Payload: TJSONObject): string;
    function PortoSeguro(const Payload: TJSONObject): string;
    function PortoSeguroCancela(const Payload: TJSONObject): string;
  end;

implementation

{ TIntegraAverbacao }

function TIntegraAverbacao.Atm(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/averbacao/atm', Payload);
end;

function TIntegraAverbacao.AtmCancela(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/averbacao/atm/cancela', Payload);
end;

function TIntegraAverbacao.Elt(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/averbacao/elt', Payload);
end;

function TIntegraAverbacao.PortoSeguro(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/averbacao/portoseguro', Payload);
end;

function TIntegraAverbacao.PortoSeguroCancela(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/averbacao/portoseguro/cancela', Payload);
end;

end.
