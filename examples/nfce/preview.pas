unit SDKUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, UtilUnit, NfceUnit, System.JSON;

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
  IntegraNfce: TIntegraNfce;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  Resp: string;
  Params, Payload: TJSONObject;
  JSONResp: TJSONObject;
begin
  FToken := 'TokenDoEmitente';
  FAmbiente := 2; // 1 - Produção, 2 - Homologação
  FTimeout := 60;
  FPort := 443;
  FDebug := False;

  Params := TJSONObject.Create;
  Payload := TJSONObject.Create;
  try
    Params.AddPair('token', FToken);
    Params.AddPair('ambiente', TJSONNumber.Create(FAmbiente));
    Params.AddPair('timeout', TJSONNumber.Create(FTimeout));
    Params.AddPair('port', TJSONNumber.Create(FPort));
    Params.AddPair('debug', TJSONBool.Create(FDebug));

    IntegraNfce := TIntegraNfce.Create(Params);

    try
      Payload.AddPair('natureza_operacao', 'VENDA DENTRO DO ESTADO');
      Payload.AddPair('serie', '1');
      Payload.AddPair('numero', '101008');
      Payload.AddPair('data_emissao', '2021-06-26T15:20:00-03:00');
      Payload.AddPair('tipo_operacao', '1');
      Payload.AddPair('presenca_comprador', '1');

      Payload.AddPair('frete', TJSONObject.Create.AddPair('modalidade_frete', '9'));

      Payload.AddPair('pagamento', TJSONObject.Create.AddPair('formas_pagamento', 
        TJSONArray.Create(TJSONObject.Create.AddPair('meio_pagamento', '01').AddPair('valor', '224.50'))));

      Payload.AddPair('informacoes_adicionais_contribuinte', 
        'PV: 3325 * Rep: DIRETO * Motorista:  * Forma Pagto: 04 DIAS * teste de observação para a nota fiscal * Valor aproximado tributos R$9,43 (4,20%) Fonte: IBPT');

      Payload.AddPair('pessoas_autorizadas', 
        TJSONArray.Create(TJSONObject.Create.AddPair('cnpj', '96256273000170'),
                          TJSONObject.Create.AddPair('cnpj', '80681257000195')));

      // Carregar itens
      var listaItens: TJSONArray := TJSONArray.Create;
      listaItens.Add(TJSONObject.Create.AddPair('numero_item', '1')
                                        .AddPair('codigo_produto', '000297')
                                        .AddPair('descricao', 'SAL GROSSO 50KGS')
                                        .AddPair('codigo_ncm', '84159020')
                                        .AddPair('cfop', '5102')
                                        .AddPair('unidade_comercial', 'SC')
                                        .AddPair('quantidade_comercial', 10)
                                        .AddPair('valor_unitario_comercial', '22.45')
                                        .AddPair('valor_bruto', '224.50')
                                        .AddPair('unidade_tributavel', 'SC')
                                        .AddPair('quantidade_tributavel', '10.00')
                                        .AddPair('valor_unitario_tributavel', '22.45')
                                        .AddPair('origem', '0')
                                        .AddPair('inclui_no_total', '1')
                                        .AddPair('imposto', 
                                          TJSONObject.Create.AddPair('valor_aproximado_tributos', 9.43)
                                                           .AddPair('icms', 
                                                             TJSONObject.Create.AddPair('situacao_tributaria', '102')
                                                                               .AddPair('aliquota_credito_simples', '0')
                                                                               .AddPair('valor_credito_simples', '0')
                                                                               .AddPair('modalidade_base_calculo', '3')
                                                                               .AddPair('valor_base_calculo', '0.00')
                                                                               .AddPair('modalidade_base_calculo_st', '4')
                                                                               .AddPair('aliquota_reducao_base_calculo', '0.00')
                                                                               .AddPair('aliquota', '0.00')
                                                                               .AddPair('aliquota_final', '0.00')
                                                                               .AddPair('valor', '0.00')
                                                                               .AddPair('aliquota_margem_valor_adicionado_st', '0.00')
                                                                               .AddPair('aliquota_reducao_base_calculo_st', '0.00')
                                                                               .AddPair('valor_base_calculo_st', '0.00')
                                                                               .AddPair('aliquota_st', '0.00')
                                                                               .AddPair('valor_st', '0.00'))
                                                           .AddPair('fcp', TJSONObject.Create.AddPair('aliquota', '1.65'))
                                                           .AddPair('pis', 
                                                             TJSONObject.Create.AddPair('situacao_tributaria', '01')
                                                                              .AddPair('valor_base_calculo', 224.5)
                                                                              .AddPair('aliquota', '1.65')
                                                                              .AddPair('valor', '3.70'))
                                                           .AddPair('cofins', 
                                                             TJSONObject.Create.AddPair('situacao_tributaria', '01')
                                                                              .AddPair('valor_base_calculo', 224.5)
                                                                              .AddPair('aliquota', '7.60')
                                                                              .AddPair('valor', '17.06'))));

      Payload.AddPair('itens', listaItens);

      Resp := IntegraNfce.Preview(Payload);
      Resp := UTF8ToString(Resp);

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
      IntegraNfce.Free;
    end;

  finally
    Params.Free;
    Payload.Free;
  end;
end;

end.
