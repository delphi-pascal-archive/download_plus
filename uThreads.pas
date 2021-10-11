unit uThreads;

interface

uses
  Classes, IdHTTP, IdFTP, IdComponent, IdFTPCommon, Windows, SysUtils, uObjects, Forms;

type

// Class TGetFileHttp //

TGetFileHttp = class(TThread)
  public
    Item   : Integer;
    Reload : Boolean;

    constructor Create(CreateSuspended : Boolean; P : Pointer);

  private
    Data      : TTask;
    Tick      : Integer;
    StartSize : Integer;
    HTTP      : TIdHTTP;

    procedure OnWork(Sender : TObject; AWorkMode : TWorkMode; const AWorkCount : Integer);
    procedure OnWorkBegin(Sender : TObject; AWorkMode : TWorkMode; const AWorkCountMax : Integer);
    procedure OnWorkEnd(Sender: TObject; AWorkMode: TWorkMode);

  protected
    procedure Execute; override;
end;

// Class TGetOptionsHttp //

TGetOptionsHttp = class(TThread)
  public
    constructor Create(CreateSuspended : Boolean; P : Pointer);

  private
    Data : TTask;

  protected
    procedure Execute; override;
end;

// Class TGetFileFtp //

TGetFileFtp = class(TThread)
  public
    Item   : Integer;
    Reload : Boolean;

    constructor Create(CreateSuspended : Boolean; P : Pointer);

  private
    Data : TTask;
    Tick : Integer;
    FTP  : TIdFTP;
    
    procedure OnWork(Sender : TObject; AWorkMode : TWorkMode; const AWorkCount : Integer);
    procedure OnWorkBegin(Sender : TObject; AWorkMode : TWorkMode; const AWorkCountMax : Integer);
    procedure OnWorkEnd(Sender: TObject; AWorkMode: TWorkMode);

  protected
    procedure Execute; override;
end;

// Class TGetOptionsFtp //

TGetOptionsFtp = class(TThread)
  public
    constructor Create(CreateSuspended : Boolean; P : Pointer);

  private
    Data : TTask;

  protected
    procedure Execute; override;
end;


implementation


uses uMain, uProcedures;

////////////////////////////////////////////////////////////////////////////////
//                            Class 'TGetFileHttp'                            //
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////

constructor TGetFileHttp.Create(CreateSuspended : Boolean; P : Pointer);
begin

  Data := P;

  inherited Create(CreateSuspended);

end;

////////////////////////////////////////////////////////////////////////////////

procedure TGetFileHttp.Execute;
var
  FileStream : TFileStream;

