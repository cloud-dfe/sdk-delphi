unit SDKUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, 
  System.JSON, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, 
  UtilUnit, SofthouseUnit;

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
  IntegraSofthouse: TIntegraSofthouse;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  Resp: string;
  Params, Payload, Documentos, JSONResp: TJSONObject;
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

    IntegraSofthouse := TIntegraSofthouse.Create(Params);

    try
      Payload := TJSONObject.Create;
      Documentos := TJSONObject.Create;
      try
        Payload.AddPair('nome', 'EMPRESA TESTE');
        Payload.AddPair('razao', 'EMPRESA TESTE');
        Payload.AddPair('cnpj', '47853098000193');
        Payload.AddPair('cpf', '12345678901');
        Payload.AddPair('cnae', '12369875');
        Payload.AddPair('crt', '1');
        Payload.AddPair('ie', '12369875');
        Payload.AddPair('im', '12369875');
        Payload.AddPair('suframa', '12369875');
        Payload.AddPair('csc', '...');
        Payload.AddPair('cscid', '000001');
        Payload.AddPair('tar', 'C92920029-12');
        Payload.AddPair('login_prefeitura', TJSONNull.Create);
        Payload.AddPair('senha_prefeitura', TJSONNull.Create);
        Payload.AddPair('client_id_prefeitura', TJSONNull.Create);
        Payload.AddPair('client_secret_prefeitura', TJSONNull.Create);
        Payload.AddPair('telefone', '46998895532');
        Payload.AddPair('email', 'empresa@teste.com');
        Payload.AddPair('rua', 'TESTE');
        Payload.AddPair('numero', '1');
        Payload.AddPair('complemento', 'NENHUM');
        Payload.AddPair('bairro', 'TESTE');
        Payload.AddPair('municipio', 'CIDADE TESTE');
        Payload.AddPair('cmun', '5300108');
        Payload.AddPair('uf', 'PR');
        Payload.AddPair('cep', '85000100');
        Payload.AddPair('logo', 'useyn56j4mx35m5j6_JSHh734khjd...saasjda');
        Payload.AddPair('plano', 'Emitente');

        Documentos.AddPair('nfe', TJSONBool.Create(True));
        Documentos.AddPair('nfce', TJSONBool.Create(True));
        Documentos.AddPair('nfse', TJSONBool.Create(True));
        Documentos.AddPair('mdfe', TJSONBool.Create(True));
        Documentos.AddPair('cte', TJSONBool.Create(True));
        Documentos.AddPair('cteos', TJSONBool.Create(True));
        Documentos.AddPair('bpe', TJSONBool.Create(True));
        Documentos.AddPair('dfe_nfe', TJSONBool.Create(True));
        Documentos.AddPair('dfe_cte', TJSONBool.Create(True));
        Documentos.AddPair('sintegra', TJSONBool.Create(True));
        Documentos.AddPair('gnre', TJSONBool.Create(True));
        Payload.AddPair('documentos', Documentos);

        Resp := IntegraSofthouse.AtualizaEmitente(Payload);
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
        Documentos.Free;
      end;

    finally
      IntegraSofthouse.Free;
    end;

  finally
    Params.Free;
  end;
end;

end.
