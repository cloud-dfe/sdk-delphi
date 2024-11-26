unit SDKUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.JSON,
  NfeUnit;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
  public
  end;

var
  Form1: TForm1;
  FToken: string;
  FAmbiente: Integer;
  FTimeout: Integer;
  FPort: Integer;
  FDebug: Boolean;
  IntegraNfe: TIntegraNfe;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  Resp: string;
  Params, Payload: TJSONObject;
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

    IntegraNfe := TIntegraNfe.Create(Params);

    try
      Payload := TJSONObject.Create;
      try
        Payload.AddPair('numero_inicial', TJSONNumber.Create(1710));
        Payload.AddPair('numero_final', TJSONNumber.Create(101002));
        Payload.AddPair('serie', TJSONNumber.Create(1));
        Payload.AddPair('data_inicial', '2021-04-01');
        Payload.AddPair('data_final', '2021-04-31');
        Payload.AddPair('cancel_inicial', '2019-12-01');
        Payload.AddPair('cancel_final', '2019-12-31');

        Resp := IntegraNfe.Busca(Payload);
        Resp := UTF8ToString(Resp);

        ShowMessage('Resposta da Busca: ' + Resp);

      finally
        Payload.Free;
      end;

    finally
      IntegraNfe.Free;
    end;

  finally
    Params.Free;
  end;
end;

end.