begin

  HTTP := TIdHTTP.Create(nil);

  if FileExists(Data.Directory + '\' + Data.FileName) then
  begin

    FileStream := TFileStream.Create(Data.Directory + '\' + Data.FileName, fmOpenReadWrite);
    FileStream.Position := FileStream.Size;

  end else
  begin

    FileStream := TFileStream.Create(Data.Directory + '\' + Data.FileName, fmCreate);

  end;

  HTTP.OnWork := OnWork;
  HTTP.OnWorkBegin := OnWorkBegin;
  HTTP.OnWorkEnd := OnWorkEnd;

  if Options.HTTPVersion = hvHttp10 then HTTP.ProtocolVersion := pv1_0 else HTTP.ProtocolVersion := pv1_1;

  if (Options.HTTPProxy.UseProxy) and (LocalAddress(Data.LinkToFile) = False) then
  begin

    HTTP.ProxyParams.ProxyServer := Options.HTTPProxy.Host;
    HTTP.ProxyParams.ProxyPort := Options.HTTPProxy.Port;
    HTTP.ProxyParams.ProxyUsername := Options.HTTPProxy.UserName;
    HTTP.ProxyParams.ProxyPassword := Options.HTTPProxy.Password;

  end;

  if Data.UseSpecial then
  begin

    HTTP.Port := Data.Port;

    HTTP.Request.Username := Data.Login;
    HTTP.Request.Password := Data.Password;
    
  end;

  HTTP.Request.ContentRangeStart := Data.LoadSize;
  HTTP.Request.ContentRangeEnd := Data.TotalSize;

  HTTP.HandleRedirects := Options.Redirect;

  StartSize := Data.LoadSize;

  try

    HTTP.Get(Data.LinkToFile, FileStream);

  except

    on E : Exception do
    begin

      Data.Status := tsError;
      Data.ErrorText := E.Message;

      MessageBox(Application.Handle, PChar('Ошибка при загрузке файла.' + #13#10 + E.Message), PChar(Options.Name), MB_OK or MB_ICONERROR);

    end;

  end;
  
  HTTP.Free;
  FileStream.Free;
  
end;

////////////////////////////////////////////////////////////////////////////////

procedure TGetFileHttp.OnWork(Sender: TObject; AWorkMode: TWorkMode; const AWorkCount: Integer);
var
  TickCount : Integer;
  Count     : Integer;

begin

  if AWorkMode = wmRead then
  begin

    Data.LoadSize := StartSize + AWorkCount;

    TickCount := GetTickCount;
    Count := (TickCount - Tick) div 1000;

    if (Data.LoadSize > 0) and (Count > 0) then Data.Speed := Data.LoadSize div Count;

  end;

  if Data.Status = tsStoped then HTTP.Disconnect;
  
end;

////////////////////////////////////////////////////////////////////////////////

procedure TGetFileHttp.OnWorkBegin(Sender : TObject; AWorkMode : TWorkMode; const AWorkCountMax : Integer);
begin

  Tick := GetTickCount;

  Data.TimeBegin := Now;
  Data.Status := tsLoading;

end;

////////////////////////////////////////////////////////////////////////////////

procedure TGetFileHttp.OnWorkEnd(Sender: TObject; AWorkMode: TWorkMode);
begin

  Data.TimeEnd := Now;
  Data.TimeTotal := Data.TimeBegin - Data.TimeEnd;

  if Data.Status <> tsStoped then Data.Status := tsLoad;

end;

////////////////////////////////////////////////////////////////////////////////
//                             'TGetOptionsHttp'                              //
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////

constructor TGetOptionsHttp.Create(CreateSuspended : Boolean; P : Pointer);
begin

  Data := P;

  inherited Create(CreateSuspended);

end;

////////////////////////////////////////////////////////////////////////////////

procedure TGetOptionsHttp.Execute;
var
  HTTP : TIdHTTP;

begin

  HTTP := TIdHTTP.Create(nil);

  if (Options.HTTPProxy.UseProxy) and (LocalAddress(Data.LinkToFile) = False) then
  begin

    HTTP.ProxyParams.ProxyServer := Options.HTTPProxy.Host;
    HTTP.ProxyParams.ProxyPort := Options.HTTPProxy.Port;
    HTTP.ProxyParams.ProxyUsername := Options.HTTPProxy.UserName;
    HTTP.ProxyParams.ProxyPassword := Options.HTTPProxy.Password;

  end;

  if Data.UseSpecial then
  begin

    HTTP.Port := Data.Port;
    HTTP.Request.Username := Data.Login;
    HTTP.Request.Password := Data.Password;

  end;

  HTTP.HandleRedirects := Options.Redirect;

  if Options.HTTPVersion = hvHttp10 then HTTP.ProtocolVersion := pv1_0 else HTTP.ProtocolVersion := pv1_1;
  
  try

    HTTP.Head(Data.LinkToFile);

    Data.Status := tsReady;
    Data.ErrorText := 'Ошибок нет';

    Data.TotalSize := HTTP.Response.ContentLength;
    Data.LastModified := HTTP.Response.LastModified;

  except

    on E : Exception do
    begin

      Data.Status := tsError;
      Data.ErrorText := E.Message;

      Data.TotalSize := 0;
      Data.LastModified := 0;

      MessageBox(Application.Handle, PChar('Ошибка при загрузке файла.' + #13#10 + E.Message), PChar(Options.Name), MB_OK or MB_ICONERROR);

    end;

  end;

  HTTP.Free;

  fMain.RefreshTasks;

end;

////////////////////////////////////////////////////////////////////////////////
//                            Class 'TGetFileFtp'                             //
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////

constructor TGetFileFtp.Create(CreateSuspended : Boolean; P : Pointer);
begin

  Data := P;

  inherited Create(CreateSuspended);

end;

////////////////////////////////////////////////////////////////////////////////

procedure TGetFileFtp.Execute;
begin

  FTP := TIdFTP.Create(nil);

  FTP.OnWork := OnWork;
  FTP.OnWorkBegin := OnWorkBegin;
  FTP.OnWorkEnd := OnWorkEnd;

  if (Options.FTPProxy.UseProxy) and (LocalAddress(Data.LinkToFile) = False) then
  begin

    FTP.ProxySettings.Host := Options.FTPProxy.Host;
    FTP.ProxySettings.Port := Options.FTPProxy.Port;
    FTP.ProxySettings.Username := Options.FTPProxy.UserName;
    FTP.ProxySettings.Password := Options.FTPProxy.Password;

  end;

  if Data.UseSpecial then
  begin

    FTP.Port := Data.Port;
    FTP.Username := Data.Login;
    FTP.Password := Data.Password;

  end else FTP.Username := 'anonymous';

  try

    FTP.TransferType := ftBinary;
    FTP.Host := ExtractAddress(Data.LinkToFile);
    FTP.Connect;
    FTP.Get(ExtractFileName(Data.LinkToFile), Data.Directory + '\' + Data.FileName, False, True);
    FTP.Disconnect;

    Data.Status := tsReady;
    Data.ErrorText := 'Ошибок нет';

  except

    on E : Exception do
    begin

      Data.Status := tsError;
      Data.ErrorText := E.Message;

      MessageBox(Application.Handle, PChar('Ошибка при загрузке файла.' + #13#10 + E.Message), PChar(Options.Name), MB_OK or MB_ICONERROR);

    end;

  end;
  
  FTP.Free;
  
end;

////////////////////////////////////////////////////////////////////////////////

procedure TGetFileFtp.OnWork(Sender: TObject; AWorkMode: TWorkMode; const AWorkCount: Integer);
var
  TickCount : Integer;
  Count     : Integer;

begin

  if AWorkMode = wmRead then
  begin

    Data.LoadSize := AWorkCount;

    TickCount := GetTickCount;
    Count := (TickCount - Tick) div 1000;

    if (Data.LoadSize > 0) and (Count > 0) then Data.Speed := Data.LoadSize div Count;

  end;

  if Data.Status = tsStoped then FTP.Disconnect;

end;

////////////////////////////////////////////////////////////////////////////////

procedure TGetFileFtp.OnWorkBegin(Sender : TObject; AWorkMode : TWorkMode; const AWorkCountMax : Integer);
begin

  Tick := GetTickCount;

  Data.TimeBegin := Now;
  Data.Status := tsLoading;

end;

////////////////////////////////////////////////////////////////////////////////

procedure TGetFileFtp.OnWorkEnd(Sender: TObject; AWorkMode: TWorkMode);
begin

  Data.TimeEnd := Now;
  Data.TimeTotal := Data.TimeBegin - Data.TimeEnd;

  if Data.Status <> tsStoped then Data.Status := tsLoad;

end;

////////////////////////////////////////////////////////////////////////////////
//                             'TGetOptionsFtp'                               //
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////

constructor TGetOptionsFtp.Create(CreateSuspended : Boolean; P : Pointer);
begin

  Data := P;

  inherited Create(CreateSuspended);

end;

////////////////////////////////////////////////////////////////////////////////

procedure TGetOptionsFtp.Execute;
var
  FTP : TIdFTP;
  Details : TStrings;

begin

  FTP := TIdFTP.Create(nil);
  Details := TStringList.Create;

  if (Options.FTPProxy.UseProxy) and (LocalAddress(Data.LinkToFile) = False) then
  begin

    FTP.ProxySettings.Host := Options.FTPProxy.Host;
    FTP.ProxySettings.Port := Options.FTPProxy.Port;
    FTP.ProxySettings.Username := Options.FTPProxy.UserName;
    FTP.ProxySettings.Password := Options.FTPProxy.Password;

  end;

  if Data.UseSpecial then
  begin

    FTP.Port := Data.Port;
    FTP.Username := Data.Login;
    FTP.Password := Data.Password;

  end else FTP.Username := 'anonymous';


  try

    FTP.TransferType := ftBinary;
    FTP.Host := ExtractAddress(Data.LinkToFile);
    FTP.Connect;

    FTP.List(Details, ExtractFileName(Data.LinkToFile), True);
    Data.TotalSize := FTP.DirectoryListing.Items[0].Size;
    Data.LastModified := FTP.DirectoryListing.Items[0].ModifiedDate;
    
    FTP.Disconnect;

    Data.Status := tsReady;
    Data.ErrorText := 'Ошибок нет';

  except

    on E : Exception do
    begin

      Data.Status := tsError;
      Data.ErrorText := E.Message;

      Data.TotalSize := 0;
      Data.LastModified := 0;
      
      MessageBox(Application.Handle, PChar('Ошибка при загрузке файла.' + #13#10 + E.Message), PChar(Options.Name), MB_OK or MB_ICONERROR);

    end;

  end;

  FTP.Free;
  Details.Free;

  fMain.RefreshTasks;
  
end;

end.
