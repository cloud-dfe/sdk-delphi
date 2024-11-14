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
  FilePath: string;
begin
  Base64String := 'STRING EM BASE64 DO PDF';
  
  try
    DecodedBytes := TIntegraUtil.DecodeToBytes(Base64String);
    
    FilePath := 'CAMINHO PARA SALVAR O PDF';

    TIntegraUtil.SavePDF(DecodedBytes, FilePath);
    
    ShowMessage('Arquivo salvo com sucesso após a decodificação!');
  except
    on E: Exception do
      ShowMessage('Erro ao decodificar os dados: ' + E.Message);
  end;
end;


end.
