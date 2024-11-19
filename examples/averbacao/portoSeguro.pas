unit SDKUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, UtilUnit, AverbacaoUnit;

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
    IntegraAverbacao: TIntegraAverbacao;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
    Resp, XMLBase64: string;
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

        IntegraAverbacao := TIntegraAverbacao.Create(Params);

            try
                XMLBase64 := TIntegraUtil.ReadFile('caminho_do_arquivo.xml');
                XMLBase64 := TIntegraUtil.Encode(XMLBase64);
            except
                on E: Exception do
                    ShowMessage('Erro ao ler o arquivo: ' + E.Message);
            end;
        end;

        try
            Payload := TJSONObject.Create;
            try
                Payload.AddPair('xml', XMLBase64);
                Payload.AddPair('login', 'login');
                Payload.AddPair('senha', 'senha');
                Payload.AddPair('chave', '50000000000000000000000000000000000000000000')

                Resp := IntegraAverbacao.PortoSeguro(Payload);
                Resp := UTF8ToString(Resp);

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
            IntegraAverbacao.Free;
        end;
    finally
        Params.Free;
    end;
end;

end.
