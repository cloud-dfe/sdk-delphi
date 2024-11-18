unit Util;

interface

uses
  System.SysUtils, System.Classes, System.ZLib;

type
  TUtil = class
  public
    class function Encode(const Data: string): string;
    class function Decode(const Data: string): string;
    class function ReadFile(const FileName: string): string;
  end;

implementation

{ TUtil }

class function TUtil.Encode(const Data: string): string;
begin
  Result := TNetEncoding.Base64.Encode(Data);
end;

class function TUtil.Decode(const Data: string): string;
var
  DecodedData: TBytes;
  GzDecoded: TBytes;
begin
  try
    DecodedData := TNetEncoding.Base64.DecodeStringToBytes(Data);
    try
      GzDecoded := TCompressionStream.Decompress(DecodedData);
      Result := TEncoding.UTF8.GetString(GzDecoded);
    except
      on E: Exception do
        Result := TEncoding.UTF8.GetString(DecodedData);
    end;
  except
    on E: Exception do
      raise Exception.Create('Erro ao decodificar dados: ' + E.Message);
  end;
end;

class function TUtil.ReadFile(const FileName: string): string;
var
  FileStream: TFileStream;
begin
  try
    FileStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
    try
      SetLength(Result, FileStream.Size);
      FileStream.ReadBuffer(Result[1], FileStream.Size);
    finally
      FileStream.Free;
    end;
  except
    on E: Exception do
      raise Exception.Create('Erro ao ler o arquivo: ' + E.Message);
  end;
end;

end.
