unit NfeUnit;

interface

uses
  System.SysUtils, System.Classes, BaseUnit, System.JSON, ClientUnit;

type
  ENfeException = class(EBaseException);

  TNfe = class(TBase)
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
  end;

implementation

{ TNfe }

function TNfe.Cria(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfe', Payload);
end;

function TNfe.Preview(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfe/preview', Payload);
end;

function TNfe.Status: string;
begin
  Result := FClient.Send('GET', '/nfe/status', nil);
end;

function TNfe.Consulta(const Payload: TJSONObject): string;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', Format('/nfe/%s', [Key]), nil);
end;

function TNfe.Busca(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfe/busca', Payload);
end;

function TNfe.Cancela(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfe/cancela', Payload);
end;

function TNfe.Correcao(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfe/correcao', Payload);
end;

function TNfe.Inutiliza(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfe/inutiliza', Payload);
end;

function TNfe.Pdf(const Payload: TJSONObject): string;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', Format('/nfe/pdf/%s', [Key]), nil);
end;

function TNfe.Etiqueta(const Payload: TJSONObject): string;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', Format('/nfe/pdf/etiqueta/%s', [Key]), nil);
end;

function TNfe.Manifesta(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfe/manifesta', Payload);
end;

function TNfe.Backup(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfe/backup', Payload);
end;

function TNfe.Download(const Payload: TJSONObject): string;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', Format('/nfe/download/%s', [Key]), nil);
end;

function TNfe.Recebidas(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfe/recebidas', Payload);
end;

function TNfe.Interessado(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfe/interessado', Payload);
end;

function TNfe.Importa(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfe/importa', Payload);
end;

function TNfe.Comprovante(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfe/comprovante', Payload);
end;

function TNfe.Cadastro(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfe/cadastro', Payload);
end;

end.
