unit SDKUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, 
  System.JSON, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, 
  UtilUnit, CiotUnit;

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
  IntegraCiot: TIntegraCiot;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  Resp: string;
  Params, Payload, JSONResp: TJSONObject;
  ItemPagamentos: TJSONObject;
  Pagamentos: TJSONArray;
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

    IntegraCiot := TIntegraCiot.Create(Params);

    try
      Payload := TJSONObject.Create;
      try
        Payload.AddPair('chave', '41261122333444000181927090000010011360347860');
        Payload.AddPair('data_fim', '2026-11-13');
        Payload.AddPair('valor_frete', '4800.00');
        Pagamentos := TJSONArray.Create;
        ItemPagamentos := TJSONObject.Create;
        ItemPagamentos.AddPair('forma', '1');
        ItemPagamentos.AddPair('tipo', '5');
        ItemPagamentos.AddPair('cnpj', '22333444000181');
        ItemPagamentos.AddPair('chave_pix', '22333444000181');
        ItemPagamentos.AddPair('vencimento', '2026-11-13');
        ItemPagamentos.AddPair('valor', '4800.00');
        Pagamentos.AddElement(ItemPagamentos);
        Payload.AddPair('pagamentos', Pagamentos);

        Resp := IntegraCiot.Retifica(Payload);
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
        Payload.Free;
      end;

    finally
      IntegraCiot.Free;
    end;

  finally
    Params.Free;
  end;
end;

end.
