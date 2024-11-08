unit GnreUnit;

interface

uses
  System.SysUtils, System.Classes, BaseUnit, System.JSON, ClientUnit;

type
  EGnreException = class(EBaseException);

  TGnre = class(TBase)
  public
    function Consulta(const Payload: TJSONObject): TJSONObject;
    function Cria(const Payload: TJSONObject): TJSONObject;
    function ConfigUf(const Payload: TJSONObject): TJSONObject;
  end;

implementation

{ TGnre }

function TGnre.Consulta(const Payload: TJSONObject): TJSONObject;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', Format('/gnre/%s', [Key]), nil);
end;

function TGnre.Cria(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/gnre', Payload);
end;

function TGnre.ConfigUf(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/gnre/configuf', Payload);
end;

end.
