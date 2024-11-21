unit SDKUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.JSON, UtilUnit, DfeUnit;

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
  IntegraDfe: TIntegraDfe;

implementation

{$R *.dfm}

procedure TForm1.ButtonDownloadNfseClick(Sender: TObject);
var
  Resp: string;
  JsonResp, DocObj: TJSONObject;
  XMLDecoded: string;
  Payload: TJSONObject;
begin
  FToken := 'TokenDoEmitente';
  FAmbiente := 2; // 1 - Produção, 2 - Homologação
  FTimeout := 60;
  FPort := 443;
  FDebug := False;

  Payload := TJSONObject.Create;
  try
    Payload.AddPair('chave', '50000000000000000000000000000000000000000000');

    Resp := IntegraDfe.DownloadNfse(Payload);
    JsonResp := TJSONObject.ParseJSONValue(Resp) as TJSONObject;

    if Assigned(JsonResp) then
    try
      if TIntegraUtil.GetValueFromJson(JsonResp, 'sucesso') = 'true' then
      begin
        DocObj := JsonResp.GetValue<TJSONObject>('doc');
        if Assigned(DocObj) then
        begin
          XMLDecoded := TIntegraUtil.Decode(TIntegraUtil.GetValueFromJson(DocObj, 'xml'));

          ShowMessage('XML Decodificado: ' + XMLDecoded);
        end
        else
          ShowMessage('Erro: Objeto "doc" não encontrado na resposta.');
      end
      else
        ShowMessage('Erro: ' + TIntegraUtil.GetValueFromJson(JsonResp, 'mensagem'));

    finally
      JsonResp.Free;
    end;

  finally
    Payload.Free;
  end;
end;

end.
