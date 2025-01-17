unit SofthouseUnit;

interface

uses
  System.SysUtils, System.Classes, System.JSON, BaseUnit, ClientUnit;

type
  ESofthouseException = class(EBaseException);

  TIntegraSofthouse = class(TBase)
  public
    function CriaEmitente(const Payload: TJSONObject): string;
    function AtualizaEmitente(const Payload: TJSONObject): string;
    function MostraEmitente(const Payload: TJSONObject): string;
    function ListaEmitentes(const Payload: TJSONObject): string;
    function DeletaEmitente(const Payload: TJSONObject): string;
  end;

implementation

{ TIntegraSofthouse }

function TIntegraSofthouse.CriaEmitente(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/soft/emitente', Payload);
end;

function TIntegraSofthouse.AtualizaEmitente(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('PUT', '/soft/emitente', Payload);
end;

function TIntegraSofthouse.MostraEmitente(const Payload: TJSONObject): string;
var
  Doc: string;
begin
  if (Payload = nil) or not Payload.TryGetValue('doc', Doc) then
    raise ESofthouseException.Create('Deve ser passado um CNPJ ou um CPF para efetuar a deleção do emitente.');
  Result := FClient.Send('GET', '/soft/emitente/' + Doc, nil);
end;

function TIntegraSofthouse.ListaEmitentes(const Payload: TJSONObject): string;
var
  Status, Rota: string;
begin
  Status := Payload.GetValue('status', '');
  if (Status = 'deletados') or (Status = 'inativos') then
    Rota := '/soft/emitente/deletados'
  else
    Rota := '/soft/emitente';
  Result := FClient.Send('GET', Rota, nil);
end;

function TIntegraSofthouse.DeletaEmitente(const Payload: TJSONObject): string;
var
  Doc: string;
begin
  if (Payload = nil) or not Payload.TryGetValue('doc', Doc) then
    raise ESofthouseException.Create('Deve ser passado um CNPJ ou um CPF para efetuar a deleção do emitente.');
  Result := FClient.Send('DELETE', '/soft/emitente/' + Doc, nil);
end;

end.
