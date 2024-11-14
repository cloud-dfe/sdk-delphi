unit SDKUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, UtilUnit;

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
  Base64String: string;
  DecodedBytes: TBytes;
begin
  Base64String := 'SGVsbG8gd29ybGQh';
  
  try
    DecodedBytes := TIntegraUtil.DecodeToBytes(Base64String);
    // DecodedBytes contém os bytes decodificados porém esses dados não podem ser exibidos diretamente em um ShowMessage
    
    ShowMessage('Decodificação feita com sucesso!');
  except
    on E: Exception do
      ShowMessage('Erro ao decodificar os dados: ' + E.Message);
  end;
end;

end.
