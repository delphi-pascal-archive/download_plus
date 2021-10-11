unit uObjects;

interface

uses
  Classes, XMLDoc, XMLIntf, SysUtils, Windows, ComCtrls, Menus;

type

// Class TTaskStatus //

TTaskStatus = (tsReady, tsError, tsLoad, tsLoading, tsStoped, tsDelete, tsDeleted);

// Class THTTPVersion //

THTTPVersion = (hvHttp10, hvHttp11);

// Class TProtocol //

TProtocolType = (ptHttp, ptHttps, ptFtp);

// Class TCategory //

TCategory = record
  Name      : String;
  Directory : String;
  Extension : String;
end;

// Class TProxy //

TProxy = record
  Host     : String;
  Port     : Integer;
  UserName : String;
  Password : String;
  UseProxy : Boolean;
end;

// Class TTask //

TTask = class(TObject)
  public
    LinkToFile    : String;
    FileName      : String;
    Directory     : String;
    TotalSize     : Integer;
    LoadSize      : Integer;
    StartPosition : Integer;
    EndPosition   : Integer;
    Login         : String;
    Password      : String;
    Port          : Integer;
    LastModified  : TDateTime;
    TimeBegin     : TDateTime;
    TimeEnd       : TDateTime;
    TimeTotal     : TDateTime;
    ScheduleOn    : Boolean;
    Speed         : Integer;
    Status        : TTaskStatus;
    Protocol      : TProtocolType;
    UseSpecial    : Boolean;
    ErrorText     : String;
    Category      : String;
    Description   : String;
end;

// Class TOptions //

TOptions = class(TObject)
  public
    Name      : String;
    Version   : String;
    Path      : String;
    AgentName : String;
    ShowLoadingForm      : Boolean;
    AutoCloseLoadingForm : Boolean;
    HookClipboard        : Boolean;
    RunWithWindows : Boolean;
    MinToTray      : Boolean;
    MinOnRun       : Boolean;
    AlwaysInTray   : Boolean;
    UseProxyLocal  : Boolean;
    ResumeLoad     : Boolean;
    HTTPVersion    : THTTPVersion;
    Redirect  : Boolean;
    Priority  : TThreadPriority;
    HotKey    : TShortCut;
    HTTPProxy : TProxy;
    FTPProxy  : TProxy;
    Url       : TStrings;
    Directory : TStrings;
    Task      : TList;
    
    procedure Save;
    procedure Load;
end;


var
  Options : TOptions;


implementation


uses uMain;


////////////////////////////////////////////////////////////////////////////////
//                               Class 'TOptions'                             //
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////

procedure TOptions.Save;
var
  Xml    : TXMLDocument;
  Parent : IXMLNode;
  Child  : IXMLNode;
  Value  : IXMLNode;
  i, n   : Integer;
  Data   : TTask;

