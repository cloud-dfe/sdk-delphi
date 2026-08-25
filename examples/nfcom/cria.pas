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
    procedure ProcessaResposta(const Resp: string);
  public
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

procedure TForm1.ProcessaResposta(const Resp: string);
var
  JSONResp: TJSONObject;
begin
  JSONResp := TJSONObject.ParseJSONValue(Resp) as TJSONObject;
  try
    if Assigned(JSONResp) then
      ShowMessage(JSONResp.Format)
    else
      ShowMessage('Erro ao converter a resposta para JSON');
  finally
    JSONResp.Free;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  Resp: string;
  Params, Payload, Dest, Ender, Assinante, ItemObj, Imposto, ICMS, PIS, COFINS: TJSONObject;
  ListaItens: TJSONArray;
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
      // Monta o payload com campos nulos explicitados
      Payload := TJSONObject.Create;
      try
        Payload.AddPair('numero', '12345');
        Payload.AddPair('serie', '1');
        Payload.AddPair('data_emissao', '2024-05-16T12:33:20-03:00');
        Payload.AddPair('finalidade_emissao', '0');
        Payload.AddPair('tipo_faturamento', '0');

        // Destinatário (com alguns campos nulos)
        Dest := TJSONObject.Create;
        try
          Dest.AddPair('nome', 'Nome do Destinatario');
          Dest.AddPair('indicador_inscricao_estadual', '9');
          // Inscricao estadual nula explicitamente
          Dest.AddPair('inscricao_estadual', TJSONNull.Create);

          Ender := TJSONObject.Create;
          try
            Ender.AddPair('logradouro', 'Rua Exemplo');
            Ender.AddPair('numero', '100');
            Ender.AddPair('bairro', 'Centro');
            Ender.AddPair('codigo_municipio', '1234567');
            Ender.AddPair('nome_municipio', 'Cidade Exemplo');
            Ender.AddPair('uf', 'SP');
            // complemento nulo (exemplo)
            Ender.AddPair('complemento', TJSONNull.Create);
            // telefone nulo
            Ender.AddPair('telefone', TJSONNull.Create);

            Dest.AddPair('endereco', Ender);
            Ender := nil; // ender está agora adicionado ao Dest, não liberar aqui
          finally
            // não free Ender aqui pois já foi anexado a Dest
          end;

          Payload.AddPair('destinatario', Dest);
          Dest := nil; // já anexado
        finally
          // não free Dest pois foi anexado ao Payload
        end;

        // Assinante (exemplo)
        Assinante := TJSONObject.Create;
        try
          Assinante.AddPair('codigo', 'ASSINANTE123');
          Assinante.AddPair('tipo', '1');
          Assinante.AddPair('servico', '4');
          Payload.AddPair('assinante', Assinante);
          Assinante := nil;
        finally
        end;

        // Itens
        ListaItens := TJSONArray.Create;
        try
          ItemObj := TJSONObject.Create;
          try
            ItemObj.AddPair('numero_item', '1');
            ItemObj.AddPair('codigo_produto', 'PROD001');
            ItemObj.AddPair('descricao', 'Descrição do produto ou serviço');
            ItemObj.AddPair('codigo_classificacao', '1234567');
            ItemObj.AddPair('unidade_medida', '1');
            ItemObj.AddPair('quantidade', '1.0000');
            // valores numéricos usando TJSONNumber
            ItemObj.AddPair('valor_unitario', TJSONNumber.Create(100.0));
            ItemObj.AddPair('valor_total', TJSONNumber.Create(100.0));

            // imposto
            Imposto := TJSONObject.Create;
            try
              // ICMS com apenas situacao informado; outros campos podem ser nulos ou omitidos
              ICMS := TJSONObject.Create;
              try
                ICMS.AddPair('situacao_tributaria', '00');
                // se quiser colocar explicitamente um campo nulo:
                ICMS.AddPair('aliquota', TJSONNull.Create);
                Imposto.AddPair('icms', ICMS);
                ICMS := nil;
              finally
              end;

              // PIS
              PIS := TJSONObject.Create;
              try
                PIS.AddPair('situacao_tributaria', '01');
                PIS.AddPair('valor_base_calculo', TJSONNumber.Create(100.00));
                PIS.AddPair('aliquota', TJSONNumber.Create(1.65));
                PIS.AddPair('valor', TJSONNumber.Create(1.65));
                Imposto.AddPair('pis', PIS);
                PIS := nil;
              finally
              end;

              // COFINS
              COFINS := TJSONObject.Create;
              try
                COFINS.AddPair('situacao_tributaria', '01');
                COFINS.AddPair('valor_base_calculo', TJSONNumber.Create(100.00));
                COFINS.AddPair('aliquota', TJSONNumber.Create(7.60));
                COFINS.AddPair('valor', TJSONNumber.Create(7.60));
                Imposto.AddPair('cofins', COFINS);
                COFINS := nil;
              finally
              end;

              ItemObj.AddPair('imposto', Imposto);
              Imposto := nil;
            finally
            end;

            ListaItens.Add(ItemObj);
            ItemObj := nil;
          finally
          end;

          Payload.AddPair('itens', ListaItens);
          ListaItens := nil;
        finally
        end;

        // Exemplo: campos opcionais nulos no topo do payload
        Payload.AddPair('observacao', TJSONNull.Create);
        Payload.AddPair('campo_opcional', TJSONNull.Create);

        // Envia
        Resp := IntegraNfcom.Cria(Payload);
        // Se a função retorna Ansi/UTF8, converta conforme necessário:
        ProcessaResposta(Resp);

      finally
        // Payload e quaisquer objetos ligados foram anexados e não devem ser freed aqui diretamente.
        // Para garantir limpeza segura se algum objeto não foi anexado, poderia checar Assigned e Free.
        // Entretanto, seguindo o padrão acima, não chamamos Free em objetos já adicionados aos pais.
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