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
  Contratante, Contratado, Destinatario, Motorista, ItemVeiculos, Carga, ItemViagens, Origem, Destino, ItemPagamentos: TJSONObject;
  Veiculos, Viagens, Pagamentos: TJSONArray;
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
        Payload.AddPair('identificacao', 'VIAGEM-0001');
        Payload.AddPair('tipo_operacao', '1');
        Payload.AddPair('data_inicio', '2026-11-10');
        Payload.AddPair('data_fim', '2026-11-12');
        Payload.AddPair('valor_frete', '4550.92');
        Contratante := TJSONObject.Create;
        Contratante.AddPair('cnpj', '11222333000181');
        Contratante.AddPair('nome', 'TRANSPORTADORA EXEMPLO LTDA');
        Contratante.AddPair('rntrc', '12345678');
        Payload.AddPair('contratante', Contratante);
        Contratado := TJSONObject.Create;
        Contratado.AddPair('cnpj', '22333444000181');
        Contratado.AddPair('nome', 'TRANSPORTADOR CONTRATADO LTDA');
        Contratado.AddPair('rntrc', '87654321');
        Payload.AddPair('contratado', Contratado);
        Destinatario := TJSONObject.Create;
        Destinatario.AddPair('cnpj', '44555666000199');
        Destinatario.AddPair('nome', 'DESTINATARIO EXEMPLO LTDA');
        Payload.AddPair('destinatario', Destinatario);
        Motorista := TJSONObject.Create;
        Motorista.AddPair('cpf', '12345678909');
        Motorista.AddPair('nome', 'MOTORISTA EXEMPLO');
        Payload.AddPair('motorista', Motorista);
        Veiculos := TJSONArray.Create;
        ItemVeiculos := TJSONObject.Create;
        ItemVeiculos.AddPair('placa', 'BCD2E34');
        ItemVeiculos.AddPair('eixos', '2');
        ItemVeiculos.AddPair('rntrc', '87654321');
        Veiculos.AddElement(ItemVeiculos);
        Payload.AddPair('veiculos', Veiculos);
        Carga := TJSONObject.Create;
        Carga.AddPair('tipo', '05');
        Carga.AddPair('natureza', '8414');
        Carga.AddPair('peso', '1520');
        Payload.AddPair('carga', Carga);
        Viagens := TJSONArray.Create;
        ItemViagens := TJSONObject.Create;
        ItemViagens.AddPair('quantidade', '1');
        ItemViagens.AddPair('distancia', '560');
        Origem := TJSONObject.Create;
        Origem.AddPair('cep', '85000000');
        Origem.AddPair('codigo_municipio', '4121604');
        Origem.AddPair('municipio', 'Renascença');
        Origem.AddPair('uf', 'PR');
        ItemViagens.AddPair('origem', Origem);
        Destino := TJSONObject.Create;
        Destino.AddPair('cep', '88300000');
        Destino.AddPair('codigo_municipio', '4208203');
        Destino.AddPair('municipio', 'Itajaí');
        Destino.AddPair('uf', 'SC');
        ItemViagens.AddPair('destino', Destino);
        Viagens.AddElement(ItemViagens);
        Payload.AddPair('viagens', Viagens);
        Pagamentos := TJSONArray.Create;
        ItemPagamentos := TJSONObject.Create;
        ItemPagamentos.AddPair('forma', '1');
        ItemPagamentos.AddPair('tipo', '5');
        ItemPagamentos.AddPair('cnpj', '22333444000181');
        ItemPagamentos.AddPair('chave_pix', '22333444000181');
        ItemPagamentos.AddPair('vencimento', '2026-11-12');
        ItemPagamentos.AddPair('valor', '4550.92');
        Pagamentos.AddElement(ItemPagamentos);
        Payload.AddPair('pagamentos', Pagamentos);

        Resp := IntegraCiot.Cria(Payload);
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
