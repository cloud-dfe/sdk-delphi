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
  Params, Payload, JSONResp: TJSONObject;
  DocsArray, EventosArray: TJSONArray;
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

        Resp := IntegraDfe.BuscaCte(Payload);
        Resp := UTF8ToString(Resp);

        JSONResp := TJSONObject.ParseJSONValue(Resp) as TJSONObject;
        try
          if Assigned(JSONResp) then
          begin
            if TIntegraUtil.GetValueFromJson(JSONResp, 'sucesso') = 'true' then
            begin
              DocsArray := JSONResp.GetValue<TJSONArray>('docs');
              if Assigned(DocsArray) then
                for I := 0 to DocsArray.Count - 1 do
                begin
                  ShowMessage('Chave do Documento: ' +
                    TIntegraUtil.GetValueFromJson(DocsArray.Items[I] as TJSONObject, 'chave'));
                end;

              EventosArray := JSONResp.GetValue<TJSONArray>('eventos_proprios');
              if Assigned(EventosArray) then
                for I := 0 to EventosArray.Count - 1 do
                begin
                  ShowMessage('Chave do Evento: ' +
                    TIntegraUtil.GetValueFromJson(EventosArray.Items[I] as TJSONObject, 'chave'));
                end;
            end
            else
              ShowMessage('Operação não foi bem-sucedida.');
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
      IntegraDfe.Free;
    end;

  finally
    Params.Free;
  end;
end;


end.
