unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ToolWin, ComCtrls, ImgList, StdActns, Menus, ExtCtrls, ActnList,
  XPStyleActnCtrls, ActnMan, ActnCtrls, ActnMenus, StdCtrls, XPMan, Clipbrd,
  DateUtils, ShellAPI;

type
  TfMain = class(TForm)
    ilMenu: TImageList;
    ActionMainMenuBar1: TActionMainMenuBar;
    ActionManager1: TActionManager;
    actExit: TAction;
    actAdd: TAction;
    actOptions: TAction;
    lvTasks: TListView;
    StatusBar: TStatusBar;
    actStatusBar: TAction;
    actInfo: TAction;
    Panel1: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Splitter1: TSplitter;
    tvFolders: TTreeView;
    Splitter2: TSplitter;
    Panel2: TPanel;
    lvParams: TListView;
    XPManifest1: TXPManifest;
    ilTasks: TImageList;
    actLoad: TAction;
    actDelete: TAction;
    ilTree: TImageList;
    actParams: TAction;
    actStop: TAction;
    ilTray: TImageList;
    actClearDel: TAction;
    actEdit: TAction;
    actAbout: TAction;
    actAddCategory: TAction;
    actDeleteCategory: TAction;
    actEditCategory: TAction;
    pmTasks: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N5: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    pmTree: TPopupMenu;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N14: TMenuItem;
    tmUpdate: TTimer;
    N15: TMenuItem;
    N16: TMenuItem;
    ActionToolBar1: TActionToolBar;
    pmTray: TPopupMenu;
    N17: TMenuItem;
    N18: TMenuItem;
    N20: TMenuItem;
    N21: TMenuItem;
    N22: TMenuItem;
    N19: TMenuItem;
    N23: TMenuItem;
    N24: TMenuItem;
    actOpenFolder: TAction;
    N4: TMenuItem;
    N6: TMenuItem;
    actOpenFile: TAction;
    N13: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure actExitExecute(Sender: TObject);
    procedure actAddExecute(Sender: TObject);
    procedure actOptionsExecute(Sender: TObject);
    procedure actStatusBarExecute(Sender: TObject);
    procedure actInfoExecute(Sender: TObject);
    procedure actLoadExecute(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure lvParamsCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure actParamsExecute(Sender: TObject);
    procedure lvTasksSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure tvFoldersChange(Sender: TObject; Node: TTreeNode);
    procedure actStopExecute(Sender: TObject);
    procedure TrayIconClick(Sender: TObject);
    procedure lvTasksCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure actClearDelExecute(Sender: TObject);
    procedure actEditExecute(Sender: TObject);
    procedure actAboutExecute(Sender: TObject);
    procedure Panel2Resize(Sender: TObject);
    procedure Panel1Resize(Sender: TObject);
    procedure actAddCategoryExecute(Sender: TObject);
    procedure lvTasksKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure actDeleteCategoryExecute(Sender: TObject);
    procedure actEditCategoryExecute(Sender: TObject);
    procedure tmUpdateTimer(Sender: TObject);
    procedure N17Click(Sender: TObject);
    procedure actOpenFolderExecute(Sender: TObject);
    procedure actOpenFileExecute(Sender: TObject);
  private
    NextViewerHandle : THandle;
    procedure OnDrawClipboard(var Message : TMessage); Message WM_DRAWCLIPBOARD;
    procedure OnChangeCBCHain(var Message : TMessage); Message WM_CHANGECBCHAIN;
  public
    procedure InsertItem(P : Pointer);
    procedure UpdateItems;
    procedure RefreshTasks;
    procedure SaveTreeNode(Node : TTreeNode);
  end;

var
  fMain: TfMain;

implementation

uses uAddTask, uObjects, uProcedures, uOptions, uLoading, uThreads, uEditTask, uAbout, uAddCategory, uEditCategory,
  uDownload;

{$R *.dfm}

procedure TfMain.UpdateItems;
var
 Data: TTask;
 i: integer;
begin
 for i:=0 to lvTasks.Items.Count-1 do
  begin
   Data := lvTasks.Items[i].Data;
   if Data.Status=tsLoading
   then
    begin
     if Data.TotalSize>0
     then lvTasks.Items[i].SubItems[1]:=BytesToText(Data.TotalSize)
     else lvTasks.Items[i].SubItems[1]:='?';
     lvTasks.Items[i].SubItems[2]:=BytesToText(Data.LoadSize);
     if Data.TotalSize>0
     then lvTasks.Items[i].SubItems[3]:=FloatToStrF((Data.LoadSize/Data.TotalSize)*100, ffFixed, 18, 0)
     else lvTasks.Items[i].SubItems[3]:='?';
     if Data.Speed>0
     then lvTasks.Items[i].SubItems[4]:=BytesToText(Data.Speed)+'/с'
     else lvTasks.Items[i].SubItems[4]:='?';
    end;
  end;
end;

procedure TfMain.FormCreate(Sender: TObject);
begin
 Options:=TOptions.Create;
 Options.Path:=ExtractFileDir(Application.ExeName);
 Options.Version:=GetFileVersion(Application.ExeName);
 Options.Name:='Download Plus';
 Options.Load;
 NextViewerHandle:=SetClipboardViewer(Handle);
 Application.Title:=Options.Name+' 0.2.1 '+Options.Version;
 Caption:=Options.Name+' 0.2.1 '+Options.Version;
 tvFolders.FullExpand;
 actParams.Checked:=Panel2.Visible;
 actStatusBar.Checked:=StatusBar.Visible;
 tvFoldersChange(Self, tvFolders.Selected);
end;

procedure TfMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 ChangeClipboardChain(Handle, NextViewerHandle);
 Options.Save;
 Options.Free;
end;

procedure TfMain.actExitExecute(Sender: TObject);
begin
 Close;
end;

procedure TfMain.actAddExecute(Sender: TObject);
begin
 fAddTask:=TfAddTask.Create(Application);
 fAddTask.ShowModal;
end;

procedure TfMain.actOptionsExecute(Sender: TObject);
begin
 fOptions:=TfOptions.Create(Application);
 fOptions.ShowModal;
end;

procedure TfMain.actStatusBarExecute(Sender: TObject);
begin
 StatusBar.Visible:=actStatusBar.Checked;
end;

procedure TfMain.actInfoExecute(Sender: TObject);
var
 ThreadHttp: TGetOptionsHttp;
 ThreadFtp: TGetOptionsFtp;
begin
 if lvTasks.SelCount=0
 then Exit;
 if (TTask(lvTasks.Selected.Data).Protocol=ptHttp)
       or (TTask(lvTasks.Selected.Data).Protocol=ptHttps)
 then
  begin
   ThreadHttp:=TGetOptionsHttp.Create(true, lvTasks.Selected.Data);
   ThreadHttp.Priority:=Options.Priority;
   ThreadHttp.FreeOnTerminate:=true;
   ThreadHttp.Resume;
  end;
 if TTask(lvTasks.Selected.Data).Protocol=ptFtp
 then
  begin
   ThreadFtp:=TGetOptionsFtp.Create(true, lvTasks.Selected.Data);
   ThreadFtp.Priority:=Options.Priority;
   ThreadFtp.FreeOnTerminate:=true;
   ThreadFtp.Resume;
  end;
end;

procedure TfMain.actLoadExecute(Sender: TObject);
var
 LoadOne: TLoadOne;
begin
 if lvTasks.SelCount=0
 then Exit;
 if Options.MinOnRun
 then Application.Minimize;
 if TTask(lvTasks.Selected.Data).Status=tsLoad
 then
  begin
   if MessageBox(Application.Handle, PChar('Файл "'+TTask(lvTasks.Selected.Data).FileName + '" уже был загружен. Загрузить его снова?'), PChar(Options.Name), MB_YESNO or MB_ICONERROR)=IDYES
   then
    begin
     TTask(lvTasks.Selected.Data).LoadSize:=0;
     TTask(lvTasks.Selected.Data).Status:=tsReady;
    end
   else Exit;
  end;
 if Options.ShowLoadingForm
 then
  begin
   fLoading:=TfLoading.Create(Application);
   fLoading.Data:=lvTasks.Selected.Data;
   fLoading.Show;
  end;
 LoadOne:=TLoadOne.Create(true, lvTasks.Selected.Data);
 LoadOne.FreeOnTerminate:=true;
 LoadOne.Resume;
end;

procedure TfMain.actDeleteExecute(Sender: TObject);
var
 i: integer;
begin
 if not Assigned(lvTasks.Selected)
 then Exit;
 if MessageBox(Application.Handle, 'Удалить выделенные элементы?', PChar(Options.Name), MB_YESNO or MB_ICONWARNING)=IDYES
 then
  begin
   for i:=0 to lvTasks.Items.Count-1 do
    begin
     if lvTasks.Items[i].Selected
     then
      begin
       if TTask(lvTasks.Selected.Data).Status=tsDeleted
       then TTask(lvTasks.Selected.Data).Status:=tsDelete
       else TTask(lvTasks.Selected.Data).Status:=tsDeleted;
      end;
    end;
  end;
 lvTasks.Selected.Delete;
 lvTasks.Repaint;
end;

procedure TfMain.lvParamsCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
 if Item.Index mod 2=0
 then
  begin
   Sender.Canvas.Font.Color:=clBlack;
   Sender.Canvas.Brush.Color:=$F6F6F6;
  end
 else
  begin
   Sender.Canvas.Font.Color:=clBlack;
   Sender.Canvas.Brush.Color:=clWhite;
  end;
end;

procedure TfMain.actParamsExecute(Sender: TObject);
begin
 if ActParams.Checked
 then
  begin
   Panel2.Height:=200;
   Panel1.Height:=Panel4.Height-200;
   Splitter2.Visible:=true;
  end
 else
  begin
   Panel2.Height:=0;
   Panel1.Height:=Panel4.Height;
   Splitter2.Visible:=false;
  end;
end;

procedure TfMain.lvTasksSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
var
 Data: TTask;
begin
 if (lvParams.Items[0]=nil) or (Item<>lvTasks.Selected)
 then Exit;
 Data:=Item.Data;
 lvParams.Items[0].SubItems[1]:=Data.LinkToFile;
 lvParams.Items[1].SubItems[1]:=Data.Directory;
 lvParams.Items[2].SubItems[1]:=Data.FileName;
 if Data.TotalSize>0
 then lvParams.Items[3].SubItems[1]:=IntToStr(Data.TotalSize)
 else lvParams.Items[3].SubItems[1]:='?';
 lvParams.Items[4].SubItems[1]:=IntToStr(Data.LoadSize);
 if Data.LastModified<>0
 then lvParams.Items[5].SubItems[1]:=FormatDateTime('dd.mm.yyyy hh:mm:ss', Data.LastModified)
 else lvParams.Items[5].SubItems[1]:='?';
 if Data.TotalSize>0
 then lvParams.Items[6].SubItems[1]:='Да'
 else lvParams.Items[6].SubItems[1]:='Нет';
 if Data.TimeBegin<>0
 then lvParams.Items[7].SubItems[1]:=FormatDateTime('dd.mm.yyyy hh:mm:ss', Data.TimeBegin)
 else lvParams.Items[7].SubItems[1]:='?';
 if Data.TimeEnd<>0
 then lvParams.Items[8].SubItems[1]:=FormatDateTime('dd.mm.yyyy hh:mm:ss', Data.TimeEnd)
 else lvParams.Items[8].SubItems[1]:='?';
 if Data.TimeTotal<>0
 then lvParams.Items[9].SubItems[1]:=FormatDateTime('hh:mm:ss', Data.TimeTotal)
 else lvParams.Items[9].SubItems[1]:='?';
 if Data.Speed>0
 then lvParams.Items[10].SubItems[1]:=IntToStr(Data.Speed)
 else lvParams.Items[10].SubItems[1]:='?';
 lvParams.Items[11].SubItems[1]:=Data.ErrorText;
 lvParams.Items[12 ].SubItems[1]:=Data.Description;
end;

procedure TfMain.tvFoldersChange(Sender: TObject; Node: TTreeNode);
var
 i: integer;
 Data: TTask;
 SortStatus: TTaskStatus;
 SortDate: TDate;
begin
 if (Node.Level=0) or (Node<>tvFolders.Selected)
 then Exit;
 lvTasks.Items.Clear;
 SortStatus:=tsReady;
 SortDate:=0;
 if (Node.Level=1) and (Node.Index=0)
 then
  begin
   for i:=0 to Options.Task.Count-1 do
    begin
     Data:=Options.Task[i];
     if Data.Status=tsLoad
     then InsertItem(Data);
    end;
  end;
 if (Node.Level=1) and (Node.Index=1)
 then
  begin
   for i:=0 to Options.Task.Count-1 do
    begin
     Data:=Options.Task[i];
     if (Data.Status<>tsDelete) and (Data.Status<>tsDeleted)
     then InsertItem(Data);
    end;
  end;
 if (Node.Parent.Level=1) and (Node.Parent.Index=1)
 then
  begin
   case Node.Index of
    0: SortStatus:=tsReady;
    1: SortStatus:=tsLoad;
    2: SortStatus:=tsLoading;
    3: SortStatus:=tsStoped;
    4: SortStatus:=tsError;
   end;
  for i:=0 to Options.Task.Count-1 do
   begin
    Data:=Options.Task[i];
    if Data.Status=SortStatus
    then InsertItem(Data);
   end;
  end;
 if (Node.Level=1) and (Node.Index=3)
 then
  begin
   for i:=0 to Options.Task.Count-1 do
    begin
     Data:=Options.Task[i];
     if Data.Status=tsDeleted
     then InsertItem(Data);
    end;
  end;
 if (Node.Parent.Level=1) and (Node.Parent.Index=2)
 then
  begin
   if (Node.Index=0) or (Node.Index=1)
   then
    begin
     case Node.Index of
       0: SortDate:=Date;
       1: SortDate:=Date-1;
     end;
   for i:=0 to Options.Task.Count-1 do
    begin
     Data:=Options.Task[i];
     if (SameDate(Data.TimeEnd, SortDate)) and (Data.Status=tsLoad)
     then InsertItem(Data);
    end;
  end;
 if (Node.Index=2) or (Node.Index=3)
 then
  begin
   case Node.Index of
     2: SortDate:=Now-8;
     3: SortDate:=Now-31;
   end;
   for i:=0 to Options.Task.Count-1 do
    begin
     Data:=Options.Task[i];
     if (Data.TimeEnd>SortDate) and (Data.Status=tsLoad)
     then InsertItem(Data);
    end;
   end;
  end;
end;

procedure TfMain.actStopExecute(Sender: TObject);
begin
 if not Assigned(lvTasks.Selected)
 then Exit;
 if TTask(lvTasks.Selected.Data).Status=tsLoading
 then TTask(lvTasks.Selected.Data).Status:=tsStoped;
end;

procedure TfMain.OnDrawClipboard(var Message : TMessage);
begin
 if Options.HookClipboard
 then
  begin
   if Clipboard.HasFormat(CF_TEXT)
   then
    begin
     if (Pos('http://', Trim(Clipboard.AsText))=1)
      or (Pos('https://', Trim(Clipboard.AsText))=1)
      or (Pos('ftp://', Trim(Clipboard.AsText))=1)
     then
      begin
       SetForegroundWindow(fMain.Handle);
       fAddTask:=TfAddTask.Create(Application);
       fAddTask.ShowModal;
      end;
    end;
  end;
 Message.Result:=SendMessage(WM_DRAWCLIPBOARD, NextViewerHandle, 0, 0);
end;

procedure TfMain.OnChangeCBCHain(var Message: TMessage);
begin
 if Message.wParam=Integer(NextViewerHandle)
 then
  begin
   NextViewerHandle:=Message.lParam;
   Message.Result:=0;
  end
 else Message.Result:=SendMessage(NextViewerHandle, WM_CHANGECBCHAIN, Message.wParam, Message.lParam);
end;

procedure TfMain.TrayIconClick(Sender: TObject);
begin
 SetForegroundWindow(Handle);
end;

procedure TfMain.lvTasksCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
 if Item.Index mod 2=0
 then
  begin
   Sender.Canvas.Font.Color:=clBlack;
   Sender.Canvas.Brush.Color:=$F6F6F6;
  end
 else
  begin
   Sender.Canvas.Font.Color:=clBlack;
   Sender.Canvas.Brush.Color:=clWhite;
  end;
end;

procedure TfMain.actClearDelExecute(Sender: TObject);
var
 i: integer;
begin
 if MessageBox(Application.Handle, 'Вы действительно хотите очистить папку "Удаленные"?', PChar(Options.Name), MB_OKCANCEL or MB_ICONWARNING)=ID_OK
 then
  begin
   for i:=0 to Options.Task.Count-1 do
    begin
     if TTask(Options.Task[i]).Status=tsDeleted
     then TTask(Options.Task[i]).Status:=tsDelete;
    end;
   lvTasks.Clear;
  end;
end;

procedure TfMain.InsertItem(P : Pointer);
var
 ListItem: TListItem;
 Data: TTask;
begin
 Data:=P;
 ListItem:=lvTasks.Items.Insert(0);
 ListItem.SubItems.Add(Data.LinkToFile);
 if Data.TotalSize>0
 then ListItem.SubItems.Add(BytesToText(Data.TotalSize))
 else ListItem.SubItems.Add('?');
 ListItem.SubItems.Add(BytesToText(Data.LoadSize));
 if Data.TotalSize>0
 then ListItem.SubItems.Add(FloatToStrF((Data.LoadSize/Data.TotalSize)*100, ffFixed, 18, 0))
 else ListItem.SubItems.Add('?');
 if Data.Speed>0
 then ListItem.SubItems.Add(BytesToText(Data.Speed)+'/c')
 else ListItem.SubItems.Add('?');
 ListItem.ImageIndex:=1;
 ListItem.Data:=Data;
end;

procedure TfMain.actEditExecute(Sender: TObject);
begin
 if lvTasks.SelCount=0
 then Exit;
 fEditTask:=TfEditTask.Create(Application);
 fEditTask.Data:=lvTasks.Selected.Data;
 fEditTask.ShowModal;
end;

procedure TfMain.actAboutExecute(Sender: TObject);
begin
 fAbout:=TfAbout.Create(Application);
 fAbout.ShowModal;
end;

procedure TfMain.Panel2Resize(Sender: TObject);
var
 i: integer;
begin
 if lvParams.Width>400
 then
  begin
   if lvParams.Height<240
   then i:=40
   else i:=24;
   lvParams.Columns[2].Width:=lvParams.Width-lvParams.Columns[1].Width-i;
  end;
end;

procedure TfMain.Panel1Resize(Sender: TObject);
var
 i: integer;
begin
 if lvTasks.Width>500
 then
  begin
   if lvTasks.Height<lvTasks.Items.Count*16
   then i:=40
   else i:=24;
   lvTasks.Columns[1].Width:=lvTasks.Width-lvTasks.Columns[2].Width - lvTasks.Columns[3].Width  - lvTasks.Columns[4].Width-lvTasks.Columns[5].Width-i;
  end;
end;

procedure TfMain.actAddCategoryExecute(Sender: TObject);
begin
 fAddCategory:=TfAddCategory.Create(Application);
 fAddCategory.ShowModal;
end;

procedure TfMain.lvTasksKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
 if Key=VK_DELETE
 then actDeleteExecute(nil);
end;

procedure TfMain.actDeleteCategoryExecute(Sender: TObject);
begin
 if MessageBox(Application.Handle, PChar('Вы действительно хотите удалить папку "' + tvFolders.Selected.Text + '"?'), PChar(Options.Name), MB_OKCANCEL or MB_ICONWARNING)=ID_OK
 then tvFolders.Selected.Delete;
end;

procedure TfMain.actEditCategoryExecute(Sender: TObject);
begin
 fEditCategory:=TfEditCategory.Create(Application);
 fEditCategory.ShowModal;
end;

procedure TfMain.tmUpdateTimer(Sender: TObject);
begin
 UpdateItems;
end;

procedure TfMain.N17Click(Sender: TObject);
begin
 SetForegroundWindow(Handle);
end;

procedure TfMain.RefreshTasks;
var
 Data: TTask;
 i: integer;
begin
 for i:=0 to lvTasks.Items.Count-1 do
  begin
   Data:=lvTasks.Items[i].Data;
   if Data.TotalSize>0
   then lvTasks.Items[i].SubItems[1]:=BytesToText(Data.TotalSize)
   else lvTasks.Items[i].SubItems[1]:='?';
   lvTasks.Items[i].SubItems[2]:=BytesToText(Data.LoadSize);
   if Data.TotalSize>0
   then lvTasks.Items[i].SubItems[3]:=FloatToStrF((Data.LoadSize/Data.TotalSize)*100, ffFixed, 18, 0)
   else lvTasks.Items[i].SubItems[3]:='?';
   if Data.Speed>0
   then lvTasks.Items[i].SubItems[4]:=BytesToText(Data.Speed)+'/с'
   else lvTasks.Items[i].SubItems[4]:='?';
  end;
end;

procedure TfMain.SaveTreeNode(Node : TTreeNode);
var
 i: integer;
begin
 for i:=0 to Node.Count-1 do
  begin
   ShowMessage(Node.Item[i].Text);
   SaveTreeNode(Node.Item[i]);
  end;
end;

procedure TfMain.actOpenFolderExecute(Sender: TObject);
begin
 if not Assigned(lvTasks.Selected)
 then Exit;
 ShellExecute(0, 'open',	PChar(TTask(lvTasks.Selected.Data).Directory), '', '', SW_SHOWNORMAL);
end;

procedure TfMain.actOpenFileExecute(Sender: TObject);
begin
 if not Assigned(lvTasks.Selected)
 then Exit;
 ShellExecute(0, 'open',	PChar(TTask(lvTasks.Selected.Data).Directory + '\' + TTask(lvTasks.Selected.Data).FileName), '', '', SW_SHOWNORMAL);
end;

end.

