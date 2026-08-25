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
    procedure ProcessaResposta(const RespJSON: string);
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
  Params, Payload: TJSONObject;
  ReceitasArray, ValoresArray, ExtrasArray: TJSONArray;
  Receita, DocumentoOrigem, Referencia, Valor, Contribuinte, Extra: TJSONObject;
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

        ReceitasArray := TJSONArray.Create;
        Receita := TJSONObject.Create;
        Receita.AddPair('codigo', '100102');
        Receita.AddPair('detalhamento', TJSONNull.Create);
        Receita.AddPair('data_vencimento', '2022-05-22');
        Receita.AddPair('convenio', 'Convênio ICMS 142/18');
        Receita.AddPair('numero_controle', '1');
        Receita.AddPair('numero_controle_fecp', TJSONNull.Create);

        DocumentoOrigem := TJSONObject.Create;
        DocumentoOrigem.AddPair('numero', '000000001');
        DocumentoOrigem.AddPair('tipo', '10');
        Receita.AddPair('documento_origem', DocumentoOrigem);

        Receita.AddPair('produto', TJSONNull.Create);

        Referencia := TJSONObject.Create;
        Referencia.AddPair('periodo', '0');
        Referencia.AddPair('mes', '05');
        Referencia.AddPair('ano', '2022');
        Referencia.AddPair('parcela', TJSONNull.Create);
        Receita.AddPair('referencia', Referencia);

        ValoresArray := TJSONArray.Create;
        Valor := TJSONObject.Create;
        Valor.AddPair('valor', TJSONNumber.Create(12.55));
        Valor.AddPair('tipo', '11');
        ValoresArray.Add(Valor);
        Receita.AddPair('valores', ValoresArray);

        Contribuinte := TJSONObject.Create;
        Contribuinte.AddPair('cnpj', TJSONNull.Create);
        Contribuinte.AddPair('cpf', TJSONNull.Create);
        Contribuinte.AddPair('ie', TJSONNull.Create);
        Contribuinte.AddPair('razao', TJSONNull.Create);
        Contribuinte.AddPair('ibge', TJSONNull.Create);
        Receita.AddPair('contribuinte_destinatario', Contribuinte);

        ExtrasArray := TJSONArray.Create;
        Extra := TJSONObject.Create;
        Extra.AddPair('codigo', '52');
        Extra.AddPair('conteudo', '32220526434850000191550100000000011015892724');
        ExtrasArray.Add(Extra);
        Receita.AddPair('extras', ExtrasArray);

        ReceitasArray.Add(Receita);
        Payload.AddPair('receitas', ReceitasArray);

        Resp := IntegraGnre.Cria(Payload);

        ProcessaResposta(Resp);
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

procedure TForm1.ProcessaResposta(const RespJSON: string);
var
  RespObj: TJSONObject;
  Chave: string;
  Codigo, Tentativa: Integer;
  ConsultaPayload, JSONConsultaResp: TJSONObject;
  ConsultaResp: string;
begin
  RespObj := TJSONObject.ParseJSONValue(RespJSON) as TJSONObject;
  if not Assigned(RespObj) then
  begin
    ShowMessage('Resposta: ' + RespJSON);
    Exit;
  end;

  try
    if RespObj.GetValue<Boolean>('sucesso', False) then
    begin
      Chave := TIntegraUtil.GetValueFromJson(RespObj, 'chave');
      Codigo := RespObj.GetValue<Integer>('codigo', 0);

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
            JSONConsultaResp := TJSONObject.ParseJSONValue(ConsultaResp) as TJSONObject;

            if Assigned(JSONConsultaResp) then
            try
              Codigo := JSONConsultaResp.GetValue<Integer>('codigo', 0);
              if Codigo <> 5023 then
              begin
                if JSONConsultaResp.GetValue<Boolean>('sucesso', False) then
                  ShowMessage('GNRE autorizado: ' + JSONConsultaResp.Format)
                else
                  ShowMessage('GNRE rejeitado: ' + JSONConsultaResp.Format);
                Break;
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
        ShowMessage('GNRE autorizado: ' + RespObj.Format);
    end
    else
      ShowMessage('GNRE rejeitado: ' + RespObj.Format);
  finally
    RespObj.Free;
  end;
end;

end.
