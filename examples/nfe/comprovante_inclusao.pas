unit SDKUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.JSON,
  NfeUnit;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
  public
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
  Params, Payload, Registra, Coordenadas: TJSONObject;
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

    IntegraNfe := TIntegraNfe.Create(Params);

    try
      Payload := TJSONObject.Create;
      try
        Payload.AddPair('chave', '123456789012345678901234567890123456789012345678901234');

        Registra := TJSONObject.Create;
        try
          Registra.AddPair('data', '2021-10-12T12:22:33-03:00');
          Registra.AddPair('imagem', 'lUHJvYyB2ZXJzYW....');
          Registra.AddPair('recebedor_documento', '123456789 SSPRJ');
          Registra.AddPair('recebedor_nome', 'NOME TESTE');

          Coordenadas := TJSONObject.Create;
          try
            Coordenadas.AddPair('latitude', TJSONNumber.Create(-23.628360));
            Coordenadas.AddPair('longitude', TJSONNumber.Create(-46.622109));
            Registra.AddPair('coordenadas', Coordenadas);
          except
            Coordenadas.Free;
          end;

          Payload.AddPair('registra', Registra);

          Resp := IntegraNfe.Comprovante(Payload);
          Resp := UTF8ToString(Resp);

          ShowMessage('Resposta da Inclusão do Comprovante: ' + Resp);

        finally
          Registra.Free;
        end;

      finally
        Payload.Free;
      end;

    finally
      IntegraNfe.Free;
    end;

  finally
    Params.Free;
  end;
end;

end.
