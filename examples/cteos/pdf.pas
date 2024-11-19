unit SDKUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, UtilUnit, CteOSUnit, System.JSON;

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
  IntegraCteOS: TIntegraCteOS;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  Resp: string;
  Params, Payload, JSONResp: TJSONObject;
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

    IntegraCteOS := TIntegraCteOS.Create(Params);

    try
      Payload := TJSONObject.Create;
      try
        Payload.AddPair('chave', '50000000000000000000000000000000000000000000');

        Resp := IntegraCteOS.Pdf(Payload);
        Resp := UTF8ToString(Resp);

        if Resp <> '' then
          ShowMessage('PDF gerado com sucesso. Conteúdo do PDF: ' + Resp)
        else
          ShowMessage('Erro ao gerar o PDF');

      finally
        Payload.Free;
      end;

    finally
      IntegraCteOS.Free;
    end;

  finally
    Params.Free;
  end;
end;

end.
