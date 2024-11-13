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
  InputString: string;
  EncodedString: string;
begin
  // Definindo uma string de exemplo para codificação
  InputString := 'Este é um exemplo de texto para codificação Base64.';

  // Utilizando a função Encode para codificar a string
  EncodedString := TIntegraUtil.Encode(InputString);

  // Exibindo o resultado da codificação
  ShowMessage('Texto original: ' + InputString + sLineBreak +
              'Texto codificado (Base64): ' + EncodedString);
end;

end.

