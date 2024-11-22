unit SDKUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, UtilUnit, CteOSUnit, System.JSON;

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
  IntegraCteOS: TIntegraCteOS;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  Resp: string;
  Params, Payload, Valores, Quantidades, Impostos, ICMS, Nfes, ModalRodoviario, Remetente, EnderecoRemetente, Destinatario, EnderecoDestinatario, ComponentesValor, Tomador, JSONResp: TJSONObject;
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

    IntegraCteOS := TIntegraCteOS.Create(Params);

    try
      Payload := TJSONObject.Create;
      try
        Payload.AddPair('cfop', '5932');
        Payload.AddPair('natureza_operacao', 'PRESTACAO DE SERVIÇO');
        Payload.AddPair('numero', '66');
        Payload.AddPair('serie', '1');
        Payload.AddPair('data_emissao', '2021-06-22T03:00:00-03:00');
        Payload.AddPair('tipo_operacao', '0');
        Payload.AddPair('codigo_municipio_envio', '2408003');
        Payload.AddPair('nome_municipio_envio', 'MOSSORO');
        Payload.AddPair('uf_envio', 'RN');
        Payload.AddPair('tipo_servico', '0');
        Payload.AddPair('codigo_municipio_inicio', '2408003');
        Payload.AddPair('nome_municipio_inicio', 'Mossoró');
        Payload.AddPair('uf_inicio', 'RN');
        Payload.AddPair('codigo_municipio_fim', '2408003');
        Payload.AddPair('nome_municipio_fim', 'Mossoró');
        Payload.AddPair('uf_fim', 'RN');
        Payload.AddPair('retirar_mercadoria', '1');
        Payload.AddPair('detalhes_retirar', TJSONNull.Create);
        Payload.AddPair('tipo_programacao_entrega', '0');
        Payload.AddPair('sem_hora_tipo_hora_programada', '0');
        
        Remetente := TJSONObject.Create;
        Remetente.AddPair('cpf', '01234567890');
        Remetente.AddPair('inscricao_estadual', TJSONNull.Create);
        Remetente.AddPair('nome', 'EMPRESA MODELO');
        Remetente.AddPair('razao_social', 'MODELO LTDA');
        Remetente.AddPair('telefone', '8433163070');
        
        EnderecoRemetente := TJSONObject.Create;
        EnderecoRemetente.AddPair('logradouro', 'AVENIDA TESTE');
        EnderecoRemetente.AddPair('numero', '444');
        EnderecoRemetente.AddPair('bairro', 'CENTRO');
        EnderecoRemetente.AddPair('codigo_municipio', '2408003');
        EnderecoRemetente.AddPair('nome_municipio', 'MOSSORÓ');
        EnderecoRemetente.AddPair('uf', 'RN');
        Remetente.AddPair('endereco', EnderecoRemetente);
        
        Payload.AddPair('remetente', Remetente);

        Valores := TJSONObject.Create;
        Valores.AddPair('valor_total', '0.00');
        Valores.AddPair('valor_receber', '0.00');
        Valores.AddPair('valor_total_carga', '224.50');
        Valores.AddPair('produto_predominante', 'SAL');
        
        Quantidades := TJSONArray.Create;
        Quantidades.Add(TJSONObject.Create.AddPair('codigo_unidade_medida', '01').AddPair('tipo_medida', 'Peso Bruto').AddPair('quantidade', '500.00'));
        Valores.AddPair('quantidades', Quantidades);
        
        Payload.AddPair('valores', Valores);

        Impostos := TJSONObject.Create;
        ICMS := TJSONObject.Create;
        ICMS.AddPair('situacao_tributaria', '20');
        ICMS.AddPair('valor_base_calculo', '0.00');
        ICMS.AddPair('aliquota', '12.00');
        ICMS.AddPair('valor', '0.00');
        ICMS.AddPair('aliquota_reducao_base_calculo', '50.00');
        Impostos.AddPair('icms', ICMS);
        Payload.AddPair('imposto', Impostos);

        Nfes := TJSONArray.Create;
        Nfes.Add(TJSONObject.Create.AddPair('chave', '50000000000000000000000000000000000000000000'));
        Payload.AddPair('nfes', Nfes);

        ModalRodoviario := TJSONObject.Create;
        ModalRodoviario.AddPair('rntrc', '02033517');
        Payload.AddPair('modal_rodoviario', ModalRodoviario);

        Destinatario := TJSONObject.Create;
        Destinatario.AddPair('cpf', '01234567890');
        Destinatario.AddPair('inscricao_estadual', TJSONNull.Create);
        Destinatario.AddPair('nome', 'EMPRESA MODELO');
        Destinatario.AddPair('telefone', '8499995555');
        
        EnderecoDestinatario := TJSONObject.Create;
        EnderecoDestinatario.AddPair('logradouro', 'AVENIDA TESTE');
        EnderecoDestinatario.AddPair('numero', '444');
        EnderecoDestinatario.AddPair('bairro', 'CENTRO');
        EnderecoDestinatario.AddPair('codigo_municipio', '2408003');
        EnderecoDestinatario.AddPair('nome_municipio', 'Mossoró');
        EnderecoDestinatario.AddPair('cep', '59603330');
        EnderecoDestinatario.AddPair('uf', 'RN');
        EnderecoDestinatario.AddPair('codigo_pais', '1058');
        EnderecoDestinatario.AddPair('nome_pais', 'BRASIL');
        EnderecoDestinatario.AddPair('email', 'teste@teste.com.br');
        Destinatario.AddPair('endereco', EnderecoDestinatario);
        
        Payload.AddPair('destinatario', Destinatario);

        ComponentesValor := TJSONArray.Create;
        ComponentesValor.Add(TJSONObject.Create.AddPair('nome', 'teste2').AddPair('valor', '1999.00'));
        Payload.AddPair('componentes_valor', ComponentesValor);

        Tomador := TJSONObject.Create;
        Tomador.AddPair('tipo', '3');
        Tomador.AddPair('indicador_inscricao_estadual', '9');
        Payload.AddPair('tomador', Tomador);

        Payload.AddPair('observacao', '');

        Resp := IntegraCteOS.Cria(Payload);
        Resp := UTF8ToString(Resp);

        JSONResp := TJSONObject.ParseJSONValue(Resp) as TJSONObject;
        try
          if Assigned(JSONResp) then
          begin
            ProcessaCteResposta(Resp);
          end
          else
            ShowMessage('Erro ao converter a resposta para JSON');
        finally
          JSONResp.Free;
        end;

      finally
        Payload.Free;
      end;

    finally
      IntegraCteOS.Free;
    end;

  finally
    Params.Free;
  end;
