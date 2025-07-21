procedure TForm1.ButtonDownloadNfseClick(Sender: TObject);
var
  Resp: string;
  JsonResp, DocObj: TJSONObject;
  XMLDecoded, FilePathXML, FilePathPDF: string;
  PDFDecoded: TBytes;
  Params, Payload: TJSONObject;
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

    IntegraDfe := TIntegraDfe.Create(Params);

    try
      Payload := TJSONObject.Create;
      try
        Payload.AddPair('chave', '50000000000000000000000000000000000000000000');

        Resp := IntegraDfe.DownloadNfse(Payload);
        JsonResp := TJSONObject.ParseJSONValue(Resp) as TJSONObject;

        if Assigned(JsonResp) then
        try
          if TIntegraUtil.GetValueFromJson(JsonResp, 'sucesso') = 'true' then
          begin
            DocObj := JsonResp.GetValue<TJSONObject>('doc');
            if Assigned(DocObj) then
            begin
              XMLDecoded := TIntegraUtil.Decode(TIntegraUtil.GetValueFromJson(DocObj, 'xml'));
              PDFDecoded := TIntegraUtil.DecodeToBytes(TIntegraUtil.GetValueFromJson(DocObj, 'pdf'));

              FilePathXML := 'caminho_do_arquivo_nfse.xml';
              FilePathPDF := 'caminho_do_arquivo_nfse.pdf';

              try
                TIntegraUtil.SaveFile(XMLDecoded, FilePathXML);
                TIntegraUtil.SavePDF(PDFDecoded, FilePathPDF);
                ShowMessage('Arquivos XML e PDF salvos com sucesso!');
              except
                on E: Exception do
                  ShowMessage('Erro ao salvar arquivos: ' + E.Message);
              end;

              DocObj.Free;
            end
            else
              ShowMessage('Erro: Objeto "doc" não encontrado na resposta.');
          end
          else
            ShowMessage('Erro: ' + TIntegraUtil.GetValueFromJson(JsonResp, 'mensagem'));
        finally
          JsonResp.Free;
        end;
      finally
        Payload.Free;
      end;
    finally
      IntegraDfe.Free;
    end;
  finally
    Params.Free;
  end;
end;
