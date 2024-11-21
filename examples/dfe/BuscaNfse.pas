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

procedure TForm1.Button1Click(Sender: TObject);
var
  Resp: string;
  JsonResp, DocItem: TJSONObject;
  DocsArray: TJSONArray;
  Chave: string;
  Params, Payload: TJSONObject;
  I: Integer;
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

    IntegraDfe := TIntegraDfe.Create(Params);

    try
      Payload := TJSONObject.Create;
      try
        Payload.AddPair('periodo', '2020-10');
        Payload.AddPair('data', '2020-10-15');
        Payload.AddPair('cnpj', '06338788000127');

        Resp := IntegraDfe.BuscaNfse(Payload);
        JsonResp := TJSONObject.ParseJSONValue(Resp) as TJSONObject;

        if Assigned(JsonResp) then
        try
          if TIntegraUtil.GetValueFromJson(JsonResp, 'sucesso') = 'true' then
          begin
            DocsArray := JsonResp.GetValue<TJSONArray>('docs');
            if Assigned(DocsArray) then
              for I := 0 to DocsArray.Count - 1 do
              begin
                DocItem := DocsArray.Items[I] as TJSONObject;
                Chave := TIntegraUtil.GetValueFromJson(DocItem, 'chave');
                ShowMessage('Documento chave: ' + Chave);
              end;
          end
          else
            ShowMessage('Erro: ' + TIntegraUtil.GetValueFromJson(JsonResp, 'mensagem'));

        finally
          JsonResp.Free;
        end;

      finally
        Payload.Free;
      end;

    finally
      IntegraDfe.Free;
    end;

  finally
    Params.Free;
  end;
end;

end.
