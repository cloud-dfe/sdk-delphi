unit SDKUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, UtilUnit, EmitenteUnit;

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
  FToken: string;
    FAmbiente: Integer;
    FTimeout: Integer;
    FPort: Integer;
    FDebug: Boolean;
    IntegraEmitente: TIntegraEmitente;

implementation

{$R *.dfm}

procedure TForm1.ButtonAtualizaEmitenteClick(Sender: TObject);
var
  Resp: string;
  RespJSON: TJSONObject;
  Sucesso: Boolean;
begin
  FToken := 'TokenDoEmitente';
  FAmbiente := 2; // 1 - Produção, 2 - Homologação
  FTimeout := 60;
  FPort := 443;
  FDebug := False;

    Resp := IntegraEmitente.Atualiza;
    Resp := UTF8ToString(Resp);

        JSONResp := TJSONObject.ParseJSONValue(Resp) as TJSONObject;
        try
          if Assigned(JSONResp) then
            ShowMessage(JSONResp.Format)
          else
            ShowMessage('Erro ao converter a resposta para JSON');
        finally
          JSONResp.Free;
        end;

      finally
        Payload.Free;
      end;

    finally
      IntegraDfe.Free;
    end;

  finally
    Params.Free;
  end;
end;


end.
