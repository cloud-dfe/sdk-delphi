unit NfseUnit;

interface

uses
  System.SysUtils, System.Classes, System.JSON, BaseUnit, ClientUnit;

type
  ENfseException = class(EBaseException);

  TIntegraNfse = class(TBase)
  public
    // Métodos V2 (Padrão)
    function Cria(const Payload: TJSONObject): string;
    function Preview(const Payload: TJSONObject): string;
    function Info(const Payload: TJSONObject): string;
    function Substitui(const Payload: TJSONObject): string;

    // Métodos V1 (Deprecated)
    function Cria_Deprecated(const Payload: TJSONObject): string;
    function Preview_Deprecated(const Payload: TJSONObject): string;
    function Info_Deprecated(const Payload: TJSONObject): string;
    function Substitui_Deprecated(const Payload: TJSONObject): string;

    // Demais Métodos
    function Pdf(const Payload: TJSONObject): string;
    function Consulta(const Payload: TJSONObject): string;
    function Cancela(const Payload: TJSONObject): string;
    function Busca(const Payload: TJSONObject): string;
    function Backup(const Payload: TJSONObject): string;
    function Localiza(const Payload: TJSONObject): string;
    function Conflito(const Payload: TJSONObject): string;
    function Offline: string;
    function Resolve(const Payload: TJSONObject): string;
  end;

implementation

{ TIntegraNfse }

// ==========================================
// Métodos V2 (Padrão)
// ==========================================

function TIntegraNfse.Cria(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfse', Payload, '2');
end;

function TIntegraNfse.Preview(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfse/preview', Payload, '2');
end;

function TIntegraNfse.Info(const Payload: TJSONObject): string;
var
  IBGECode: string;
  Val: TJSONValue;
begin
  if not Assigned(Payload) then
    raise ENfseException.Create('Código IBGE é obrigatório para a consulta de informações.');

  IBGECode := '';
  Val := Payload.GetValue<TJSONValue>('ibge', nil);
  if Val <> nil then
    IBGECode := Val.Value;

  if IBGECode.Trim.IsEmpty then
    raise ENfseException.Create('Código IBGE é obrigatório para a consulta de informações.');

  Result := FClient.Send('GET', '/nfse/info/' + IBGECode, nil, '2');
end;

function TIntegraNfse.Substitui(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfse/substitui', Payload, '2');
end;

// ==========================================
// Métodos V1 (Deprecated)
// ==========================================

function TIntegraNfse.Cria_Deprecated(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfse', Payload, '1');
end;

function TIntegraNfse.Preview_Deprecated(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfse/preview', Payload, '1');
end;

function TIntegraNfse.Info_Deprecated(const Payload: TJSONObject): string;
var
  IBGECode: string;
  Val: TJSONValue;
begin
  if not Assigned(Payload) then
    raise ENfseException.Create('Código IBGE é obrigatório para a consulta de informações.');

  IBGECode := '';
  Val := Payload.GetValue<TJSONValue>('ibge', nil);
  if Val <> nil then
    IBGECode := Val.Value;

  if IBGECode.Trim.IsEmpty then
    raise ENfseException.Create('Código IBGE é obrigatório para a consulta de informações.');

  Result := FClient.Send('GET', '/nfse/info/' + IBGECode, nil, '1');
end;

function TIntegraNfse.Substitui_Deprecated(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfse/substitui', Payload, '1');
end;

// ==========================================
// Demais Métodos (V1)
// ==========================================

function TIntegraNfse.Pdf(const Payload: TJSONObject): string;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', '/nfse/pdf/' + Key, nil, '1');
end;

function TIntegraNfse.Consulta(const Payload: TJSONObject): string;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', '/nfse/' + Key, nil, '1');
end;

function TIntegraNfse.Cancela(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfse/cancela', Payload, '1');
end;

function TIntegraNfse.Busca(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfse/busca', Payload, '1');
end;

function TIntegraNfse.Backup(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfse/backup', Payload, '1');
end;

function TIntegraNfse.Localiza(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfse/consulta', Payload, '1');
end;

function TIntegraNfse.Conflito(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/nfse/conflito', Payload, '1');
end;

function TIntegraNfse.Offline: string;
begin
  Result := FClient.Send('GET', '/nfse/offline', nil, '1');
end;

function TIntegraNfse.Resolve(const Payload: TJSONObject): string;
var
  Key: string;
begin
  Key := CheckKey(Payload);
  Result := FClient.Send('GET', '/nfse/resolve/' + Key, nil, '1');
end;

end.