begin

  Xml := TXMLDocument.Create(nil);
  Xml.Active := True;

  if Xml.IsEmptyDoc then Xml.DocumentElement := Xml.CreateElement('XMLOptions', '');

  Xml.DocumentElement.Attributes['Name'] := Options.Name;
  Xml.DocumentElement.Attributes['Version'] := Options.Version;

  Parent := Xml.DocumentElement.AddChild('Options');
  Child := Parent.AddChild('AgentName');
  Child.Text := AgentName;
  Child := Parent.AddChild('ShowLoadingForm');
  Child.Text := BoolToStr(ShowLoadingForm);
  Child := Parent.AddChild('AutoCloseLoadingForm');
  Child.Text := BoolToStr(AutoCloseLoadingForm);
  Child := Parent.AddChild('HookClipboard');
  Child.Text := BoolToStr(HookClipboard);
  Child := Parent.AddChild('MinToTray');
  Child.Text := BoolToStr(MinToTray);
  Child := Parent.AddChild('AlwaysInTray');
  Child.Text := BoolToStr(AlwaysInTray);
  Child := Parent.AddChild('MinOnRun');
  Child.Text := BoolToStr(MinOnRun);
  Child := Parent.AddChild('RunWithWindows');
  Child.Text := BoolToStr(RunWithWindows);
  Child := Parent.AddChild('UseProxyLocal');
  Child.Text := BoolToStr(UseProxyLocal);
  Child := Parent.AddChild('Redirect');
  Child.Text := BoolToStr(Redirect);
  Child := Parent.AddChild('ThreadPriority');
  Child.Text := IntToStr(Integer(Priority));
  Child := Parent.AddChild('HotKey');
  Child.Text := ShortCutToText(HotKey);
  Child := Parent.AddChild('HTTPVersion');
  Child.Text := IntToStr(Integer(HTTPVersion));
  Child := Parent.AddChild('ResumeLoad');
  Child.Text := BoolToStr(ResumeLoad);

  Parent := Xml.DocumentElement.AddChild('MainForm');
  Child := Parent.AddChild('MainWindowTop');
  Child.Text := IntToStr(fMain.Top);
  Child := Parent.AddChild('MainWindowLeft');
  Child.Text := IntToStr(fMain.Left);
  Child := Parent.AddChild('MainWindowHeight');
  Child.Text := IntToStr(fMain.Height);
  Child := Parent.AddChild('MainWindowWidth');
  Child.Text := IntToStr(fMain.Width);
  Child := Parent.AddChild('CategoryPanelWidth');
  Child.Text := IntToStr(fMain.Panel3.Width);
  Child := Parent.AddChild('TasksPanelHeight');
  Child.Text := IntToStr(fMain.Panel1.Height);
  Child := Parent.AddChild('ParamsVisible');
  Child.Text := BoolToStr(fMain.actParams.Checked);
  Child := Parent.AddChild('StatusBarVisible');
  Child.Text := BoolToStr(fMain.actStatusBar.Checked);
  Child := Parent.AddChild('TasksColumn1Width');
  Child.Text := IntToStr(fMain.lvTasks.Columns[1].Width);
  Child := Parent.AddChild('TasksColumn2Width');
  Child.Text := IntToStr(fMain.lvTasks.Columns[2].Width);
  Child := Parent.AddChild('TasksColumn3Width');
  Child.Text := IntToStr(fMain.lvTasks.Columns[3].Width);
  Child := Parent.AddChild('TasksColumn4Width');
  Child.Text := IntToStr(fMain.lvTasks.Columns[4].Width);
  Child := Parent.AddChild('TasksColumn5Width');
  Child.Text := IntToStr(fMain.lvTasks.Columns[5].Width);
  Child := Parent.AddChild('ParamsColumn1Width');
  Child.Text := IntToStr(fMain.lvParams.Columns[1].Width);
  Child := Parent.AddChild('ParamsColumn2Width');
  Child.Text := IntToStr(fMain.lvParams.Columns[2].Width);
  Child := Parent.AddChild('SelectedTreeItem');

  if Assigned(fMain.tvFolders.Selected) then Child.Text := IntToStr(fMain.tvFolders.Selected.AbsoluteIndex) else Child.Text := '0';

  Parent := Xml.DocumentElement.AddChild('Proxy');

  Child := Parent.AddChild('HTTPProxy');

  Value := Child.AddChild('Host');
  Value.Text := HTTPProxy.Host;
  Value := Child.AddChild('Port');
  Value.Text := IntToStr(HTTPProxy.Port);
  Value := Child.AddChild('User');
  Value.Text := HTTPProxy.UserName;
  Value := Child.AddChild('Password');
  Value.Text := HTTPProxy.Password;
  Value := Child.AddChild('UseProxy');
  Value.Text := BoolToStr(HTTPProxy.UseProxy);

  Child := Parent.AddChild('FTPProxy');

  Value := Child.AddChild('Host');
  Value.Text := FTPProxy.Host;
  Value := Child.AddChild('Port');
  Value.Text := IntToStr(FTPProxy.Port);
  Value := Child.AddChild('User');
  Value.Text := FTPProxy.UserName;
  Value := Child.AddChild('Password');
  Value.Text := FTPProxy.Password;
  Value := Child.AddChild('UseProxy');
  Value.Text := BoolToStr(FTPProxy.UseProxy);

  if Url <> nil then
  begin

    Parent := Xml.DocumentElement.AddChild('Url');

    if Url.Count > 15 then n := 15 else n := Url.Count - 1;

    for i := 0 to n do
    begin

      Child := Parent.AddChild('Url');
      Child.Text := Url.Strings[i];

    end;

  end;

  if Directory <> nil then
  begin

    Parent := Xml.DocumentElement.AddChild('Directory');

    if Directory.Count > 15 then n := 15 else n := Directory.Count - 1;

    for i := 0 to n do
    begin

      Child := Parent.AddChild('Directory');
      Child.Text:= Directory.Strings[i];

    end;

  end;

  if Task <> nil then
  begin

    Parent := Xml.DocumentElement.AddChild('Tasks');

    for i := 0 to Task.Count - 1 do
    begin

      Data := Task.Items[i];

      if Data.Status <> tsDelete then
      begin

        Child := Parent.AddChild('Task');

        Value := Child.AddChild('LinkToFile');
        Value.Text := Data.LinkToFile;
        Value := Child.AddChild('FileName');
        Value.Text := Data.FileName;
        Value := Child.AddChild('Directory');
        Value.Text := Data.Directory;
        Value := Child.AddChild('TotalSize');
        Value.Text := IntToStr(Data.TotalSize);
        Value := Child.AddChild('LoadSize');
        Value.Text := IntToStr(Data.LoadSize);
        Value := Child.AddChild('StartPosition');
        Value.Text := IntToStr(Data.StartPosition);
        Value := Child.AddChild('EndPosition');
        Value.Text := IntToStr(Data.EndPosition);
        Value := Child.AddChild('Login');
        Value.Text := Data.Login;
        Value := Child.AddChild('Password');
        Value.Text := Data.Password;
        Value := Child.AddChild('Port');
        Value.Text := IntToStr(Data.Port);
        Value := Child.AddChild('LastModified');
        Value.Text := DateTimeToStr(Data.LastModified);
        Value := Child.AddChild('TimeBegin');
        Value.Text := DateTimeToStr(Data.TimeBegin);
        Value := Child.AddChild('TimeEnd');
        Value.Text := DateTimeToStr(Data.TimeEnd);
        Value := Child.AddChild('TimeTotal');
        Value.Text := DateTimeToStr(Data.TimeTotal);
        Value := Child.AddChild('ScheduleOn');
        Value.Text := BoolToStr(Data.ScheduleOn);
        Value := Child.AddChild('Speed');
        Value.Text := IntToStr(Data.Speed);
        Value := Child.AddChild('Status');
        Value.Text := IntToStr(Integer(Data.Status));
        Value := Child.AddChild('Protocol');
        Value.Text := IntToStr(Integer(Data.Protocol));
        Value := Child.AddChild('UseSpecial');
        Value.Text := BoolToStr(Data.UseSpecial);
        Value := Child.AddChild('ErrorText');
        Value.Text := Data.ErrorText;
        Value := Child.AddChild('Category');
        Value.Text := Data.Category;
        Value := Child.AddChild('Description');
        Value.Text := Data.Description;

      end;

    end;

  end;

  Xml.SaveToFile(Options.Path + '\' + Options.Name + '.xml');
  Xml.Free;

end;

////////////////////////////////////////////////////////////////////////////////

procedure TOptions.Load;
var
  Xml    : IXMLDocument;
  Parent : IXMLNode;
  Child  : IXMLNode;
  Value  : IXMLNode;
  i      : Integer;
  Data   : TTask;

begin

  Url := TStringList.Create;
  Directory := TStringList.Create;
  Task := TList.Create;

  if not FileExists(Options.Path + '\' + Options.Name + '.xml') then Exit;

  Xml := TXMLDocument.Create(nil);
  Xml.Active := True;
  Xml.LoadFromFile(Options.Path + '\' + Options.Name + '.xml');

  Parent := Xml.DocumentElement.ChildNodes['Options'];
  Child := Parent.ChildNodes['AgentName'];
  AgentName := Child.Text;
  Child := Parent.ChildNodes['ShowLoadingForm'];
  ShowLoadingForm := StrToBool(Child.Text);
  Child := Parent.ChildNodes['AutoCloseLoadingForm'];
  AutoCloseLoadingForm := StrToBool(Child.Text);
  Child := Parent.ChildNodes['HookClipboard'];
  HookClipboard := StrToBool(Child.Text);
  Child := Parent.ChildNodes['MinToTray'];
  MinToTray := StrToBool(Child.Text);
  Child := Parent.ChildNodes['MinOnRun'];
  MinOnRun := StrToBool(Child.Text);
  Child := Parent.ChildNodes['AlwaysInTray'];
  AlwaysInTray := StrToBool(Child.Text);
  Child := Parent.ChildNodes['RunWithWindows'];
  RunWithWindows := StrToBool(Child.Text);
  Child := Parent.ChildNodes['UseProxyLocal'];
  UseProxyLocal := StrToBool(Child.Text);
  Child := Parent.ChildNodes['Redirect'];
  Redirect := StrToBool(Child.Text);
  Child := Parent.ChildNodes['HotKey'];
  HotKey := TextToShortCut(Child.Text);
  Child := Parent.ChildNodes['ThreadPriority'];
  Priority := TThreadPriority(StrToInt(Child.Text));
  Child := Parent.ChildNodes['HTTPVersion'];
  HTTPVersion := THTTPVersion(StrToInt(Child.Text));
  Child := Parent.ChildNodes['ResumeLoad'];
  ResumeLoad := StrToBool(Child.Text);

  Parent := Xml.DocumentElement.ChildNodes['MainForm'];
  Child := Parent.ChildNodes['MainWindowTop'];
  fMain.Top := StrToInt(Child.Text);
  Child := Parent.ChildNodes['MainWindowLeft'];
  fMain.Left := StrToInt(Child.Text);
  Child := Parent.ChildNodes['MainWindowHeight'];
  fMain.Height := StrToInt(Child.Text);
  Child := Parent.ChildNodes['MainWindowWidth'];
  fMain.Width := StrToInt(Child.Text);
  Child := Parent.ChildNodes['CategoryPanelWidth'];
  fMain.Panel3.Width := StrToInt(Child.Text);
  Child := Parent.ChildNodes['TasksPanelHeight'];
  fMain.Panel1.Height := StrToInt(Child.Text);
  Child := Parent.ChildNodes['ParamsVisible'];
  fMain.Panel3.Visible := StrToBool(Child.Text);
  Child := Parent.ChildNodes['StatusBarVisible'];
  fMain.StatusBar.Visible := StrToBool(Child.Text);
  Child := Parent.ChildNodes['TasksColumn1Width'];
  fMain.lvTasks.Columns[1].Width := StrToInt(Child.Text);
  Child := Parent.ChildNodes['TasksColumn2Width'];
  fMain.lvTasks.Columns[2].Width := StrToInt(Child.Text);
  Child := Parent.ChildNodes['TasksColumn3Width'];
  fMain.lvTasks.Columns[3].Width := StrToInt(Child.Text);
  Child := Parent.ChildNodes['TasksColumn4Width'];
  fMain.lvTasks.Columns[4].Width := StrToInt(Child.Text);
  Child := Parent.ChildNodes['TasksColumn5Width'];
  fMain.lvTasks.Columns[5].Width := StrToInt(Child.Text);
  Child := Parent.ChildNodes['ParamsColumn1Width'];
  fMain.lvParams.Columns[1].Width := StrToInt(Child.Text);
  Child := Parent.ChildNodes['ParamsColumn2Width'];
  fMain.lvParams.Columns[2].Width := StrToInt(Child.Text);
  Child := Parent.ChildNodes['SelectedTreeItem'];
  fMain.tvFolders.Items[StrToInt(Child.Text)].Selected := True;

  Parent := Xml.DocumentElement.ChildNodes['Proxy'];

  Child := Parent.ChildNodes[0];

  Value := Child.ChildNodes['Host'];
  HTTPProxy.Host := Value.Text;
  Value := Child.ChildNodes['Port'];
  HTTPProxy.Port := StrToInt(Value.Text);
  Value := Child.ChildNodes['User'];
  HTTPProxy.UserName := Value.Text;
  Value := Child.ChildNodes['Password'];
  HTTPProxy.Password := Value.Text;
  Value := Child.ChildNodes['UseProxy'];
  HTTPProxy.UseProxy := StrToBool(Value.Text);

  Child := Parent.ChildNodes[1];

  Value := Child.ChildNodes['Host'];
  FTPProxy.Host := Value.Text;
  Value := Child.ChildNodes['Port'];
  FTPProxy.Port := StrToInt(Value.Text);
  Value := Child.ChildNodes['User'];
  FTPProxy.UserName := Value.Text;
  Value := Child.ChildNodes['Password'];
  FTPProxy.Password := Value.Text;
  Value := Child.ChildNodes['UseProxy'];
  FTPProxy.UseProxy := StrToBool(Value.Text);

  Parent := Xml.DocumentElement.ChildNodes['Url'];

  for i := 0 to Parent.ChildNodes.Count - 1 do
  begin

    Child := Parent.ChildNodes[i];
    Url.Add(Child.Text);

  end;

  Parent := Xml.DocumentElement.ChildNodes['Directory'];

  for i := 0 to Parent.ChildNodes.Count - 1 do
  begin

    Child := Parent.ChildNodes[i];
    Directory.Add(Child.Text);

  end;

  Parent := Xml.DocumentElement.ChildNodes['Tasks'];

  for i := 0 to Parent.ChildNodes.Count - 1 do
  begin

    Data := TTask.Create;

    Child := Parent.ChildNodes[i];
    Value := Child.ChildNodes['LinkToFile'];
    Data.LinkToFile := Value.Text;
    Value := Child.ChildNodes['FileName'];
    Data.FileName := Value.Text;
    Value := Child.ChildNodes['Directory'];
    Data.Directory := Value.Text;
    Value := Child.ChildNodes['TotalSize'];
    Data.TotalSize := StrToInt(Value.Text);
    Value := Child.ChildNodes['LoadSize'];
    Data.LoadSize := StrToInt(Value.Text);
    Value := Child.ChildNodes['StartPosition'];
    Data.StartPosition := StrToInt(Value.Text);
    Value := Child.ChildNodes['EndPosition'];
    Data.EndPosition := StrToInt(Value.Text);
    Value := Child.ChildNodes['Login'];
    Data.Login := Value.Text;
    Value := Child.ChildNodes['Password'];
    Data.Password := Value.Text;
    Value := Child.ChildNodes['Port'];
    Data.Port := StrToInt(Value.Text);
    Value := Child.ChildNodes['LastModified'];
    Data.LastModified := StrToDateTime(Value.Text);
    Value := Child.ChildNodes['TimeBegin'];
    Data.TimeBegin := StrToDateTime(Value.Text);
    Value := Child.ChildNodes['TimeEnd'];
    Data.TimeEnd := StrToDateTime(Value.Text);
    Value := Child.ChildNodes['TimeTotal'];
    Data.TimeTotal := StrToDateTime(Value.Text);
    Value := Child.ChildNodes['ScheduleOn'];
    Data.ScheduleOn := StrToBool(Value.Text);
    Value := Child.ChildNodes['Speed'];
    Data.Speed := StrToInt(Value.Text);
    Value := Child.ChildNodes['Status'];
    Data.Status := TTaskStatus(StrToInt(Value.Text));
    Value := Child.ChildNodes['Protocol'];
    Data.Protocol := TProtocolType(StrToInt(Value.Text));
    Value := Child.ChildNodes['UseSpecial'];
    Data.UseSpecial := StrToBool(Value.Text);
    Value := Child.ChildNodes['ErrorText'];
    Data.ErrorText := Value.Text;
    Value := Child.ChildNodes['Category'];
    Data.Category := Value.Text;
    Value := Child.ChildNodes['Description'];
    Data.Description := Value.Text;

    Task.Add(Data);
    
  end;

  Xml := nil;

end;

end.
