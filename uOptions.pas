unit uOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Spin, Registry;

type
  TfOptions = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    cbAgent: TComboBox;
    TabSheet3: TTabSheet;
    cbxRunWithWindows: TCheckBox;
    cbxHookClipboard: TCheckBox;
    cbxMinToTray: TCheckBox;
    Label23: TLabel;
    mmExtention: TMemo;
    Label15: TLabel;
    TrackBar: TTrackBar;
    Label16: TLabel;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    cbxAutoCloseLoadingForm: TCheckBox;
    cbxShowLoadingForm: TCheckBox;
    cbxMinOnRun: TCheckBox;
    cbxRedirect: TCheckBox;
    Label6: TLabel;
    hkApplication: THotKey;
    Label7: TLabel;
    cbHttpVersion: TComboBox;
    cbxResumeLoad: TCheckBox;
    TabSheet2: TTabSheet;
    cbxUseProxyLocal: TCheckBox;
    cbUseHTTPProxy: TCheckBox;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    edHTTPProxyHost: TEdit;
    edHTTPProxyPort: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    edHTTPProxyUser: TEdit;
    edHTTPProxyPass: TEdit;
    GroupBox2: TGroupBox;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    edFTPProxyHost: TEdit;
    edFTPProxyPort: TEdit;
    edFTPProxyUser: TEdit;
    edFTPProxyPass: TEdit;
    cbUseFTPProxy: TCheckBox;
    cbxAlwaysInTray: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TrackBarChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fOptions: TfOptions;

implementation

uses uObjects, uMain;

{$R *.dfm}

procedure TfOptions.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action:=caFree;
end;

procedure TfOptions.btnCancelClick(Sender: TObject);
begin
 Close;
end;

procedure TfOptions.btnOKClick(Sender: TObject);
var
 Registry : TRegistry;
begin
  Options.AgentName := Trim(cbAgent.Text);
  Options.ShowLoadingForm := cbxShowLoadingForm.Checked;
  Options.AutoCloseLoadingForm := cbxAutoCloseLoadingForm.Checked;
  Options.HookClipboard := cbxHookClipboard.Checked;
  Options.MinToTray := cbxMinToTray.Checked;
  Options.MinOnRun := cbxMinOnRun.Checked;
  Options.AlwaysInTray := cbxAlwaysInTray.Checked;
  Options.RunWithWindows := cbxRunWithWindows.Checked;
  Options.HotKey := hkApplication.HotKey;
  Options.Redirect := cbxRedirect.Checked;
  Options.UseProxyLocal := cbxUseProxyLocal.Checked;
  Options.ResumeLoad := cbxResumeLoad.Checked;
  Options.HTTPProxy.UseProxy := cbUseHTTPProxy.Checked;
  Options.HTTPProxy.Host := Trim(edHTTPProxyHost.Text);
  Options.HTTPProxy.Port := StrToInt(Trim(edHTTPProxyPort.Text));
  Options.HTTPProxy.UserName := Trim(edHTTPProxyUser.Text);
  Options.HTTPProxy.Password := Trim(edHTTPProxyPass.Text);
  Options.FTPProxy.UseProxy := cbUseFTPProxy.Checked;
  Options.FTPProxy.Host := Trim(edFTPProxyHost.Text);
  Options.FTPProxy.Port := StrToInt(Trim(edFTPProxyPort.Text));
  Options.FTPProxy.UserName := Trim(edFTPProxyUser.Text);
  Options.FTPProxy.Password := Trim(edFTPProxyPass.Text);

  if cbHttpVersion.Text = 'HTTP 1.0' then Options.HTTPVersion := hvHttp10 else Options.HTTPVersion := hvHttp11;

  case TrackBar.Position of

    0 : Options.Priority := tpIdle;
    1 : Options.Priority := tpLowest;
    2 : Options.Priority := tpLower;
    3 : Options.Priority := tpNormal;
    4 : Options.Priority := tpHigher;
    5 : Options.Priority := tpHighest;
    6 : Options.Priority := tpTimeCritical;
    
  end;

  Options.Save;

  Registry := TRegistry.Create(KEY_ALL_ACCESS);

  try

    Registry.RootKey := HKEY_LOCAL_MACHINE;
    Registry.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Run', True);

    if cbxRunWithWindows.Checked then Registry.WriteString('Download', Application.ExeName)
    else Registry.DeleteValue('Download');

    Registry.CloseKey;

  finally

    Registry.Free;
    
  end;

  Close;

end;

procedure TfOptions.FormCreate(Sender: TObject);
begin

  cbAgent.Text := Options.AgentName;
  cbxShowLoadingForm.Checked := Options.ShowLoadingForm;
  cbxAutoCloseLoadingForm.Checked := Options.AutoCloseLoadingForm;
  cbxHookClipboard.Checked := Options.HookClipboard;
  cbxMinToTray.Checked := Options.MinToTray;
  cbxMinOnRun.Checked := Options.MinOnRun;
  cbxAlwaysInTray.Checked := Options.AlwaysInTray;
  cbxRunWithWindows.Checked := Options.RunWithWindows;
  hkApplication.HotKey := Options.HotKey;
  cbxRedirect.Checked := Options.Redirect;
  cbxUseProxyLocal.Checked := Options.UseProxyLocal;
  cbxResumeLoad.Checked := Options.ResumeLoad; 
  cbUseHTTPProxy.Checked := Options.HTTPProxy.UseProxy;
  edHTTPProxyHost.Text := Options.HTTPProxy.Host;
  edHTTPProxyPort.Text := IntToStr(Options.HTTPProxy.Port);
  edHTTPProxyUser.Text := Options.HTTPProxy.UserName;
  edHTTPProxyPass.Text := Options.HTTPProxy.Password;
  cbUseFTPProxy.Checked := Options.FTPProxy.UseProxy;
  edFTPProxyHost.Text := Options.FTPProxy.Host;
  edFTPProxyPort.Text := IntToStr(Options.FTPProxy.Port);
  edFTPProxyUser.Text := Options.FTPProxy.UserName;
  edFTPProxyPass.Text := Options.FTPProxy.Password;

  if Options.HTTPVersion = hvHttp10 then cbHttpVersion.ItemIndex := 0 else cbHttpVersion.ItemIndex := 1;

  case Options.Priority of

    tpIdle         : begin TrackBar.Position := 0; Label16.Caption := 'Низкий'; end;
    tpLowest       : begin TrackBar.Position := 1; Label16.Caption := 'Ниже среднего'; end;
    tpLower        : begin TrackBar.Position := 2; Label16.Caption := 'Средний'; end;
    tpNormal       : begin TrackBar.Position := 3; Label16.Caption := 'Выше среднего'; end;
    tpHigher       : begin TrackBar.Position := 4; Label16.Caption := 'Высокий'; end;
    tpHighest      : begin TrackBar.Position := 5; Label16.Caption := 'Highest'; end;
    tpTimeCritical : begin TrackBar.Position := 6; Label16.Caption := 'Реального времени'; end;
  end;
end;

procedure TfOptions.TrackBarChange(Sender: TObject);
begin
 case TrackBar.Position of
   0: Label16.Caption := 'Низкий';
   1: Label16.Caption := 'Ниже среднего';
   2: Label16.Caption := 'Средний';
   3: Label16.Caption := 'Выше среднего';
   4: Label16.Caption := 'Высокий';
   5: Label16.Caption := 'Highest';
   6: Label16.Caption := 'Реального времени';
  end;
end;

end.
