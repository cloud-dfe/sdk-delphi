unit UtilUnit;

interface

uses
  System.SysUtils, System.Classes, System.NetEncoding, System.JSON, System.IOUtils;

type
  TIntegraUtil = class
  public
    class function Encode(const Data: string): string;
    class function Decode(const Data: string): string;
    class function ReadFile(const FileName: string): string;
    class function GetValueFromJson(const JSONObj: TJSONObject; const Key: string): string;
    class function DecodeToBytes(const ABase64: string): TBytes;
    class procedure SaveFile(const Data: string; const FilePath: string);
    class procedure SavePDF(const Data: TBytes; const FilePath: string);
  end;

implementation

{ TIntegraUtil }

// ENCODE PARA BASE64

class function TIntegraUtil.Encode(const Data: string): string;
begin
  Result := TNetEncoding.Base64.Encode(Data);
end;

// DECODE DE BASE64

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

// LER ARQUIVO EM UTF8

class function TIntegraUtil.ReadFile(const FileName: string): string;
begin
  try
    Result := TFile.ReadAllText(FileName, TEncoding.UTF8);
  except
    on E: Exception do
      raise Exception.Create('Erro ao ler o arquivo em UTF8: ' + E.Message);
  end;
end;

// OBTER VALOR DE UMA CHAVE EM UM JSON

class function TIntegraUtil.GetValueFromJson(const JSONObj: TJSONObject; const Key: string): string;
var
  Value: TJSONValue;
begin
  Result := '';
  if Assigned(JSONObj) then
  begin
    Value := JSONObj.GetValue(Key);
    if Assigned(Value) then
      Result := Value.ToString.Replace('"', '');
  end;
end;

// DECODIFICAR BASE64 PARA BYTES

class function TIntegraUtil.DecodeToBytes(const ABase64: string): TBytes;
var
  Decoder: TBase64Encoding;
begin
  Decoder := TBase64Encoding.Create;
  try
    Result := Decoder.DecodeStringToBytes(ABase64);
  finally
    Decoder.Free;
  end;
end;

// SALVAR ARQUIVO

class procedure TIntegraUtil.SaveFile(const Data: string; const FilePath: string);
var
  StreamWriter: TStreamWriter;

begin

  if FilePath = '' then
    raise Exception.Create('Caminho do arquivo não informado');

  if not TDirectory.Exists(ExtractFilePath(FilePath)) then
    TDirectory.CreateDirectory(TPath.GetDirectoryName(FilePath));

  StreamWriter := TStreamWriter.Create(FilePath, False, TEncoding.UTF8);
  try
    StreamWriter.Write(Data);
  finally
    StreamWriter.Free;
  end;

end;

// SALVAR PDF

class procedure TIntegraUtil.SavePDF(const Data: TBytes; const FilePath: string);
var
  FileStream: TFileStream;
begin
  if FilePath = '' then
    raise Exception.Create('Caminho do arquivo não informado');

  if not TDirectory.Exists(ExtractFilePath(FilePath)) then
    TDirectory.CreateDirectory(TPath.GetDirectoryName(FilePath));

  FileStream := TFileStream.Create(FilePath, fmCreate);
  try
    FileStream.Write(Data, Length(Data));
  finally
    FileStream.Free;
  end;
end;

end.
