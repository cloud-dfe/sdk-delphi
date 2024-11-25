unit SDKUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, 
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.JSON,
  UtilUnit, MdfeUnit;

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
  IntegraMdfe: TIntegraMdfe;

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

    IntegraMdfe := TIntegraMdfe.Create(Params);
    try
      Payload := TJSONObject.Create;
      try
        Payload.AddPair('tipo_operacao', '2');
        Payload.AddPair('tipo_transporte', TJSONNull.Create);
        Payload.AddPair('numero', '27');
        Payload.AddPair('serie', '1');
        Payload.AddPair('data_emissao', '2021-06-26T09:21:42-00:00');
        Payload.AddPair('uf_inicio', 'RN');
        Payload.AddPair('uf_fim', 'GO');

        // Municipios Carregamento
        var MunicipiosCarregamento := TJSONArray.Create;
        var Municipio := TJSONObject.Create;
        Municipio.AddPair('codigo_municipio', '2408003');
        Municipio.AddPair('nome_municipio', 'Mossoró');
        MunicipiosCarregamento.Add(Municipio);
        Payload.AddPair('municipios_carregamento', MunicipiosCarregamento);

        // Percursos
        var Percursos := TJSONArray.Create;
        var Percurso1 := TJSONObject.Create;
        Percurso1.AddPair('uf', 'PB');
        Percursos.Add(Percurso1);
        var Percurso2 := TJSONObject.Create;
        Percurso2.AddPair('uf', 'PE');
        Percursos.Add(Percurso2);
        var Percurso3 := TJSONObject.Create;
        Percurso3.AddPair('uf', 'BA');
        Percursos.Add(Percurso3);
        Payload.AddPair('percursos', Percursos);

        // Municipios Descarregamento
        var MunicipiosDescarregamento := TJSONArray.Create;
        var MunicipioDescarregamento := TJSONObject.Create;
        MunicipioDescarregamento.AddPair('codigo_municipio', '5200050');
        MunicipioDescarregamento.AddPair('nome_municipio', 'Abadia de Goiás');
        
        // Nfes
        var Nfes := TJSONArray.Create;
        var Nfe := TJSONObject.Create;
        Nfe.AddPair('chave', '50000000000000000000000000000000000000000000');
        Nfes.Add(Nfe);
        MunicipioDescarregamento.AddPair('nfes', Nfes);
        
        MunicipiosDescarregamento.Add(MunicipioDescarregamento);
        Payload.AddPair('municipios_descarregamento', MunicipiosDescarregamento);

        // Valores
        var Valores := TJSONObject.Create;
        Valores.AddPair('valor_total_carga', '100.00');
        Valores.AddPair('codigo_unidade_medida_peso_bruto', '01');
        Valores.AddPair('peso_bruto', '1000.000');
        Payload.AddPair('valores', Valores);

        Payload.AddPair('informacao_adicional_fisco', TJSONNull.Create);
        Payload.AddPair('informacao_complementar', TJSONNull.Create);

        // Modal Rodoviário
        var ModalRodoviario := TJSONObject.Create;
        ModalRodoviario.AddPair('rntrc', '57838055');
        ModalRodoviario.AddPair('ciot', TJSONArray.Create);
        ModalRodoviario.AddPair('contratante', TJSONArray.Create);
        ModalRodoviario.AddPair('vale_pedagio', TJSONArray.Create);
        
        // Veículo
        var Veiculo := TJSONObject.Create;
        Veiculo.AddPair('codigo', '000000001');
        Veiculo.AddPair('placa', 'FFF1257');
        Veiculo.AddPair('renavam', '335540391');
        Veiculo.AddPair('tara', '0');
        Veiculo.AddPair('tipo_rodado', '01');
        Veiculo.AddPair('tipo_carroceria', '00');
        Veiculo.AddPair('uf', 'MT');

        // Condutores
        var Condutores := TJSONArray.Create;
        var Condutor := TJSONObject.Create;
        Condutor.AddPair('nome', 'JOAO TESTE');
        Condutor.AddPair('cpf', '01234567890');
        Condutores.Add(Condutor);

        Veiculo.AddPair('condutores', Condutores);
        ModalRodoviario.AddPair('veiculo', Veiculo);

        ModalRodoviario.AddPair('reboques', TJSONArray.Create);
        Payload.AddPair('modal_rodoviario', ModalRodoviario);

        Resp := IntegraMdfe.Preview(Payload);
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
      IntegraMdfe.Free;
    end;

  finally
    Params.Free;
  end;
end;

end.
