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
  Tomador, Endereco, Servico, Itens, Intermediario, Obra: TJSONObject;
begin
  FToken := 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbXAiOjE1OTUsInVzciI6MTcwLCJ0cCI6MiwiaWF0IjoxNzE4MjAxOTA5fQ.HkOW2RGdi9vRQhckH_lkmHvw1O75ojnxdJCRcs6X2pY';
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
        var Item := TJSONObject.Create;
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
        
        Resp := IntegraNfse.Preview(Payload);
        
        ShowMessage(Resp);
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
