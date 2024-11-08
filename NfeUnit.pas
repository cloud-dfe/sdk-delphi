unit NfeUnit;

interface

uses
  System.SysUtils, System.Classes, BaseUnit, System.JSON, ClientUnit;

type
  ENfeException = class(EBaseException);

  TNfe = class(TBase)
  public
    function Cria(const Payload: TJSONObject): TJSONObject;
    function Preview(const Payload: TJSONObject): TJSONObject;
    function Status: TJSONObject;
    function Consulta(const Payload: TJSONObject): TJSONObject;
    function Busca(const Payload: TJSONObject): TJSONObject;
    function Cancela(const Payload: TJSONObject): TJSONObject;
    function Correcao(const Payload: TJSONObject): TJSONObject;
    function Inutiliza(const Payload: TJSONObject): TJSONObject;
    function Pdf(const Payload: TJSONObject): TJSONObject;
    function Etiqueta(const Payload: TJSONObject): TJSONObject;
    function Manifesta(const Payload: TJSONObject): TJSONObject;
    function Backup(const Payload: TJSONObject): TJSONObject;
    function Download(const Payload: TJSONObject): TJSONObject;
    function Recebidas(const Payload: TJSONObject): TJSONObject;
    function Interessado(const Payload: TJSONObject): TJSONObject;
    function Importa(const Payload: TJSONObject): TJSONObject;
    function Comprovante(const Payload: TJSONObject): TJSONObject;
    function Cadastro(const Payload: TJSONObject): TJSONObject;
  end;

implementation

{ TNfe }

function TNfe.Cria(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/nfe', Payload);
end;

function TNfe.Preview(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/nfe/preview', Payload);
end;

function TNfe.Status: TJSONObject;
begin
  Result := FClient.Send('GET', '/nfe/status', nil);
end;

function TNfe.Consulta(const Payload: TJSONObject): TJSONObject;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', Format('/nfe/%s', [Key]), nil);
end;

function TNfe.Busca(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/nfe/busca', Payload);
end;

function TNfe.Cancela(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/nfe/cancela', Payload);
end;

function TNfe.Correcao(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/nfe/correcao', Payload);
end;

function TNfe.Inutiliza(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/nfe/inutiliza', Payload);
end;

function TNfe.Pdf(const Payload: TJSONObject): TJSONObject;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', Format('/nfe/pdf/%s', [Key]), nil);
end;

function TNfe.Etiqueta(const Payload: TJSONObject): TJSONObject;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', Format('/nfe/pdf/etiqueta/%s', [Key]), nil);
end;

function TNfe.Manifesta(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/nfe/manifesta', Payload);
end;

function TNfe.Backup(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/nfe/backup', Payload);
end;

function TNfe.Download(const Payload: TJSONObject): TJSONObject;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', Format('/nfe/download/%s', [Key]), nil);
end;

function TNfe.Recebidas(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/nfe/recebidas', Payload);
end;

function TNfe.Interessado(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/nfe/interessado', Payload);
end;

function TNfe.Importa(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/nfe/importa', Payload);
end;

function TNfe.Comprovante(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/nfe/comprovante', Payload);
end;

function TNfe.Cadastro(const Payload: TJSONObject): TJSONObject;
begin
  Result := FClient.Send('POST', '/nfe/cadastro', Payload);
end;

end.
