unit SDKUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.JSON, UtilUnit;

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

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  JSONObject: TJSONObject;
  KeyValue: string;
begin
  JSONObject := TJSONObject.Create;
  try
    JSONObject.AddPair('exemplo', 'valor da chave');

    KeyValue := TIntegraUtil.GetValueFromJson(JSONObject, 'exemplo');

    if KeyValue <> '' then
      ShowMessage('Valor da chave: ' + KeyValue)
    else
      ShowMessage('Não foi possível encontrar o valor da chave.');
  finally
    JSONObject.Free;
  end;
end;

end.
