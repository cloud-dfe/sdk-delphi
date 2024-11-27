unit SDKUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.JSON,
  UtilUnit, NfeUnit;

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
  IntegraNfe: TIntegraNfe;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  Resp: string;
  Payload: TJSONObject;
  JSONResp: TJSONObject;
begin
  FToken := 'TokenDoEmitente';
  FAmbiente := 2; // 1 - Produção, 2 - Homologação
  FTimeout := 60;
  FPort := 443;
  FDebug := False;

  IntegraNfe := TIntegraNfe.Create;

  try
    Payload := TJSONObject.Create;
    try
      Payload.AddPair('chave', '123456789012345678901234567890123456789012345678901234'); // Chave de acesso obrigatória
      Payload.AddPair('registra', TJSONObject.Create
        .AddPair('data', '2021-10-12T12:22:33-03:00') // Data e hora obrigatória do recebimento
        .AddPair('imagem', 'lUHJvYyB2ZXJzYW....') // Base64 opcional para a imagem
        .AddPair('recebedor_documento', '123456789 SSPRJ') // Documento de identificação do recebedor
        .AddPair('recebedor_nome', 'NOME TESTE') // Nome do recebedor
        .AddPair('coordenadas', TJSONObject.Create
          .AddPair('latitude', -23.628360)
          .AddPair('longitude', -46.622109)
        )
      );

      Resp := IntegraNfe.Comprovante(Payload);
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
    IntegraNfe.Free;
  end;
end;

end.
