unit UtilUnit;

interface

uses
  System.SysUtils, System.Classes, System.NetEncoding, System.JSON;

type
  TIntegraUtil = class
  public
    class function Encode(const Data: string): string;
    class function Decode(const Data: string): string;
    class procedure DecodeToPDF(const Base64Data, FileName: string);
    class function ReadFile(const FileName: string): string;
    class function GetValueFromJson(const JSONObj: TJSONObject; const Key: string): string;
    class procedure SaveToFile(const Content: string; const FileName: string);
    class procedure SavePDF(const FileName: string; const PDFData: TBytes);
  end;

implementation

{ TIntegraUtil }

class function TIntegraUtil.Encode(const Data: string): string;
begin
  Result := TNetEncoding.Base64.Encode(Data);
end;

class function TIntegraUtil.Decode(const Data: string): string;
var
  DecodedData: TBytes;
begin
  try
    DecodedData := TNetEncoding.Base64.DecodeStringToBytes(Data);
    Result := TEncoding.UTF8.GetString(DecodedData);
  except
    on E: Exception do
      raise Exception.Create('Erro ao decodificar dados: ' + E.Message);
  end;
end;

class procedure TIntegraUtil.DecodeToPDF(const Base64Data, FileName: string);
var
  PDFData: TBytes;
  FileStream: TFileStream;
begin
  try
    PDFData := TNetEncoding.Base64.DecodeStringToBytes(Base64Data);
    
    FileStream := TFileStream.Create(FileName, fmCreate);
    try
      FileStream.WriteBuffer(PDFData, Length(PDFData));
    finally
      FileStream.Free;
    end;
  except
    on E: Exception do
      raise Exception.Create('Erro ao decodificar e salvar o PDF: ' + E.Message);
  end;
end;

class function TIntegraUtil.ReadFile(const FileName: string): string;
var
  FileStream: TFileStream;
  StringStream: TStringStream;
begin
  try
    FileStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
    StringStream := TStringStream.Create('', TEncoding.UTF8);
    try
      StringStream.CopyFrom(FileStream, FileStream.Size);
      Result := StringStream.DataString;
    finally
      FileStream.Free;
      StringStream.Free;
    end;
  except
    on E: Exception do
      raise Exception.Create('Erro ao ler o arquivo em UTF8: ' + E.Message);
  end;
end;

class function TIntegraUtil.GetValueFromJson(const JSONObj: TJSONObject; const Key: string): string;
var
  Value: TJSONValue;
begin
  Result := '';
  if Assigned(JSONObj) then
  begin
    Value := JSONObj.GetValue(Key);
    if Assigned(Value) then
    begin
      if Value is TJSONString then
        Result := (Value as TJSONString).Value;
    end;
  end;
end;

class procedure TIntegraUtil.SaveToFile(const Content: string; const FileName: string);
var
  StringStream: TStringStream;
begin
  if not DirectoryExists(ExtractFilePath(FileName)) then
    raise Exception.Create('O diretório especificado não existe.');

  StringStream := TStringStream.Create(Content, TEncoding.UTF8);
  try
    StringStream.SaveToFile(FileName);
  except
    on E: Exception do
      raise Exception.Create('Erro ao salvar o arquivo: ' + E.Message);
  finally
    StringStream.Free;
  end;
end;

class procedure TIntegraUtil.SavePDF(const FileName: string; const PDFData: TBytes);
var
  FileStream: TFileStream;
begin
  try
    FileStream := TFileStream.Create(FileName, fmCreate);
    try
      FileStream.WriteBuffer(PDFData, Length(PDFData));
    finally
      FileStream.Free;
    end;
  except
    on E: Exception do
      raise Exception.Create('Erro ao salvar o PDF: ' + E.Message);
  end;
end;

end.
