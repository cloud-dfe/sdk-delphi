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
  InputString := 'Este é um exemplo de texto para codificação Base64.';

  EncodedString := TIntegraUtil.Encode(InputString);

  ShowMessage('Texto codificado (Base64): ' + EncodedString);
end;

end.

