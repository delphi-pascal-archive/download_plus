unit uDownload;

interface

uses
  Classes, uThreads, uObjects, uProcedures;

type

// Class TLoadOne //

TLoadOne = class(TThread)
  public
    constructor Create(CreateSuspended : Boolean; P : Pointer);
  private
    Data : TTask;
  protected
    procedure Execute; override;
end;

implementation

uses uMain;

constructor TLoadOne.Create(CreateSuspended : Boolean; P : Pointer);
begin
 Data:=P;
 inherited Create(CreateSuspended);
end;

procedure TLoadOne.Execute;
var
 ThreadHttp: TGetFileHttp;
 ThreadHttpOpt: TGetOptionsHttp;
 ThreadFtp: TGetFileFtp;
 ThreadFtpOpt: TGetOptionsFtp;
begin
 if (Data.Protocol=ptHttp) or (Data.Protocol=ptHttps)
 then
  begin
   ThreadHttpOpt:=TGetOptionsHttp.Create(True, Data);
   ThreadHttpOpt.Priority:=Options.Priority;
   ThreadHttpOpt.Resume;
   ThreadHttpOpt.WaitFor;
   ThreadHttpOpt.Free;
   if Data.Status=tsError
   then Exit;
   if (Data.TotalSize<0) and not (Options.ResumeLoad)
   then Exit;
   if Data.TotalSize>0
   then
    begin
     if Data.TotalSize>GetFreeSpace(Data.Directory)
     then Exit;
    end;
   ThreadHttp:=TGetFileHttp.Create(true, Data);
   ThreadHttp.Priority:=Options.Priority;
   ThreadHttp.Resume;
   ThreadHttp.WaitFor;
   ThreadHttp.Free;
  end;

 if Data.Protocol=ptFtp
 then
  begin
   ThreadFtpOpt:=TGetOptionsFtp.Create(True, Data);
   ThreadFtpOpt.Priority:=Options.Priority;
   ThreadFtpOpt.Resume;
   ThreadFtpOpt.WaitFor;
   ThreadFtpOpt.Free;
   if Data.Status=tsError
   then Exit;
   if Data.TotalSize>0
   then
    begin
     if Data.TotalSize>GetFreeSpace(Data.Directory)
     then Exit;
    end;
   ThreadFtp:=TGetFileFtp.Create(True, Data);
   ThreadFtp.Priority:=Options.Priority;
   ThreadFtp.Resume;
   ThreadFtp.WaitFor;
   ThreadFtp.Free;
  end;
 fMain.tmUpdate.Enabled:=false;
 fMain.RefreshTasks;
end;

end.
