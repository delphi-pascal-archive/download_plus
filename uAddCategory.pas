unit uAddCategory;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TfAddCategory = class(TForm)
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
  private

  public
    { Public declarations }
  end;

var
  fAddCategory: TfAddCategory;

implementation

uses uProcedures, uMain, uObjects;

{$R *.dfm}

procedure TfAddCategory.Button3Click(Sender: TObject);
begin
 Close;
end;

procedure TfAddCategory.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action:=caFree;
end;

procedure TfAddCategory.Button1Click(Sender: TObject);
begin
 edPath.Text:=BrowserFolder(Handle);
end;

procedure TfAddCategory.Button2Click(Sender: TObject);
var
 Node: TTreeNode;
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
   if MessageBox(Application.Handle, PChar('Папки "'+edPath.Text+'" не существует! Создать?'), PChar(Options.Name), MB_OKCANCEL or MB_ICONERROR)=ID_OK
   then
    begin
     MkDir(Trim(edPath.Text));
    end
   else Exit;
  end;
 Node:=fMain.tvFolders.Items.AddChild(fMain.tvFolders.Selected, edName.Text);
 Node.ImageIndex:=2;
 Node.SelectedIndex:=2;
 Close;
end;

end.
