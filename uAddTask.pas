unit uAddTask;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StdCtrls, Clipbrd, Mask, Spin, Dialogs;

type
  TfAddTask = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    Label3: TLabel;
    Label4: TLabel;
    edLogin: TEdit;
    edPassword: TEdit;
    cbxSpecial: TCheckBox;
    Label5: TLabel;
    Label9: TLabel;
    cbCategory: TComboBox;
    cbDirectory: TComboBox;
    Label10: TLabel;
    edFileName: TEdit;
    cbUrl: TComboBox;
    Label8: TLabel;
    edDescription: TEdit;
    sePort: TSpinEdit;
    GroupBox1: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCancelClick(Sender: TObject);
    procedure cbxSpecialClick(Sender: TObject);
    procedure cbDirectoryClick(Sender: TObject);
    procedure cbDirectoryDropDown(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbUrlChange(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fAddTask: TfAddTask;

implementation

uses uObjects, uMain, uProcedures;

{$R *.dfm}

procedure TfAddTask.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action:=caFree;
end;

procedure TfAddTask.btnCancelClick(Sender: TObject);
begin
 Close;
end;

procedure TfAddTask.cbxSpecialClick(Sender: TObject);
begin
 if cbxSpecial.Checked
 then
  begin
   edLogin.Enabled:=true;
   edPassword.Enabled:=true;
   sePort.Enabled:=true;
  end
 else
  begin
   edLogin.Enabled:=false;
   edPassword.Enabled:=false;
   sePort.Enabled:=false;
  end;
end;

procedure TfAddTask.cbDirectoryClick(Sender: TObject);
begin
 if cbDirectory.ItemIndex=0
 then
  begin
   cbDirectory.Items.Strings[0]:=BrowserFolder(Handle);
   cbDirectory.ItemIndex:=0;
  end;
end;

procedure TfAddTask.cbDirectoryDropDown(Sender: TObject);
begin
 cbDirectory.Items.Strings[0]:='Обзор папок...';
end;

procedure TfAddTask.FormCreate(Sender: TObject);
var
 ClipboardTemp: string;
 i: Integer;
begin
 if Clipboard.HasFormat(CF_TEXT)
 then
  begin
   ClipboardTemp:=Trim(Clipboard.AsText);
   if (Pos('http://', ClipboardTemp)=1)
      or (Pos('https://', ClipboardTemp)=1)
      or (Pos('ftp://', ClipboardTemp)=1)
   then cbUrl.Text:=ClipboardTemp;
   if Pos('www.', ClipboardTemp)=1
   then cbUrl.Text:='http://'+ClipboardTemp;
   if Pos('ftp.', ClipboardTemp)=1
   then cbUrl.Text:='ftp://'+ClipboardTemp;
  end;
 edFileName.Text:=CreateFileName(cbUrl.Text);
 cbUrl.Items:=Options.Url;
 sePort.Enabled:=false;
 for i:=0 to Options.Directory.Count-1 do
  begin
   cbDirectory.Items.Insert(1, Options.Directory.Strings[i]);
  end;
end;

procedure TfAddTask.cbUrlChange(Sender: TObject);
begin
 edFileName.Text:=CreateFileName(cbUrl.Text);
end;

procedure TfAddTask.btnOKClick(Sender: TObject);
var
 i, n: integer;
 Data: TTask;
begin
 if cbUrl.Text=''
 then
  begin
   MessageBox(Application.Handle, 'Не указана ссылка!', PChar(Options.Name), MB_OK or MB_ICONERROR);
   Exit;
  end;
 if cbDirectory.Text=''
 then
  begin
   MessageBox(Application.Handle, 'Не указан каталог для сохранения файла!', PChar(Options.Name), MB_OK or MB_ICONERROR);
   Exit;
  end;
 if edFileName.Text=''
 then
  begin
   MessageBox(Application.Handle, 'Не указано имя файла!', PChar(Options.Name), MB_OK or MB_ICONERROR);
   Exit;
  end;
 if cbCategory.Text=''
 then
  begin
   MessageBox(Application.Handle, 'Не указана категория!', PChar(Options.Name), MB_OK or MB_ICONERROR);
   Exit;
  end;
 if (Pos('http://', Trim(cbUrl.Text))=1)
  or (Pos('https://', Trim(cbUrl.Text))=1)
  or (Pos('ftp://', Trim(cbUrl.Text))=1)
 then
 else
  begin
   MessageBox(Application.Handle, 'Не указан протокол (http://, https://, ftp://)!', PChar(Options.Name), MB_OK or MB_ICONERROR);
   Exit;
  end;
 if not DirectoryExists(Trim(cbDirectory.Text))
 then
  begin
   if MessageBox(Application.Handle, PChar('Папки "'+cbDirectory.Text + '" не существует! Создать?'), PChar(Options.Name), MB_OKCANCEL or MB_ICONERROR)=IDOK
   then MkDir(Trim(cbDirectory.Text))
   else Exit;
  end;
 if FileExists(Trim(cbDirectory.Text)+'\'+Trim(edFileName.Text))
 then
  begin
   if MessageBox(Application.Handle, PChar('Файл "'+cbDirectory.Text + '\' + edFileName.Text + '" уже существует! Хотите перезаписать его?'), PChar(Options.Name), MB_OKCANCEL or MB_ICONERROR)=IDCANCEL
   then Exit;
  end;
 n:=0;
 for i:=0 to Options.Url.Count-1 do
  begin
   if Options.Url.Strings[I]=Trim(cbUrl.Text)
   then n:=n+1;
  end;
 if n=0
 then Options.Url.Insert(0, Trim(cbUrl.Text));
 n:=0;
 for i:=0 to Options.Directory.Count-1 do
  begin
   if Options.Directory.Strings[i]=Trim(cbDirectory.Text)
   then n:=n+1;
  end;
 if n=0
 then Options.Directory.Insert(0, Trim(cbDirectory.Text));
 Data:=TTask.Create;
 Data.LinkToFile:=Trim(cbUrl.Text);
 Data.FileName:=Trim(edFileName.Text);
 Data.Directory:=Trim(cbDirectory.Text);
 Data.Login:=Trim(edLogin.Text);
 Data.Password:=Trim(edPassword.Text);
 Data.Port:=sePort.Value;
 Data.UseSpecial:=cbxSpecial.Checked;
 Data.Description:=Trim(edDescription.Text);
 Data.Category:=Trim(edDescription.Text);
 Data.Status:=tsReady;
 Data.TotalSize:=0;
 Data.LoadSize:=0;
 Data.StartPosition:=0;
 Data.EndPosition:=0;
 Data.LastModified:=0;
 Data.TimeBegin:=0;
 Data.TimeEnd:=0;
 Data.TimeTotal:=0;
 Data.ErrorText:='';
 if Pos('http://', Data.LinkToFile)=1
 then Data.Protocol:=ptHttp;
 if Pos('https://', Data.LinkToFile)=1
 then Data.Protocol:=ptHttps;
 if Pos('ftp://', Data.LinkToFile)=1
 then Data.Protocol:=ptFtp;
 Options.Task.Add(Data);
 Close;
end;

end.
