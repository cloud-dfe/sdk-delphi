unit SDKUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, NfeUnit, System.JSON;

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
  IntegraNfe: TIntegraNfe;

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

    IntegraNfe := TIntegraNfe.Create(Params);

    try
      Payload := TJSONObject.Create;
      try
        Payload.AddPair('natureza_operacao', 'VENDA DENTRO DO ESTADO');
        Payload.AddPair('serie', '1');
        Payload.AddPair('numero', '101003');
        Payload.AddPair('data_emissao', '2021-02-09T17:00:00-03:00');
        Payload.AddPair('data_entrada_saida', '2021-02-09T17:00:00-03:00');
        Payload.AddPair('tipo_operacao', '1');
        Payload.AddPair('finalidade_emissao', '1');
        Payload.AddPair('consumidor_final', '1');
        Payload.AddPair('presenca_comprador', '9');

        Payload.AddPair('intermediario', TJSONObject.Create.AddPair('indicador', '0'));

        var notasReferenciadas := TJSONArray.Create;
        var nota := TJSONObject.Create;
        nota.AddPair('nfe', TJSONObject.Create.AddPair('chave', '50000000000000000000000000000000000000000000'));
        notasReferenciadas.Add(nota);
        Payload.AddPair('notas_referenciadas', notasReferenciadas);

        var destinatario := TJSONObject.Create;
        destinatario.AddPair('cpf', '01234567890');
        destinatario.AddPair('nome', 'EMPRESA MODELO');
        destinatario.AddPair('indicador_inscricao_estadual', '9');
        destinatario.AddPair('inscricao_estadual', TJSONNull.Create);
        
        var endereco := TJSONObject.Create;
        endereco.AddPair('logradouro', 'AVENIDA TESTE');
        endereco.AddPair('numero', '444');
        endereco.AddPair('bairro', 'CENTRO');
        endereco.AddPair('codigo_municipio', '4108403');
        endereco.AddPair('nome_municipio', 'Mossoro');
        endereco.AddPair('uf', 'PR');
        endereco.AddPair('cep', '59653120');
        endereco.AddPair('codigo_pais', '1058');
        endereco.AddPair('nome_pais', 'BRASIL');
        endereco.AddPair('telefone', '8499995555');
        destinatario.AddPair('endereco', endereco);

        Payload.AddPair('destinatario', destinatario);

        var itens := TJSONArray.Create;
        var item := TJSONObject.Create;
        item.AddPair('numero_item', '1');
        item.AddPair('codigo_produto', '000297');
        item.AddPair('descricao', 'SAL GROSSO 50KGS');
        item.AddPair('codigo_ncm', '84159020');
        item.AddPair('cfop', '5102');
        item.AddPair('unidade_comercial', 'SC');
        item.AddPair('quantidade_comercial', '10');
        item.AddPair('valor_unitario_comercial', '22.45');
        item.AddPair('valor_bruto', '224.50');
        item.AddPair('unidade_tributavel', 'SC');
        item.AddPair('quantidade_tributavel', '10.00');
        item.AddPair('valor_unitario_tributavel', '22.45');
        item.AddPair('origem', '0');
        item.AddPair('inclui_no_total', '1');

        var imposto := TJSONObject.Create;
        imposto.AddPair('valor_aproximado_tributos', 9.43);
        var icms := TJSONObject.Create;
        icms.AddPair('situacao_tributaria', '102');
        icms.AddPair('aliquota_credito_simples', '0');
        icms.AddPair('valor_credito_simples', '0');
        icms.AddPair('modalidade_base_calculo', '3');
        icms.AddPair('valor_base_calculo', '0.00');
        icms.AddPair('modalidade_base_calculo_st', '4');
        icms.AddPair('aliquota_reducao_base_calculo', '0.00');
        icms.AddPair('aliquota', '0.00');
        icms.AddPair('aliquota_final', '0.00');
        icms.AddPair('valor', '0.00');
        icms.AddPair('aliquota_margem_valor_adicionado_st', '0.00');
        icms.AddPair('aliquota_reducao_base_calculo_st', '0.00');
        icms.AddPair('valor_base_calculo_st', '0.00');
        icms.AddPair('aliquota_st', '0.00');
        icms.AddPair('valor_st', '0.00');
        imposto.AddPair('icms', icms);

        var fcp := TJSONObject.Create;
        fcp.AddPair('aliquota', '1.65');
        imposto.AddPair('fcp', fcp);

        var pis := TJSONObject.Create;
        pis.AddPair('situacao_tributaria', '01');
        pis.AddPair('valor_base_calculo', 224.5);
        pis.AddPair('aliquota', '1.65');
        pis.AddPair('valor', '3.70');
        imposto.AddPair('pis', pis);

        var cofins := TJSONObject.Create;
        cofins.AddPair('situacao_tributaria', '01');
        cofins.AddPair('valor_base_calculo', 224.5);
        cofins.AddPair('aliquota', '7.60');
        cofins.AddPair('valor', '17.06');
        imposto.AddPair('cofins', cofins);

        item.AddPair('imposto', imposto);

        itens.Add(item);
        Payload.AddPair('itens', itens);

        var frete := TJSONObject.Create;
        frete.AddPair('modalidade_frete', '0');

        var volumes := TJSONArray.Create;
        var volume := TJSONObject.Create;
        volume.AddPair('quantidade', '10');
        volume.AddPair('especie', TJSONNull.Create);
        volume.AddPair('marca', 'TESTE');
        volume.AddPair('numero', TJSONNull.Create);
        volume.AddPair('peso_liquido', '500');
        volume.AddPair('peso_bruto', '500');
        volumes.Add(volume);

        frete.AddPair('volumes', volumes);
        Payload.AddPair('frete', frete);

        var cobranca := TJSONObject.Create;
        var fatura := TJSONObject.Create;
        fatura.AddPair('numero', '1035.00');
        fatura.AddPair('valor_original', '224.50');
        fatura.AddPair('valor_desconto', '0.00');
        fatura.AddPair('valor_liquido', '224.50');
        cobranca.AddPair('fatura', fatura);
        Payload.AddPair('cobranca', cobranca);

        var pagamento := TJSONObject.Create;
        var formasPagamento := TJSONArray.Create;
        var formaPagamento := TJSONObject.Create;
        formaPagamento.AddPair('meio_pagamento', '01');
        formaPagamento.AddPair('valor', '224.50');
        formasPagamento.Add(formaPagamento);
        pagamento.AddPair('formas_pagamento', formasPagamento);
        Payload.AddPair('pagamento', pagamento);

        Payload.AddPair('informacoes_adicionais_contribuinte', 
          'PV: 3325 * Rep: DIRETO * Motorista:  * Forma Pagto: 04 DIAS * teste de observação para a nota fiscal * Valor aproximado tributos R$9,43 (4,20%) Fonte: IBPT');

        var pessoasAutorizadas := TJSONArray.Create;
        var pessoa1 := TJSONObject.Create;
        pessoa1.AddPair('cnpj', '96256273000170');
        pessoasAutorizadas.Add(pessoa1);

        var pessoa2 := TJSONObject.Create;
        pessoa2.AddPair('cnpj', '80681257000195');
        pessoasAutorizadas.Add(pessoa2);

        Payload.AddPair('pessoas_autorizadas', pessoasAutorizadas);

        Resp := IntegraNfe.Preview(Payload);
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
        Payload.Free;
      end;

    finally
      IntegraNfe.Free;
    end;

  finally
    Params.Free;
  end;
end;

end.
