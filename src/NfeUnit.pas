unit NfeUnit;

interface

uses
  System.SysUtils, System.Classes, BaseUnit, System.JSON, ClientUnit;

type
  ENfeException = class(EBaseException);

  TIntegraNfe = class(TBase)
  public
    function Cria(const Payload: TJSONObject): string;
    function Preview(const Payload: TJSONObject): string;
    function Status: string;
    function Consulta(const Payload: TJSONObject): string;
    function Busca(const Payload: TJSONObject): string;
    function Cancela(const Payload: TJSONObject): string;
    function Correcao(const Payload: TJSONObject): string;
    function Inutiliza(const Payload: TJSONObject): string;
    function Pdf(const Payload: TJSONObject): string;
    function Etiqueta(const Payload: TJSONObject): string;
    function Manifesta(const Payload: TJSONObject): string;
    function Backup(const Payload: TJSONObject): string;
    function Download(const Payload: TJSONObject): string;
    function Recebidas(const Payload: TJSONObject): string;
    function Interessado(const Payload: TJSONObject): string;
    function Importa(const Payload: TJSONObject): string;
    function Comprovante(const Payload: TJSONObject): string;
    function Cadastro(const Payload: TJSONObject): string;
    function Simples(const Payload: TJSONObject): string;
  end;

implementation

{ TIntegraNfe }

function TIntegraNfe.Cria(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfe', Payload);
end;

function TIntegraNfe.Preview(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfe/preview', Payload);
end;

function TIntegraNfe.Status: string;
begin
  Result := FClient.Send('GET', '/nfe/status', nil);
end;

function TIntegraNfe.Consulta(const Payload: TJSONObject): string;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', Format('/nfe/%s', [Key]), nil);
end;

function TIntegraNfe.Busca(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfe/busca', Payload);
end;

function TIntegraNfe.Cancela(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfe/cancela', Payload);
end;

function TIntegraNfe.Correcao(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfe/correcao', Payload);
end;

function TIntegraNfe.Inutiliza(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfe/inutiliza', Payload);
end;

function TIntegraNfe.Pdf(const Payload: TJSONObject): string;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', Format('/nfe/pdf/%s', [Key]), nil);
end;

function TIntegraNfe.Etiqueta(const Payload: TJSONObject): string;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', Format('/nfe/pdf/etiqueta/%s', [Key]), nil);
end;

function TIntegraNfe.Manifesta(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfe/manifesta', Payload);
end;

function TIntegraNfe.Backup(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfe/backup', Payload);
end;

function TIntegraNfe.Download(const Payload: TJSONObject): string;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', Format('/nfe/download/%s', [Key]), nil);
end;

function TIntegraNfe.Recebidas(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfe/recebidas', Payload);
end;

function TIntegraNfe.Interessado(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfe/interessado', Payload);
end;

function TIntegraNfe.Importa(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfe/importa', Payload);
end;

function TIntegraNfe.Comprovante(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfe/comprovante', Payload);
end;

function TIntegraNfe.Cadastro(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfe/cadastro', Payload);
end;

function TIntegraNfe.Simples(const Payload: TJSONObject): string;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', Format('/nfe/pdf/simples/%s', [Key]), nil);
end;

end.