end;

procedure TForm1.ProcessaCteResposta(const RespJSON: string);
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
            ConsultaResp := TJSONObject.ParseJSONValue(IntegraCteOS.Consulta(Payload)) as TJSONObject;
            try
              if Assigned(ConsultaResp) then
              begin
                Codigo := ConsultaResp.GetValue<Integer>('codigo');
                Sucesso := ConsultaResp.GetValue<Boolean>('sucesso');
                if Codigo <> 5023 then
                begin
                  if Sucesso then
                  begin
                    ShowMessage('CT-e autorizado: ' + ConsultaResp.Format);
                  end
                  else
                  begin
                    ShowMessage('CT-e rejeitado: ' + ConsultaResp.Format);
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
          ConsultaResp := TJSONObject.ParseJSONValue(IntegraCteOS.Consulta(Payload)) as TJSONObject;
          try
            if Assigned(ConsultaResp) then
            begin
              Sucesso := ConsultaResp.GetValue<Boolean>('sucesso');
              Codigo := ConsultaResp.GetValue<Integer>('codigo');

              if Sucesso and (Codigo = 5023) then
              begin
                ShowMessage('CT-e autorizado: ' + ConsultaResp.Format);
              end
              else
              begin
                ShowMessage('CT-e rejeitado: ' + ConsultaResp.Format);
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
        ShowMessage('CT-e rejeitado: ' + JSONResp.Format);
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
