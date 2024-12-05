unit SDKUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.JSON, NfseUnit;

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
  IntegraNfse: TIntegraNfse;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  Resp: string;
  Params, Payload, Tomador, Endereco, Servico, Intermediario, Obra: TJSONObject;
  JSONResp: TJSONObject;
  Itens: TJSONArray;
  Item: TJSONObject;
begin
  FToken := 'TokenDoEmitente';
  FAmbiente := 2;
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

    IntegraNfse := TIntegraNfse.Create(Params);
    try
      Payload := TJSONObject.Create;
      try
        Payload.AddPair('numero', '1');
        Payload.AddPair('serie', '0');
        Payload.AddPair('tipo', '1');
        Payload.AddPair('status', '1');
        Payload.AddPair('data_emissao', '2017-12-27T17:43:14-03:00');
        
        Tomador := TJSONObject.Create;
        Tomador.AddPair('cnpj', '12345678901234');
        Tomador.AddPair('cpf', TJSONNull.Create);
        Tomador.AddPair('im', TJSONNull.Create);
        Tomador.AddPair('razao_social', 'Fake Tecnologia Ltda');
        
        Endereco := TJSONObject.Create;
        Endereco.AddPair('logradouro', 'Rua New Horizon');
        Endereco.AddPair('numero', '16');
        Endereco.AddPair('complemento', TJSONNull.Create);
        Endereco.AddPair('bairro', 'Jardim America');
        Endereco.AddPair('codigo_municipio', '4119905');
        Endereco.AddPair('uf', 'PR');
        Endereco.AddPair('cep', '81530945');
        
        Tomador.AddPair('endereco', Endereco);
        Payload.AddPair('tomador', Tomador);
        
        Servico := TJSONObject.Create;
        Servico.AddPair('codigo_municipio', '4119905');
        
        Itens := TJSONArray.Create;
        Item := TJSONObject.Create;
        Item.AddPair('codigo_tributacao_municipio', '10500');
        Item.AddPair('discriminacao', 'Exemplo Serviço');
        Item.AddPair('valor_servicos', '1.00');
        Item.AddPair('valor_pis', '1.00');
        Item.AddPair('valor_cofins', '1.00');
        Item.AddPair('valor_inss', '1.00');
        Item.AddPair('valor_ir', '1.00');
        Item.AddPair('valor_csll', '1.00');
        Item.AddPair('valor_outras', '1.00');
        Item.AddPair('valor_aliquota', '1.00');
        Item.AddPair('valor_desconto_incondicionado', '1.00');
        Itens.Add(Item);
        
        Servico.AddPair('itens', Itens);
        Payload.AddPair('servico', Servico);
        
        Intermediario := TJSONObject.Create;
        Intermediario.AddPair('cnpj', '12345678901234');
        Intermediario.AddPair('cpf', TJSONNull.Create);
        Intermediario.AddPair('im', TJSONNull.Create);
        Intermediario.AddPair('razao_social', 'Fake Tecnologia Ltda');
        Payload.AddPair('intermediario', Intermediario);
        
        Obra := TJSONObject.Create;
        Obra.AddPair('codigo', '2222');
        Obra.AddPair('art', '1111');
        Payload.AddPair('obra', Obra);
        
        Resp := IntegraNfse.Cria(Payload);
        Resp := UTF8ToString(Resp);

        ProcessaNfseResposta(Resp)        
        
      finally
        Payload.Free;
      end;
    finally
      IntegraNfse.Free;
    end;
  finally
    Params.Free;
  end;
end;

procedure TForm1.ProcessaNfseResposta(const RespJSON: string); 
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
            ConsultaResp := TJSONObject.ParseJSONValue(IntegraNfse.Consulta(Payload)) as TJSONObject; 
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
      else if (Codigo = 5008) then
      begin
        Chave := JSONResp.GetValue<string>('chave');
        ShowMessage('Erro de timeout ou conexão. Sincronizando documento.');

        Payload := TJSONObject.Create;
        try
          Payload.AddPair('chave', Chave);
          ConsultaResp := TJSONObject.ParseJSONValue(IntegraNfse.Consulta(Payload)) as TJSONObject; 
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
