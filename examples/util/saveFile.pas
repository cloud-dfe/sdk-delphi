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
  FilePath: string;
  Content: string;
begin
  
  FilePath := 'D:\IntegraNotas\SDKs\sdk-delphi\teste.txt';
  
  // Defina o conteúdo que você deseja salvar no arquivo
  Content := 'Este é um exemplo de texto a ser salvo no arquivo.';

  // Chame o método SaveFile para salvar o conteúdo no arquivo especificado
  try
    TIntegraUtil.SaveFile(Content, FilePath);
    ShowMessage('Arquivo salvo com sucesso!');
  except
    on E: Exception do
      ShowMessage('Erro ao salvar arquivo: ' + E.Message);
  end;
end;

end.