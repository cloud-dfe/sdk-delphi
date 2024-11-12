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
  Params, JSONResp: TJSONObject;
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
      Resp := IntegraNfse.Offline;

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
      IntegraNfse.Free;
    end;
  finally
    Params.Free;
  end;
end;

end.
