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
  Resp, FileContent, XMLBase64: string;
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

    IntegraNfse := TIntegraNfse.Create(Params);
    try
      Payload := TJSONObject.Create;
      try
        try
          FileContent := TIntegraUtil.ReadFile('caminho_do_arquivo.xml');
          if FileContent.IsEmpty then
            raise Exception.Create('O conteúdo do arquivo está vazio.');

          XMLBase64 := TIntegraUtil.Encode(FileContent);

          Payload.AddPair('chave', '51241117048578000110905800000000061704401284');
          Payload.AddPair('xml', XMLBase64);

          Resp := IntegraNfse.Consulta(Payload);

          ShowMessage('Retorno do JSON: ' + Resp);
        except
          on E: Exception do
            ShowMessage('Erro ao processar: ' + E.Message);
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
