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
  EncodedString: string;
  DecodedString: string;
begin
  EncodedString := 'RXN0ZSBfJWV4ZW1wbG9fJWUgdGV4dG8gZW0gQmFzZTY0Lg==';

  DecodedString := TIntegraUtil.Decode(EncodedString);

  ShowMessage('Texto decodificado: ' + DecodedString);
end;

end.
