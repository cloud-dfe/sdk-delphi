unit SDKUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, 
  System.JSON, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, 
  UtilUnit, VpoUnit;

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
  IntegraVpo: TIntegraVpo;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  Resp: string;
  Params, Payload, JSONResp: TJSONObject;
  Rota, Veiculo, Transportador: TJSONObject;
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

    IntegraVpo := TIntegraVpo.Create(Params);

    try
      Payload := TJSONObject.Create;
      try
        Payload.AddPair('numero', '1001');
        Payload.AddPair('identificacao', 'VIAGEM-77');
        Payload.AddPair('emissor', 'SEMPARAR');
        Payload.AddPair('data_inicio', '2026-11-10 08:00:00');
        Payload.AddPair('data_fim', '2026-11-12 18:00:00');
        Rota := TJSONObject.Create;
        Rota.AddPair('id', '58222');
        Rota.AddPair('indice', '0');
        Rota.AddPair('distancia_km', '45.279');
        Rota.AddPair('tipo_combustivel', 'DIESEL');
        Payload.AddPair('rota', Rota);
        Veiculo := TJSONObject.Create;
        Veiculo.AddPair('placa', 'BCD2E34');
        Veiculo.AddPair('categoria', '7');
        Payload.AddPair('veiculo', Veiculo);
        Transportador := TJSONObject.Create;
        Transportador.AddPair('cnpj', '22333444000181');
        Transportador.AddPair('rntrc', '87654321');
        Transportador.AddPair('nome', 'TRANSPORTADOR EXEMPLO LTDA');
        Payload.AddPair('transportador', Transportador);
        Payload.AddPair('cte', '1234');

        Resp := IntegraVpo.Cria(Payload);
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
      IntegraVpo.Free;
    end;

  finally
    Params.Free;
  end;
end;

end.
