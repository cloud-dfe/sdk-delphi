unit CiotUnit;

interface

uses
  System.SysUtils, System.Classes, BaseUnit, System.JSON, ClientUnit, System.RegularExpressions, System.NetEncoding;

type
  ECiotException = class(EBaseException);

  TIntegraCiot = class(TBase)
  private
    function CheckIdentificacao(const Payload: TJSONObject): string;
  public
    function Cria(const Payload: TJSONObject): string;
    function Consulta(const Payload: TJSONObject): string;
    function Busca(const Payload: TJSONObject): string;
    function Cancela(const Payload: TJSONObject): string;
    function Encerra(const Payload: TJSONObject): string;
    function Retifica(const Payload: TJSONObject): string;
    function Pdf(const Payload: TJSONObject): string;
    function Transportador(const Payload: TJSONObject): string;
  end;

implementation

{ TIntegraCiot }

// o CIOT é identificado pela identificação informada na criação, não por chave de acesso
function TIntegraCiot.CheckIdentificacao(const Payload: TJSONObject): string;
var
  Val: TJSONValue;
  Identificacao: string;
begin
  if not Assigned(Payload) then
    raise ECiotException.Create('O payload não pode ser nulo.');

  Identificacao := '';
  Val := Payload.GetValue<TJSONValue>('identificacao', nil);
  if Val <> nil then
    Identificacao := Trim(Val.Value);

  if not TRegEx.IsMatch(Identificacao, '^[A-Za-z0-9._-]{1,40}$') then
    raise ECiotException.Create('A identificação do CIOT deve ter de 1 a 40 caracteres: letras, números, ponto, hífen ou sublinhado.');

  Result := TNetEncoding.URL.Encode(Identificacao);
end;

function TIntegraCiot.Cria(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/ciot', Payload);
end;

function TIntegraCiot.Consulta(const Payload: TJSONObject): string;
var
  Identificacao: string;
begin
  Identificacao := CheckIdentificacao(Payload);
  Result := FClient.Send('GET', '/ciot/' + Identificacao);
end;

function TIntegraCiot.Busca(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/ciot/busca', Payload);
end;

function TIntegraCiot.Cancela(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/ciot/cancela', Payload);
end;

function TIntegraCiot.Encerra(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/ciot/encerra', Payload);
end;

function TIntegraCiot.Retifica(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/ciot/retifica', Payload);
end;

function TIntegraCiot.Pdf(const Payload: TJSONObject): string;
var
  Identificacao: string;
begin
  Identificacao := CheckIdentificacao(Payload);
  Result := FClient.Send('GET', '/ciot/pdf/' + Identificacao);
end;

function TIntegraCiot.Transportador(const Payload: TJSONObject): string;
begin
  Result := FClient.Send('POST', '/ciot/transportador', Payload);
end;

end.
