unit UtilUnit;

interface

uses
  System.SysUtils, System.Classes, System.NetEncoding, System.JSON, System.IOUtils, System.ZLib;

type
  TIntegraUtil = class
  private
    class function DecompressGZip(const InBytes: TBytes): string;
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

class function TIntegraUtil.Encode(const Data: string): string;
begin
  Result := TNetEncoding.Base64.Encode(Data);
end;

class function TIntegraUtil.DecompressGZip(const InBytes: TBytes): string;
var
  InStream, OutStream: TMemoryStream;
  DecompressStream: TZDecompressionStream;
  OutBytes: TBytes;
begin
  if (Length(InBytes) >= 2) and (InBytes[0] = $1F) and (InBytes[1] = $8B) then
  begin
    InStream := TMemoryStream.Create;
    OutStream := TMemoryStream.Create;
    try
      InStream.WriteBuffer(InBytes[0], Length(InBytes));
      InStream.Position := 0;
      try
        DecompressStream := TZDecompressionStream.Create(InStream, 15 + 16);
        try
          OutStream.CopyFrom(DecompressStream, 0);
        finally
          DecompressStream.Free;
        end;
        SetLength(OutBytes, OutStream.Size);
        if OutStream.Size > 0 then
        begin
          OutStream.Position := 0;
          OutStream.ReadBuffer(OutBytes[0], OutStream.Size);
        end;
        Result := TEncoding.UTF8.GetString(OutBytes);
      except
        // Em caso de falha na descompressao gzip, retorna os bytes decodificados em UTF8
        Result := TEncoding.UTF8.GetString(InBytes);
      end;
    finally
      InStream.Free;
      OutStream.Free;
    end;
  end
  else
  begin
    Result := TEncoding.UTF8.GetString(InBytes);
  end;
end;

class function TIntegraUtil.Decode(const Data: string): string;
var
  DecodedBytes: TBytes;
begin
  try
    DecodedBytes := TNetEncoding.Base64.DecodeStringToBytes(Data);
    Result := DecompressGZip(DecodedBytes);
  except
    on E: Exception do
      raise Exception.Create('Erro ao decodificar dados: ' + E.Message);
  end;
end;

class function TIntegraUtil.ReadFile(const FileName: string): string;
begin
  try
    Result := TFile.ReadAllText(FileName, TEncoding.UTF8);
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
    Value := JSONObj.GetValue<TJSONValue>(Key, nil);
    if Assigned(Value) then
      Result := Value.Value;
  end;
end;

class function TIntegraUtil.DecodeToBytes(const ABase64: string): TBytes;
begin
  Result := TNetEncoding.Base64.DecodeStringToBytes(ABase64);
end;

class procedure TIntegraUtil.SaveFile(const Data: string; const FilePath: string);
var
  StreamWriter: TStreamWriter;
begin
  if FilePath.Trim.IsEmpty then
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

class procedure TIntegraUtil.SavePDF(const Data: TBytes; const FilePath: string);
var
  FileStream: TFileStream;
begin
  if FilePath.Trim.IsEmpty then
    raise Exception.Create('Caminho do arquivo não informado');

  if not TDirectory.Exists(ExtractFilePath(FilePath)) then
    TDirectory.CreateDirectory(TPath.GetDirectoryName(FilePath));

  FileStream := TFileStream.Create(FilePath, fmCreate);
  try
    if Length(Data) > 0 then
      FileStream.WriteBuffer(Data[0], Length(Data));
  finally
    FileStream.Free;
  end;
end;

end.
