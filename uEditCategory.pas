unit uEditCategory;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TfEditCategory = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    edName: TEdit;
    edPath: TEdit;
    Label3: TLabel;
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure Button3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public
    { Public declarations }
  end;

var
  fEditCategory: TfEditCategory;

implementation

uses uProcedures, uMain, uObjects;

{$R *.dfm}

procedure TfEditCategory.Button3Click(Sender: TObject);
begin
 Close;
end;

procedure TfEditCategory.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action:=caFree;
end;

procedure TfEditCategory.Button1Click(Sender: TObject);
begin
 edPath.Text:=BrowserFolder(Handle);
end;

procedure TfEditCategory.Button2Click(Sender: TObject);
begin
 if Trim(edName.Text)=''
 then
  begin
   MessageBox(Application.Handle, 'Не задано название категории!', PChar(Options.Name), MB_OK or MB_ICONERROR);
   Exit;
  end;
 if Trim(edPath.Text)=''
 then
  begin
   MessageBox(Application.Handle, 'Не задано расположение папки!', PChar(Options.Name), MB_OK or MB_ICONERROR);
   Exit;
  end;
 if not DirectoryExists(Trim(edPath.Text))
 then
  begin
   if MessageBox(Application.Handle, PChar('Папки "' + edPath.Text + '" не существует! Создать?'), PChar(Options.Name), MB_OKCANCEL or MB_ICONERROR)=ID_OK
   then
    begin
     MkDir(Trim(edPath.Text));
    end
   else Exit;
  end;
 fMain.tvFolders.Selected.Text := Trim(edName.Text);
 Close;
end;

procedure TfEditCategory.FormCreate(Sender: TObject);
begin
 edName.Text:=fMain.tvFolders.Selected.Text;
end;

end.
