unit SDKUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, 
  System.JSON, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, 
  UtilUnit, NfabiUnit;

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
  IntegraNfabi: TIntegraNfabi;

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

    IntegraNfabi := TIntegraNfabi.Create(Params);

    try
      Payload := TJSONObject.ParseJSONValue('{"chave": "41261210944071000104770010000001231012345679", "codigo": "01", "valor_parcela": "10000.00", "valor_total_parcela": "10000.00", "data_pagamento": "2027-01-10", "tributacao": {"cst": "200", "classificacao_tributaria": "200046", "valor_operacao": "10000.00", "base_calculo": "10000.00", "ibs_uf": {"aliquota": "0.1000", "reducao_aliquota": "50.0000", "aliquota_efetiva": "0.0500", "valor": "5.00"}, "ibs_municipal": {"aliquota": "0.0000", "reducao_aliquota": "50.0000", "aliquota_efetiva": "0.0000", "valor": "0.00"}, "cbs": {"aliquota": "0.9000", "reducao_aliquota": "50.0000", "aliquota_efetiva": "0.4500", "valor": "45.00"}}}') as TJSONObject;
      try

        Resp := IntegraNfabi.Parcela(Payload);
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
      IntegraNfabi.Free;
    end;

  finally
    Params.Free;
  end;
end;

end.
