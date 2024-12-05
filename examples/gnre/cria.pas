unit SDKUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.JSON, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  UtilUnit, GnreUnit;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    procedure ProcessaResposta(const Resp: TJSONObject);
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
  IntegraGnre: TIntegraGnre;

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

    IntegraGnre := TIntegraGnre.Create(Params);

    try
      Payload := TJSONObject.Create;
    try
      Payload.AddPair('numero', '6');
      Payload.AddPair('uf_favoverida', 'RO');
      Payload.AddPair('ie_emitente_uf_favorecida', TJSONNull.Create);
      Payload.AddPair('tipo', TJSONNumber.Create(0));
      Payload.AddPair('valor', TJSONNumber.Create(12.55));
      Payload.AddPair('data_pagamento', '2022-05-22');
      Payload.AddPair('identificador_guia', '12345');

    // Adiciona "receitas"
    var ReceitasArray := TJSONArray.Create;
    var Receita := TJSONObject.Create;
    try
      Receita.AddPair('codigo', '100102');
      Receita.AddPair('detalhamento', TJSONNull.Create);
      Receita.AddPair('data_vencimento', '2022-05-22');
      Receita.AddPair('convenio', 'Convênio ICMS 142/18');
      Receita.AddPair('numero_controle', '1');
      Receita.AddPair('numero_controle_fecp', TJSONNull.Create);

      // Adiciona "documento_origem"
      var DocumentoOrigem := TJSONObject.Create;
      try
        DocumentoOrigem.AddPair('numero', '000000001');
        DocumentoOrigem.AddPair('tipo', '10');
        Receita.AddPair('documento_origem', DocumentoOrigem);
      finally
        DocumentoOrigem.Free;
      end;

      Receita.AddPair('produto', TJSONNull.Create);

      // Adiciona "referencia"
      var Referencia := TJSONObject.Create;
      try
        Referencia.AddPair('periodo', '0');
        Referencia.AddPair('mes', '05');
        Referencia.AddPair('ano', '2022');
        Referencia.AddPair('parcela', TJSONNull.Create);
        Receita.AddPair('referencia', Referencia);
      finally
        Referencia.Free;
      end;

      // Adiciona "valores"
      var ValoresArray := TJSONArray.Create;
      var Valor := TJSONObject.Create;
      try
        Valor.AddPair('valor', TJSONNumber.Create(12.55));
        Valor.AddPair('tipo', '11');
        ValoresArray.AddElement(Valor);
      except
        Valor.Free;
        raise;
      end;
      Receita.AddPair('valores', ValoresArray);

      // Adiciona "contribuinte_destinatario"
      var Contribuinte := TJSONObject.Create;
      try
        Contribuinte.AddPair('cnpj', TJSONNull.Create);
        Contribuinte.AddPair('cpf', TJSONNull.Create);
        Contribuinte.AddPair('ie', TJSONNull.Create);
        Contribuinte.AddPair('razao', TJSONNull.Create);
        Contribuinte.AddPair('ibge', TJSONNull.Create);
        Receita.AddPair('contribuinte_destinatario', Contribuinte);
      finally
        Contribuinte.Free;
      end;

      // Adiciona "extras"
      var ExtrasArray := TJSONArray.Create;
      var Extra := TJSONObject.Create;
      try
        Extra.AddPair('codigo', '52');
        Extra.AddPair('conteudo', '32220526434850000191550100000000011015892724');
        ExtrasArray.AddElement(Extra);
      except
        Extra.Free;
        raise;
      end;
      Receita.AddPair('extras', ExtrasArray);

      ReceitasArray.AddElement(Receita);
    except
      Receita.Free;
      raise;
    end;

      Payload.AddPair('receitas', ReceitasArray);
    finally
      Payload.Free;
    end;

    finally
      IntegraGnre.Free;
    end;

  finally
    Params.Free;
  end;
end;

procedure TForm1.ProcessaResposta(const Resp: TJSONObject);
var
  Chave: string;
  Codigo, Tentativa: Integer;
  ConsultaPayload: TJSONObject;
  ConsultaResp: string;
  JSONConsultaResp: TJSONObject;
begin
  if Resp.GetValue('sucesso').AsType<Boolean> then
  begin
    Chave := TIntegraUtil.GetValueFromJson(Resp, 'chave');
    Codigo := Resp.GetValue('codigo').AsType<Integer>;

    if Codigo = 5023 then
    begin
      Sleep(5000);
      Tentativa := 1;

      while Tentativa <= 5 do
      begin
        ConsultaPayload := TJSONObject.Create;
        try
          ConsultaPayload.AddPair('chave', Chave);
          ConsultaResp := IntegraGnre.Consulta(ConsultaPayload);
          JSONConsultaResp := TJSONObject.ParseJSONValue(UTF8ToString(ConsultaResp)) as TJSONObject;

          if Assigned(JSONConsultaResp) then
          try
            Codigo := JSONConsultaResp.GetValue('codigo').AsType<Integer>;
            if Codigo <> 5023 then
            begin
              if JSONConsultaResp.GetValue('sucesso').AsType<Boolean> then
              begin
                ShowMessage('GNRE autorizado: ' + JSONConsultaResp.Format);
                Break;
              end
              else
              begin
                ShowMessage('GNRE rejeitado: ' + JSONConsultaResp.Format);
                Break;
              end;
            end;
          finally
            JSONConsultaResp.Free;
          end;

        finally
          ConsultaPayload.Free;
        end;

        Sleep(5000);
        Inc(Tentativa);
      end;

    end
    else
    begin
      ShowMessage('GNRE autorizado: ' + Resp.Format);
    end;

  end
  else
  begin
    Codigo := Resp.GetValue('codigo').AsType<Integer>;
    if (Codigo = 5001) or (Codigo = 5002) then
    begin
      ShowMessage('Erro nos campos: ' + TIntegraUtil.GetValueFromJson(Resp, 'erros'));
    end
    else if (Codigo = 5008) then
    begin
      Chave := TIntegraUtil.GetValueFromJson(Resp, 'chave');
      ShowMessage('Erro ou timeout. Sincronizando GNRE com chave: ' + Chave);

      ConsultaPayload := TJSONObject.Create;
      try
        ConsultaPayload.AddPair('chave', Chave);
        ConsultaResp := IntegraGnre.Consulta(ConsultaPayload);
        JSONConsultaResp := TJSONObject.ParseJSONValue(UTF8ToString(ConsultaResp)) as TJSONObject;

        if Assigned(JSONConsultaResp) then
        try
          if JSONConsultaResp.GetValue('sucesso').AsType<Boolean> then
            ShowMessage('GNRE autorizado: ' + JSONConsultaResp.Format)
          else
            ShowMessage('GNRE rejeitado: ' + JSONConsultaResp.Format);
        finally
          JSONConsultaResp.Free;
        end;

      finally
        ConsultaPayload.Free;
      end;

    end
    else
    begin
      ShowMessage('GNRE rejeitado: ' + Resp.Format);
    end;
  end;
end;

end.
