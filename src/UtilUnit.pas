unit UtilUnit;

interface

uses
  System.SysUtils, System.Classes, System.NetEncoding, System.JSON;

type
  TIntegraUtil = class
  public
    class function Encode(const Data: string): string;
    class function Decode(const Data: string): string;
    class function ReadFile(const FileName: string): string;
    class function GetValueFromJson(const JSONObj: TJSONObject; const Key: string): string;
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

class function TIntegraUtil.ReadFile(const FileName: string): string;
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

end.
