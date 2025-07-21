unit GnreUnit;

interface

uses
  System.SysUtils, System.Classes, BaseUnit, System.JSON, ClientUnit;

type
  EGnreException = class(EBaseException);

  TIntegraGnre = class(TBase)
  public
    function Consulta(const Payload: TJSONObject): string;
    function Cria(const Payload: TJSONObject): string;
    function ConfigUf(const Payload: TJSONObject): string;
  end;

implementation

{ TIntegraGnre }

function TIntegraGnre.Consulta(const Payload: TJSONObject): string;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', '/gnre/' + Key);
end;

function TIntegraGnre.Cria(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/gnre', Payload);
end;

function TIntegraGnre.ConfigUf(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/gnre/configuf', Payload);
end;

end.
