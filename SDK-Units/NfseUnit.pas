unit NfseUnit;

interface

uses
  System.SysUtils, System.Classes, System.JSON, BaseUnit;

type
  ENfseException = class(Exception);

  TIntegraNfse = class(TBase)
  public
    function Cria(Payload: TJSONObject): string;
    function Preview(Payload: TJSONObject): string;
    function Pdf(Payload: TJSONObject): string;
    function Consulta(Payload: TJSONObject): string;
    function Cancela(Payload: TJSONObject): string;
    function Substitui(Payload: TJSONObject): string;
    function Busca(Payload: TJSONObject): string;
    function Backup(Payload: TJSONObject): string;
    function Localiza(Payload: TJSONObject): string;
    function Info(Payload: TJSONObject): string;
    function Conflito(Payload: TJSONObject): string;
    function Offline: string;
    function Resolve(Payload: TJSONObject): string;
  end;

implementation

{ TIntegraNfse }

function TIntegraNfse.Cria(Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfse', Payload);
end;

function TIntegraNfse.Preview(Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfse/preview', Payload);
end;

function TIntegraNfse.Pdf(Payload: TJSONObject): string;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', '/nfse/pdf/' + Key);
end;

function TIntegraNfse.Consulta(Payload: TJSONObject): string;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', '/nfse/' + Key);
end;

function TIntegraNfse.Cancela(Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfse/cancela', Payload);
end;

function TIntegraNfse.Substitui(Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfse/substitui', Payload);
end;

function TIntegraNfse.Busca(Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfse/busca', Payload);
end;

function TIntegraNfse.Backup(Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfse/backup', Payload);
end;

function TIntegraNfse.Localiza(Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfse/consulta', Payload);
end;

function TIntegraNfse.Info(Payload: TJSONObject): string;
var
  IBGECode: string;
begin
  IBGECode := Payload.GetValue<string>('ibge', '');
  if IBGECode.IsEmpty then
    raise ENfseException.Create('Código IBGE é obrigatório para a consulta de informações.');
    
  Result := FClient.Send('GET', '/nfse/info/' + IBGECode);
end;

function TIntegraNfse.Conflito(Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfse/conflito', Payload);
end;

function TIntegraNfse.Offline: string;
begin
  Result := FClient.Send('GET', '/nfse/offline');
end;

function TIntegraNfse.Resolve(Payload: TJSONObject): string;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', '/nfse/resolve/' + Key);
end;

end.
