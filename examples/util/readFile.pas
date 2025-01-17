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
  FileName: string;
  FileContent: string;
begin
  FileName := 'caminho_do_arquivo';

  try
    FileContent := TIntegraUtil.ReadFile(FileName);

    ShowMessage('Conteúdo do arquivo:' + sLineBreak + FileContent);
  except
    on E: Exception do
      ShowMessage('Erro ao ler o arquivo: ' + E.Message);
  end;
end;

end.
