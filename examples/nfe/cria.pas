unit SDKUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, UtilUnit, NfeUnit, System.JSON;

type
  TForm1 = class(TForm)
    ButtonCria: TButton;
    procedure ButtonCriaClick(Sender: TObject);
  private
    { Private declarations }
    procedure ProcessaNfeResposta(const RespJSON: string);
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

procedure TForm1.ButtonCriaClick(Sender: TObject);
var
  Resp: string;
  Params, Payload, Item, JSONResp: TJSONObject;
  ListaItens: TJSONArray;
  ItemObj: TJSONObject;
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
        Payload.AddPair('numero', '101007');
        Payload.AddPair('data_emissao', '2021-06-26T13:00:00-03:00');
        Payload.AddPair('data_entrada_saida', '2021-06-26T13:00:00-03:00');
        Payload.AddPair('tipo_operacao', '1');
        Payload.AddPair('finalidade_emissao', '1');
        Payload.AddPair('consumidor_final', '1');
        Payload.AddPair('presenca_comprador', '9');

        ItemObj := TJSONObject.Create;
        ItemObj.AddPair('indicador', '0');
        Payload.AddPair('intermediario', ItemObj);

        ListaItens := TJSONArray.Create;
        ItemObj := TJSONObject.Create;
        ItemObj.AddPair('nfe', TJSONObject.Create.AddPair('chave', '50000000000000000000000000000000000000000000'));
        ListaItens.Add(ItemObj);
        Payload.AddPair('notas_referenciadas', ListaItens);

        ItemObj := TJSONObject.Create;
        ItemObj.AddPair('cpf', '01234567890');
        ItemObj.AddPair('nome', 'EMPRESA MODELO');
        ItemObj.AddPair('indicador_inscricao_estadual', '9');
        ItemObj.AddPair('inscricao_estadual', TJSONNull.Create);

        ItemObj.AddPair('endereco', TJSONObject.Create.AddPair('logradouro', 'AVENIDA TESTE')
                                                      .AddPair('numero', '444')
                                                      .AddPair('bairro', 'CENTRO')
                                                      .AddPair('codigo_municipio', '4108403')
                                                      .AddPair('nome_municipio', 'Mossoro')
                                                      .AddPair('uf', 'PR')
                                                      .AddPair('cep', '59653120')
                                                      .AddPair('codigo_pais', '1058')
                                                      .AddPair('nome_pais', 'BRASIL')
                                                      .AddPair('telefone', '8499995555'));
        Payload.AddPair('destinatario', ItemObj);

        ListaItens := TJSONArray.Create;
        ItemObj := TJSONObject.Create;
        ItemObj.AddPair('numero_item', '1');
        ItemObj.AddPair('codigo_produto', '000297');
        ItemObj.AddPair('descricao', 'SAL GROSSO 50KGS');
        ItemObj.AddPair('codigo_ncm', '84159020');
        ItemObj.AddPair('cfop', '5102');
        ItemObj.AddPair('unidade_comercial', 'SC');
        ItemObj.AddPair('quantidade_comercial', '10');
        ItemObj.AddPair('valor_unitario_comercial', '22.45');
        ItemObj.AddPair('valor_bruto', '224.50');
        ItemObj.AddPair('unidade_tributavel', 'SC');
        ItemObj.AddPair('quantidade_tributavel', '10.00');
        ItemObj.AddPair('valor_unitario_tributavel', '22.45');
        ItemObj.AddPair('origem', '0');
        ItemObj.AddPair('inclui_no_total', '1');

        ItemObj.AddPair('imposto', TJSONObject.Create.AddPair('valor_aproximado_tributos', 9.43)
                                                    .AddPair('icms', TJSONObject.Create.AddPair('situacao_tributaria', '102')
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
                                                                                      .AddPair('valor_st', '0.00'));

        ItemObj.AddPair('fcp', TJSONObject.Create.AddPair('aliquota', '1.65'));

        ItemObj.AddPair('pis', TJSONObject.Create.AddPair('situacao_tributaria', '01')
                                                 .AddPair('valor_base_calculo', 224.5)
                                                 .AddPair('aliquota', '1.65')
                                                 .AddPair('valor', '3.70'));

        ItemObj.AddPair('cofins', TJSONObject.Create.AddPair('situacao_tributaria', '01')
                                                   .AddPair('valor_base_calculo', 224.5)
                                                   .AddPair('aliquota', '7.60')
                                                   .AddPair('valor', '17.06'));

        ListaItens.Add(ItemObj);
        Payload.AddPair('itens', ListaItens);

        Payload.AddPair('informacoes_adicionais_contribuinte', 'PV: 3325 * Rep: DIRETO * Motorista:  * Forma Pagto: 04 DIAS * teste de observação para a nota fiscal * Valor aproximado tributos R$9,43 (4,20%) Fonte: IBPT');
        Payload.AddPair('pessoas_autorizadas', TJSONArray.Create.Add(TJSONObject.Create.AddPair('cnpj', '96256273000170'))
                                                            .Add(TJSONObject.Create.AddPair('cnpj', '80681257000195')));

        Resp := IntegraNfe.Cria(Payload);

        ProcessaNfeResposta(Resp);

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

procedure TForm1.ProcessaNfeResposta(const RespJSON: string);
var
  JSONResp, Payload, ConsultaResp: TJSONObject;
  Chave: string;
  Codigo, Tentativa: Integer;
  Sucesso: Boolean;
begin
  JSONResp := TJSONObject.ParseJSONValue(RespJSON) as TJSONObject;
  try
    if Assigned(JSONResp) then
    begin
      Sucesso := JSONResp.GetValue<Boolean>('sucesso');
      Codigo := JSONResp.GetValue<Integer>('codigo');
      
      if Sucesso then
      begin
        Chave := JSONResp.GetValue<string>('chave');
        Sleep(5000);
        Tentativa := 1;

        while Tentativa <= 5 do
        begin
          Payload := TJSONObject.Create;
          try
            Payload.AddPair('chave', Chave);
            ConsultaResp := TJSONObject.ParseJSONValue(IntegraNfe.Consulta(Payload)) as TJSONObject;
            try
              if Assigned(ConsultaResp) then
              begin
                Codigo := ConsultaResp.GetValue<Integer>('codigo');
                Sucesso := ConsultaResp.GetValue<Boolean>('sucesso');
                if Codigo <> 5023 then
                begin
                  if Sucesso then
                  begin
                    ShowMessage('NFe autorizada: ' + ConsultaResp.Format);
                  end
                  else
                  begin
                    ShowMessage('NFe rejeitada: ' + ConsultaResp.Format);
                  end;
                  Break;
                end;
              end;
            finally
              ConsultaResp.Free;
            end;
          finally
            Payload.Free;
          end;
          Sleep(5000);
          Inc(Tentativa);
        end;
      end
      else if (Codigo = 5001) or (Codigo = 5002) then
      begin
        ShowMessage('Erro nos campos: ' + JSONResp.GetValue<TJSONArray>('erros').ToString);
      end
      else if (Codigo = 5008) or (Codigo >= 7000) then
      begin
        Chave := JSONResp.GetValue<string>('chave');
        ShowMessage('Erro de timeout ou conexão. Sincronizando documento.');

        Payload := TJSONObject.Create;
        try
          Payload.AddPair('chave', Chave);
          ConsultaResp := TJSONObject.ParseJSONValue(IntegraNfe.Consulta(Payload)) as TJSONObject;
          try
            if Assigned(ConsultaResp) then
            begin
              Sucesso := ConsultaResp.GetValue<Boolean>('sucesso');
              Codigo := ConsultaResp.GetValue<Integer>('codigo');

              if Sucesso and (Codigo = 5023) then
              begin
                ShowMessage('NFe autorizada: ' + ConsultaResp.Format);
              end
              else
              begin
                ShowMessage('NFe rejeitada: ' + ConsultaResp.Format);
              end;
            end;
          finally
            ConsultaResp.Free;
          end;
        finally
          Payload.Free;
        end;
      end
      else
      begin
        ShowMessage('NFe rejeitada: ' + JSONResp.Format);
      end;
    end
    else
    begin
      ShowMessage('Erro ao interpretar resposta JSON');
    end;
  finally
    JSONResp.Free;
  end;
end;

end.
