unit SDKUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, UtilUnit, CertificadoUnit;

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
    IntegraCertificado: TIntegraCertificado;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
    Resp, PFXBase64: string;
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

end.
