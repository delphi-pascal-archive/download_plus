unit uLoading;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Gauges, ExtCtrls, uObjects, uProcedures;

type
  TfLoading = class(TForm)
    ProgressBar: TGauge;
    Button1: TButton;
    Button2: TButton;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Timer: TTimer;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TimerTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Data : TTask;
  end;

var
  fLoading: TfLoading;

implementation


{$R *.dfm}

procedure TfLoading.Button1Click(Sender: TObject);
begin
 Close;
end;

procedure TfLoading.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action := caFree;
end;

procedure TfLoading.TimerTimer(Sender: TObject);
var
 TimeRemind : Integer;
begin
 Label11.Caption := FormatDateTime('hh:mm:ss', Data.TimeBegin - Now);
 if Data.TotalSize > 0 then
  begin
   Label7.Caption := BytesToText(Data.LoadSize) + ' из ' + BytesToText(Data.TotalSize);
   ProgressBar.MinValue := 0;
   ProgressBar.MaxValue := Data.TotalSize;
   ProgressBar.Progress := Data.LoadSize;
   if Data.Speed > 0 then
    begin
     TimeRemind := (Data.TotalSize - Data.LoadSize) div Data.Speed;
     Label13.Caption := GetTimeStr(TimeRemind);
    end;
   end
  else
   begin
    ProgressBar.MinValue := 0;
    ProgressBar.MaxValue := 8;
    ProgressBar.AddProgress(1);
    if ProgressBar.Progress = 8 then ProgressBar.Progress := 0;
    Label7.Caption := BytesToText(Data.LoadSize);
  end;
 Label9.Caption := BytesToText(Data.Speed) + '/с';
 if (Data.Status = tsLoad) then
  begin
   Timer.Enabled := False;
   ProgressBar.Progress := ProgressBar.MaxValue;
   if Options.AutoCloseLoadingForm then Close;
  end;
 if (Data.Status = tsError) then
  begin
   Timer.Enabled := False;
   ProgressBar.BackColor := clRed;
   if Options.AutoCloseLoadingForm then Close;
  end;
end;

procedure TfLoading.FormShow(Sender: TObject);
begin
 Timer.Enabled := True;
 Label2.Caption := Data.LinkToFile;
end;

procedure TfLoading.Button2Click(Sender: TObject);
begin
 Data.Status := tsStoped;
 Close;
end;

end.
