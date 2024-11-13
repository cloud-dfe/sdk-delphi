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
  // Criando um objeto JSON de exemplo
  JSONObject := TJSONObject.Create;
  try
    // Adicionando pares chave-valor ao JSON
    JSONObject.AddPair('nome', 'João');
    JSONObject.AddPair('idade', TJSONNumber.Create(30));
    JSONObject.AddPair('cidade', 'São Paulo');

    // Utilizando a função GetValueFromJson para obter o valor da chave "cidade"
    KeyValue := TIntegraUtil.GetValueFromJson(JSONObject, 'cidade');

    // Exibindo o valor da chave
    if KeyValue <> '' then
      ShowMessage('Valor da chave "cidade": ' + KeyValue)
    else
      ShowMessage('Chave "cidade" não encontrada ou está vazia');
  finally
    JSONObject.Free;
  end;
end;

end.
