unit SDKUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.JSON, NfseUnit, UtilUnit;

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
  PDFBase64: string;
  PDFFileName: string;
begin
  // Exemplo de token e configurações
  FToken := 'TokenDoEmitente';
  FAmbiente := 1;
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
        Payload.AddPair('chave', 'Chave');
        Resp := IntegraNfse.Consulta(Payload);

        Resp := UTF8ToString(Resp);

        JSONResp := TJSONObject.ParseJSONValue(Resp) as TJSONObject;
        try
          if Assigned(JSONResp) then
          begin
            // Obtém o valor do PDF base64 da resposta JSON
            PDFBase64 := TIntegraUtil.GetValueFromJson(JSONResp, 'pdf');
            if PDFBase64 <> '' then
            begin
              // Decodifica e salva o PDF
              PDFFileName := 'Diretorio a ser salvo'; // Defina o caminho desejado
              TIntegraUtil.DecodeToPDF(PDFBase64, PDFFileName);
              ShowMessage('PDF salvo com sucesso em: ' + PDFFileName);
            end
            else
            begin
              ShowMessage('Chave "pdf" não encontrada ou vazia');
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
