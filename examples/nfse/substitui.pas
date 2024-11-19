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
  Params, Payload: TJSONObject;
  JSONResp: TJSONObject;
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

    IntegraNfse := TIntegraNfse.Create(Params);
    try
      Payload := TJSONObject.Create;
      try

        Payload.AddPair('chave', '50000000000000000000000000000000000000000000');
        Payload.AddPair('codigo_cancelamento', '2');
        Payload.AddPair('motivo_cancelamento', 'nota emitida com valor errado');
        Payload.AddPair('numero', '1');
        Payload.AddPair('serie', '0');
        Payload.AddPair('tipo', '1');
        Payload.AddPair('status', '1');
        Payload.AddPair('data_emissao', '2017-12-27T17:43:14-03:00');

        var Tomador := TJSONObject.Create;
        try
          Tomador.AddPair('cnpj', '12345678901234');
          Tomador.AddPair('cpf', TJSONNull.Create);
          Tomador.AddPair('im', TJSONNull.Create);
          Tomador.AddPair('razao_social', 'Fake Tecnologia Ltda');

          var Endereco := TJSONObject.Create;
          try
            Endereco.AddPair('logradouro', 'Rua New Horizon');
            Endereco.AddPair('numero', '16');
            Endereco.AddPair('complemento', TJSONNull.Create);
            Endereco.AddPair('bairro', 'Jardim America');
            Endereco.AddPair('codigo_municipio', '4119905');
            Endereco.AddPair('uf', 'PR');
            Endereco.AddPair('cep', '81530945');
            Tomador.AddPair('endereco', Endereco);
          except
            Endereco.Free;
            raise;
          end;

          Payload.AddPair('tomador', Tomador);
        except
          Tomador.Free;
          raise;
        end;

        var Servico := TJSONObject.Create;
        try
          Servico.AddPair('codigo_tributacao_municipio', '10500');
          Servico.AddPair('discriminacao', 'Exemplo Serviço');
          Servico.AddPair('codigo_municipio', '4119905');
          Servico.AddPair('valor_servicos', '1.00');
          Servico.AddPair('valor_pis', '1.00');
          Servico.AddPair('valor_cofins', '1.00');
          Servico.AddPair('valor_inss', '1.00');
          Servico.AddPair('valor_ir', '1.00');
          Servico.AddPair('valor_csll', '1.00');
          Servico.AddPair('valor_outras', '1.00');
          Servico.AddPair('valor_aliquota', '1.00');
          Servico.AddPair('valor_desconto_incondicionado', '1.00');
          Payload.AddPair('servico', Servico);
        except
          Servico.Free;
          raise;
        end;

        var Intermediario := TJSONObject.Create;
        try
          Intermediario.AddPair('cnpj', '12345678901234');
          Intermediario.AddPair('cpf', TJSONNull.Create);
          Intermediario.AddPair('im', TJSONNull.Create);
          Intermediario.AddPair('razao_social', 'Fake Tecnologia Ltda');
          Payload.AddPair('intermediario', Intermediario);
        except
          Intermediario.Free;
          raise;
        end;

        var Obra := TJSONObject.Create;
        try
          Obra.AddPair('codigo', '2222');
          Obra.AddPair('art', '1111');
          Payload.AddPair('obra', Obra);
        except
          Obra.Free;
          raise;
        end;

        Resp := IntegraNfse.Substitui(Payload);

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
      IntegraNfse.Free;
    end;
  finally
    Params.Free;
  end;
end;

end.
