unit SDKUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, 
  System.JSON, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, 
  UtilUnit, NfabiUnit;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  FToken: string;
  FAmbiente: Integer;
  FTimeout: Integer;
  FPort: Integer;
  FDebug: Boolean;
  IntegraNfabi: TIntegraNfabi;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  Resp: string;
  Params, Payload, JSONResp: TJSONObject;
begin
  FToken := 'TokenDoEmitente';
  FAmbiente := 2; // 1 - Produção, 2 - Homologação
  FTimeout := 60;
  FPort := 443;
  FDebug := False;

  Params := TJSONObject.Create;
  try
    Params.AddPair('token', FToken);
    Params.AddPair('ambiente', TJSONNumber.Create(FAmbiente));
    Params.AddPair('timeout', TJSONNumber.Create(FTimeout));
    Params.AddPair('port', TJSONNumber.Create(FPort));
    Params.AddPair('debug', TJSONBool.Create(FDebug));

    IntegraNfabi := TIntegraNfabi.Create(Params);

    try
      Payload := TJSONObject.ParseJSONValue('{"identificacao": "teste-nfabi-1", "numero": "123", "serie": "1", "data_emissao": "2026-12-14T10:00:00-03:00", "tipo_documento": "0", "finalidade": "1", "tipo_emitente": "01", "operacao": {"modalidade": "01", "natureza": "01", "detalhamento": "02", "valor_total": "500000.00", "incorporacao": {"indicador": "0"}, "instrumento": {"tipo": "03", "data": "2026-11-10"}}, "transmitentes": [{"cnpj": "10944071000104", "nome": "VENDEDOR TESTE LTDA", "contribuinte": "1"}], "adquirentes": [{"cpf": "98765432100", "nome": "Comprador Teste", "endereco": {"logradouro": "Rua A", "numero": "10", "bairro": "Centro", "codigo_municipio": "2927408", "nome_municipio": "Salvador", "uf": "BA", "cep": "40000000"}}], "imovel": {"tipo": "1", "especie": "02", "enquadramento": "02", "area_total": "250", "unidade_area": "m2", "matricula": "9999", "cadastro": {"possui_iptu": true, "iptu": "123456"}, "endereco": {"logradouro": "Rua B", "numero": "20", "bairro": "Centro", "codigo_municipio": "2927408", "nome_municipio": "Salvador", "uf": "BA", "cep": "40000000"}}, "tributacao": {"cst": "200", "classificacao_tributaria": "200046", "ibscbs": {"valor_operacao": "500000.00", "base_calculo": "500000.00", "ibs_uf": {"aliquota": "0.1000", "reducao_aliquota": "50.0000", "aliquota_efetiva": "0.0500", "valor": "250.00"}, "ibs_municipal": {"aliquota": "0.0000", "reducao_aliquota": "50.0000", "aliquota_efetiva": "0.0000", "valor": "0.00"}, "cbs": {"aliquota": "0.9000", "reducao_aliquota": "50.0000", "aliquota_efetiva": "0.4500", "valor": "2250.00"}}}, "pagamentos": {"imovel": [{"tipo": "01", "valor": "500000.00"}]}, "informacoes_adicionais_contribuinte": "Teste local"}') as TJSONObject;
      try

        Resp := IntegraNfabi.Preview(Payload);
        JSONResp := TJSONObject.ParseJSONValue(Resp) as TJSONObject;
        try
          if Assigned(JSONResp) then
            ShowMessage(JSONResp.Format)
          else
            ShowMessage('Erro ao converter a resposta para JSON');
        finally
          JSONResp.Free;
        end;
      finally
        Payload.Free;
      end;

    finally
      IntegraNfabi.Free;
    end;

  finally
    Params.Free;
  end;
end;

end.
