unit SDKUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.JSON, NfseUnit;

type
  TForm1 = class(TForm)
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);  // Botão 1 vai exibir uma mensagem
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);  // Botão 2 mantém a lógica anterior
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
  NFse: TNfse;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  Resp: string;
  Params, Payload: TJSONObject;
begin
  // Lógica do primeiro botão (Consulta)
  FToken := 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbXAiOjE1OTUsInVzciI6MTcwLCJ0cCI6MiwiaWF0IjoxNzE4MjAxOTA5fQ.HkOW2RGdi9vRQhckH_lkmHvw1O75ojnxdJCRcs6X2pY';
  FAmbiente := 2;  // Ambiente de 1- homologação / 2- produção
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

    NFse := TNfse.Create(Params);
    try
      Payload := TJSONObject.Create;
      try
        Payload.AddPair('chave', '50000000000000000000000000000000000000000000');
        Resp := NFse.Consulta(Payload);
        ShowMessage(Resp);
      finally
        Payload.Free;
      end;
    finally
      NFse.Free;
    end;
  finally
    Params.Free;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  Resp: string;
  Params, Payload: TJSONObject;
begin
  // Lógica do segundo botão (Criação de RPS)
  FToken := 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbXAiOjkxOTEsInVzciI6MTAwLCJ0cCI6MiwiaWF0IjoxNzMwOTIyMDI1fQ.hzN0w8R_Qb_nd86SATL6vdFWFHF8EycePJ2Ro4Mhssw';
  FAmbiente := 1;  // Ambiente de 1- homologação / 2- produção
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

    NFse := TNfse.Create(Params);
    try
      Payload := TJSONObject.Create;
      try
        Payload.AddPair('numero', '1');
        Payload.AddPair('serie', '1');
        Payload.AddPair('tipo', '2');
        Payload.AddPair('data_emissao', '2024-11-06T11:07:26-03:00');
        Payload.AddPair('regime_tributacao', '6');
        Payload.AddPair('codigo_lei116', '14.01');
        Payload.AddPair('mei', 'true');
        Payload.AddPair('codigo_aleatorio', '02596491');
        Payload.AddPair('informacoes_complementares', 'Teste de RPS');

        // Dados do tomador
        var Tomador := TJSONObject.Create;
        Tomador.AddPair('cnpj', '44354598000192');
        Tomador.AddPair('razao_social', 'CLOUDDFE SISTEMAS LTDA');
        Tomador.AddPair('email', 'comercial@cloud-dfe.com.br');

        // Endereço do tomador
        var Endereco := TJSONObject.Create;
        Endereco.AddPair('logradouro', 'R MARCELINO SIPRIANO CARDOSO');
        Endereco.AddPair('numero', '104');
        Endereco.AddPair('bairro', 'NOVO MUNDO');
        Endereco.AddPair('codigo_municipio', '4108403');
        Endereco.AddPair('uf', 'PR');
        Endereco.AddPair('cep', '85602803');

        // Adiciona o endereço ao tomador
        Tomador.AddPair('endereco', Endereco);
        Payload.AddPair('tomador', Tomador);

        // Dados do serviço
        var Servico := TJSONObject.Create;
        Servico.AddPair('iss_retido', 'false');
        Servico.AddPair('codigo_municipio', '5105580');

        // Itens do serviço
        var ItensArray := TJSONArray.Create;
        var Item := TJSONObject.Create;
        Item.AddPair('codigo_cnae', '45.2.0-0.01');
        Item.AddPair('discriminacao', 'TESTE DE RPS');
        Item.AddPair('unidade_quantidade', '1');
        Item.AddPair('unidade_valor', '1');
        Item.AddPair('exigibilidade_iss', '1');
        Item.AddPair('valor_servicos', '1');
        Item.AddPair('valor_base_calculo', '1');
        Item.AddPair('valor_aliquota', '2.27');
        Item.AddPair('valor_liquido', '1');
        Item.AddPair('valor_desconto_incondicionado', '0');

        // Adiciona o item ao array de itens
        ItensArray.AddElement(Item);
        Servico.AddPair('itens', ItensArray);

        // Adiciona o serviço ao payload
        Payload.AddPair('servico', Servico);

        Resp := NFse.Cria(Payload);
        ShowMessage(Resp);
      finally
        Payload.Free;
      end;
    finally
      NFse.Free;
    end;
  finally
    Params.Free;
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  Resp: string;
  Params, Payload: TJSONObject;
begin

  FToken := 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbXAiOjE1OTUsInVzciI6MTcwLCJ0cCI6MiwiaWF0IjoxNzE4MjAxOTA5fQ.HkOW2RGdi9vRQhckH_lkmHvw1O75ojnxdJCRcs6X2pY';
  FAmbiente := 2;  // Ambiente de 1- homologação / 1- produção
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

    NFse := TNfse.Create(Params);
    try

      Payload := TJSONObject.Create;
      try

        Payload.AddPair('chave', '50000000000000000000000000000000000000000000');

        Resp := NFse.Consulta(Payload);

        ShowMessage(Resp);
      finally
        Payload.Free;
      end;

    finally
      NFse.Free;
    end;

  finally
    Params.Free;
  end;
end;

end.

