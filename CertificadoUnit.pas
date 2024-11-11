unit CertificadoUnit;

interface

uses
  System.SysUtils, System.Classes, BaseUnit, System.JSON, ClientUnit;

type
  ECertificadoException = class(EBaseException);

  TCertificado = class(TBase)
  public
    function Atualiza(const Payload: TJSONObject): string;
    function Mostra: TJSONObject;
  end;

implementation

{ TCertificado }

function TCertificado.Atualiza(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/certificado', Payload);
end;

function TCertificado.Mostra: TJSONObject;
var
  EmptyPayload: TJSONObject;
begin
  EmptyPayload := TJSONObject.Create;
  try
    Result := FClient.Send('GET', '/certificado', EmptyPayload);
  finally
    EmptyPayload.Free;
  end;
end;

end.
