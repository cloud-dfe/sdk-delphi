unit SDKUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.JSON, NfceUnit;

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
  NFce: TNfce;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  Resp: string;
  Params, Payload: TJSONObject;
begin
  // Par�metros para o ambiente de consulta
  FToken := 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbXAiOjE1OTUsInVzciI6MTcwLCJ0cCI6MiwiaWF0IjoxNzE4MjAxOTA5fQ.HkOW2RGdi9vRQhckH_lkmHvw1O75ojnxdJCRcs6X2pY';
  FAmbiente := 2;  // 1 para produ��o e 2 para homologa��o
  FTimeout := 60;
  FPort := 443;
  FDebug := False;

  // Cria��o do JSON de par�metros para a consulta
  Params := TJSONObject.Create;
  try
    Params.AddPair('token', FToken);
    Params.AddPair('ambiente', TJSONNumber.Create(FAmbiente));
    Params.AddPair('timeout', TJSONNumber.Create(FTimeout));
    Params.AddPair('port', TJSONNumber.Create(FPort));
    Params.AddPair('debug', TJSONBool.Create(FDebug));

    // Instancia o objeto NFSe com os par�metros
    NFce := TNfce.Create(Params);
    try
      Payload := TJSONObject.Create;
      try
        Payload.AddPair('chave', '50000000000000000000000000000000000000000000');
        Resp := NFce.Consulta(Payload);
        ShowMessage(Resp);
      finally
        Payload.Free;
      end;
    finally
      NFce.Free;
    end;
  finally
    Params.Free;
  end;
end;

end.

