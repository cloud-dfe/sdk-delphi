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
  XMLValue: string;
begin
  FToken := 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbXAiOjkyMjUsInVzciI6MzU3LCJ0cCI6MiwiaWF0IjoxNzMxMDgxMjIwfQ.ZaZmqm_fy9UVR_bAHq2Mu5RDBdfdL-_8ynzO4z6QcSU';
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
        Payload.AddPair('chave', '51241117048578000110905800000000061704401284');
        Resp := IntegraNfse.Consulta(Payload);

        Resp := UTF8ToString(Resp);

        JSONResp := TJSONObject.ParseJSONValue(Resp) as TJSONObject;
        try
          if Assigned(JSONResp) then
          begin
            if JSONResp.TryGetValue('xml', XMLValue) then
            begin
              ShowMessage('Conteúdo da chave "xml": ' + XMLValue);
            end
            else
            begin
              ShowMessage('Chave "xml" não encontrada no JSON');
            end;
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
      IntegraNfse.Free;
    end;
  finally
    Params.Free;
  end;
end;

end.