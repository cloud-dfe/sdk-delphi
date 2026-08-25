unit CertificadoUnit;

interface

uses
  System.SysUtils, System.Classes, BaseUnit, System.JSON, ClientUnit;

type
  ECertificadoException = class(EBaseException);

  TIntegraCertificado = class(TBase)
  public
    function Atualiza(const Payload: TJSONObject): string;
    function Mostra: string;
  end;

implementation

{ TIntegraCertificado }

function TIntegraCertificado.Atualiza(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/certificado', Payload);
end;

function TIntegraCertificado.Mostra: string;
begin
  Result := FClient.Send('GET', '/certificado');
end;

end.