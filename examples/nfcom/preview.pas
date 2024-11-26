unit SDKUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, 
  System.JSON, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, 
  UtilUnit, NfcomUnit;

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
  IntegraNfcom: TIntegraNfcom;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  Resp: string;
  Params, Payload, Item, Destinatario, Endereco, Assinante, Cobranca, Imposto, Icms, Fcp, JSONResp: TJSONObject;
  ItensArray: TJSONArray;
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

    IntegraNfcom := TIntegraNfcom.Create(Params);

    try
      Payload := TJSONObject.Create;
      try
        Payload.AddPair('numero', '3');
        Payload.AddPair('serie', '1');
        Payload.AddPair('data_emissao', '2024-06-20T13:23:00-03:00');
        Payload.AddPair('finalidade_emissao', '0');
        Payload.AddPair('tipo_faturamento', '0');
        Payload.AddPair('indicador_prepago', '0');
        Payload.AddPair('indicador_cessao_meios_rede', '0');

        Destinatario := TJSONObject.Create;
        try
          Destinatario.AddPair('nome', 'HELIO WOLFF');
          Destinatario.AddPair('cpf', '06844990960');
          Destinatario.AddPair('cnpj', '');
          Destinatario.AddPair('id_outros', '');
          Destinatario.AddPair('inscricao_estadual', TJSONNull.Create);
          Destinatario.AddPair('indicador_inscricao_estadual', '9');

          Endereco := TJSONObject.Create;
          try
            Endereco.AddPair('logradouro', 'LOJA');
            Endereco.AddPair('complemento', TJSONNull.Create);
            Endereco.AddPair('numero', 'SN');
            Endereco.AddPair('bairro', 'BANANAL');
            Endereco.AddPair('codigo_municipio', '4314035');
            Endereco.AddPair('nome_municipio', 'Pareci Novo');
            Endereco.AddPair('uf', 'RS');
            Endereco.AddPair('codigo_pais', '1058');
            Endereco.AddPair('nome_pais', 'Brasil');
            Endereco.AddPair('cep', '95783000');
            Endereco.AddPair('telefone', TJSONNull.Create);
            Endereco.AddPair('email', TJSONNull.Create);
            Destinatario.AddPair('endereco', Endereco);
          finally
            Endereco.Free;
          end;

          Payload.AddPair('destinatario', Destinatario);
        finally
          Destinatario.Free;
        end;

        Assinante := TJSONObject.Create;
        try
          Assinante.AddPair('codigo', '123');
          Assinante.AddPair('tipo', '3');
          Assinante.AddPair('servico', '4');
          Assinante.AddPair('numero_contrato', '12345678');
          Assinante.AddPair('data_inicio', '2022-01-01');
          Assinante.AddPair('data_fim', '2022-01-01');
          Assinante.AddPair('numero_terminal', TJSONNull.Create);
          Assinante.AddPair('uf', TJSONNull.Create);
          Payload.AddPair('assinante', Assinante);
        finally
          Assinante.Free;
        end;

        Cobranca := TJSONObject.Create;
        try
          Cobranca.AddPair('data_competencia', '2024-06-01');
          Cobranca.AddPair('data_vencimento', '2024-06-30');
          Cobranca.AddPair('codigo_barras', '19872982798277298279287298728278272872872');
          Payload.AddPair('cobranca', Cobranca);
        finally
          Cobranca.Free;
        end;

        Payload.AddPair('informacoes_adicionais_contribuinte', '');

        ItensArray := TJSONArray.Create;
        try
          Item := TJSONObject.Create;
          try
            Item.AddPair('numero_item', '1');
            Item.AddPair('codigo_produto', '123');
            Item.AddPair('descricao', 'LP 1MB');
            Item.AddPair('codigo_classificacao', '0400401');
            Item.AddPair('cfop', '5301');
            Item.AddPair('unidade_medida', '1');
            Item.AddPair('quantidade', '1');
            Item.AddPair('valor_unitario', '10.00');
            Item.AddPair('valor_desconto', '0');
            Item.AddPair('valor_outras_despesas', '0');
            Item.AddPair('valor_bruto', '10.00');
            Item.AddPair('indicador_devolucao', '0');
            Item.AddPair('informacoes_adicionais', 'teste');

            Imposto := TJSONObject.Create;
            try
              Icms := TJSONObject.Create;
              try
                Icms.AddPair('situacao_tributaria', '00');
                Icms.AddPair('valor_base_calculo', '10.00');
                Icms.AddPair('aliquota', '18.00');
                Icms.AddPair('valor', '1.80');
                Imposto.AddPair('icms', Icms);
              finally
                Icms.Free;
              end;

              Fcp := TJSONObject.Create;
              try
                Fcp.AddPair('aliquota', TJSONNull.Create);
                Fcp.AddPair('valor', TJSONNull.Create);
                Imposto.AddPair('fcp', Fcp);
              finally
                Fcp.Free;
              end;

              Item.AddPair('imposto', Imposto);
            finally
              Imposto.Free;
            end;

            ItensArray.AddElement(Item);
          finally
            Item.Free;
          end;

          Payload.AddPair('itens', ItensArray);
        finally
          ItensArray.Free;
        end;

        Resp := IntegraNfcom.Preview(Payload);
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
      IntegraNfcom.Free;
    end;

  finally
    Params.Free;
  end;
end;

end.
