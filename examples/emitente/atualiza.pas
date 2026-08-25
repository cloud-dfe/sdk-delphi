unit SDKUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.JSON,
  UtilUnit, EmitenteUnit;

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
  IntegraEmitente: TIntegraEmitente;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  Payload, Params: TJSONObject;
  Resp: string;
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

    IntegraEmitente := TIntegraEmitente.Create(Params);
    try
      Payload := TJSONObject.Create;
      try
        Payload.AddPair('nome', 'EMPRESA TESTE2');
        Payload.AddPair('razao', 'EMPRESA TESTE2');
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
        Payload.AddPair('logo', 'base64string');

        Resp := IntegraEmitente.Atualiza(Payload);

        JSONResp := TJSONObject.ParseJSONValue(Resp) as TJSONObject;
        try
          if Assigned(JSONResp) then
            ShowMessage(JSONResp.Format)
          else
            ShowMessage('Resposta: ' + Resp);
        finally
          JSONResp.Free;
        end;
      finally
        Payload.Free;
      end;
    finally
      IntegraEmitente.Free;
    end;
  finally
    Params.Free;
  end;
end;

end.
