unit SofthouseUnit;

interface

uses
  System.SysUtils, System.Classes, System.JSON, BaseUnit, ClientUnit;

type
  ESofthouseException = class(EBaseException);

  TSofthouse = class(TBase)
  public
    function CriaEmitente(const Payload: TJSONObject): TJSONObject;
    function AtualizaEmitente(const Payload: TJSONObject): TJSONObject;
    function MostraEmitente(const Payload: TJSONObject): TJSONObject;
    function ListaEmitentes(const Payload: TJSONObject): TJSONObject;
    function DeletaEmitente(const Payload: TJSONObject): TJSONObject;
  end;

implementation

{ TSofthouse }

function TSofthouse.CriaEmitente(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/soft/emitente', Payload);
end;

function TSofthouse.AtualizaEmitente(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('PUT', '/soft/emitente', Payload);
end;

function TSofthouse.MostraEmitente(const Payload: TJSONObject): TJSONObject;
var
  Doc: string;
begin
  if (Payload = nil) or not Payload.TryGetValue('doc', Doc) then
    raise ESofthouseException.Create('Deve ser passado um CNPJ ou um CPF para efetuar a deleção do emitente.');
  Result := FClient.Send('GET', '/soft/emitente/' + Doc, nil);
end;

function TSofthouse.ListaEmitentes(const Payload: TJSONObject): TJSONObject;
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

function TSofthouse.DeletaEmitente(const Payload: TJSONObject): TJSONObject;
var
  Doc: string;
begin
  if (Payload = nil) or not Payload.TryGetValue('doc', Doc) then
    raise ESofthouseException.Create('Deve ser passado um CNPJ ou um CPF para efetuar a deleção do emitente.');
  Result := FClient.Send('DELETE', '/soft/emitente/' + Doc, nil);
end;

end.
