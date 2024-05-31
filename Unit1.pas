//------------------------------------------------------------------------------------------------------------
//********* Sobre ************
//Autor: Gisele de Melo
//Esse código foi desenvolvido com o intuito de aprendizado para o blog codedelphi.com, portanto não me
//responsabilizo pelo uso do mesmo.
//
//********* About ************
//Author: Gisele de Melo
//This code was developed for learning purposes for the codedelphi.com blog, therefore I am not responsible for
//its use.
//------------------------------------------------------------------------------------------------------------

unit Unit1;

interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.DateUtils;
type
  TTimeThread = class(TThread)
  private
    FInterval: Integer;
    FOnTimeElapsed: TThreadProcedure;
  protected
    procedure Execute; override;
  public
    constructor Create(Interval: Integer; OnTimeElapsed: TThreadProcedure);
  end;
  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    TimeThread: TTimeThread;
    StartTime: TDateTime;
    procedure OnTimeElapsed;
  public
    { Public declarations }
  end;
var
  Form1: TForm1;
implementation
{$R *.dfm}
{ TTimeThread }
constructor TTimeThread.Create(Interval: Integer; OnTimeElapsed: TThreadProcedure);
begin
  inherited Create(False);
  FreeOnTerminate := True;
  FInterval := Interval;
  FOnTimeElapsed := OnTimeElapsed;
end;
procedure TTimeThread.Execute;
begin
  while not Terminated do
  begin
    Sleep(FInterval);
    Synchronize(FOnTimeElapsed);
  end;
end;
{ TForm1 }
procedure TForm1.Button1Click(Sender: TObject);
begin
  // Inicia a thread para controlar o tempo
  StartTime := Now;
  Label1.Caption := 'Tempo decorrido: 0 segundos';
  TimeThread := TTimeThread.Create(1000, OnTimeElapsed);
end;
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Certifica-se de finalizar a thread quando o formulário é fechado
  if Assigned(TimeThread) then
    TimeThread.Terminate;
end;
procedure TForm1.OnTimeElapsed;
var
  ElapsedTime: TDateTime;
begin
  // Calcula o tempo decorrido desde o início
  ElapsedTime := Now - StartTime;
  // Atualiza o rótulo com o tempo decorrido formatado
  Label1.Caption := 'Tempo decorrido: ' + FormatDateTime('hh:nn:ss', ElapsedTime);
end;
end.
