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
  // Defina a string Base64 para decodificar
  Base64String := 'SGVsbG8gd29ybGQh'; // "Hello world!" em Base64
  
  try
    // Chame o método DecodeToBytes para obter os bytes decodificados
    DecodedBytes := TIntegraUtil.DecodeToBytes(Base64String);
    
    // Defina o caminho para salvar os bytes decodificados em um arquivo (por exemplo, um arquivo de texto)
    FilePath := 'D:\IntegraNotas\SDKs\sdk-delphi\teste.pdf';

    // Salve os bytes decodificados em um arquivo usando o método SavePDF (você pode usar SaveFile também, dependendo do tipo de dados)
    TIntegraUtil.SavePDF(DecodedBytes, FilePath);
    
    // Exiba uma mensagem de sucesso
    ShowMessage('Arquivo salvo com sucesso após a decodificação!');
  except
    on E: Exception do
      ShowMessage('Erro ao decodificar os dados: ' + E.Message);
  end;
end;


end.
