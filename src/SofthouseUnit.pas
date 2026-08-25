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
    function ListaEmitentes(const Payload: TJSONObject = nil): string;
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
  Val: TJSONValue;
begin
  if not Assigned(Payload) then
    raise ESofthouseException.Create('Deve ser passado um CNPJ ou um CPF para efetuar a deleçao do emitente.');

  Doc := '';
  Val := Payload.GetValue<TJSONValue>('doc', nil);
  if Val <> nil then
    Doc := Val.Value;

  if Doc.Trim.IsEmpty then
    raise ESofthouseException.Create('Deve ser passado um CNPJ ou um CPF para efetuar a deleçao do emitente.');

  Result := FClient.Send('GET', '/soft/emitente/' + Doc);
end;

function TIntegraSofthouse.ListaEmitentes(const Payload: TJSONObject = nil): string;
var
  Status, Rota: string;
  Val: TJSONValue;
begin
  Status := '';
  if Assigned(Payload) then
  begin
    Val := Payload.GetValue<TJSONValue>('status', nil);
    if Val <> nil then
      Status := Val.Value;
  end;

  if (Status = 'deletados') or (Status = 'inativos') then
    Rota := '/soft/emitente/deletados'
  else
    Rota := '/soft/emitente';

  Result := FClient.Send('GET', Rota);
end;

function TIntegraSofthouse.DeletaEmitente(const Payload: TJSONObject): string;
var
  Doc: string;
  Val: TJSONValue;
begin
  if not Assigned(Payload) then
    raise ESofthouseException.Create('Deve ser passado um CNPJ ou um CPF para efetuar a deleçao do emitente.');

  Doc := '';
  Val := Payload.GetValue<TJSONValue>('doc', nil);
  if Val <> nil then
    Doc := Val.Value;

  if Doc.Trim.IsEmpty then
    raise ESofthouseException.Create('Deve ser passado um CNPJ ou um CPF para efetuar a deleçao do emitente.');

  Result := FClient.Send('DELETE', '/soft/emitente/' + Doc);
end;

end.
