unit uProcedures;

interface

uses
  SysUtils, Windows, ShellAPI, ShlObj;
  
function BytesToText(Bytes : Integer) : String;
function GetFileVersion(FileName : String) : String;
function BrowserFolder(Owner : THandle) : String;
function CreateFileName(Url : String) : String;
function LocalAddress(Url : String) : Boolean;
function ExtractAddress(Url : String) : String;
function ExtractFileName(Url : String) : String;
function GetFreeSpace(Disk : String) : Int64;
function IsRun : Boolean;
function GetTimeStr(Secs : Integer) : String;

implementation

////////////////////////////////////////////////////////////////////////////////

function BytesToText(Bytes : integer) : String;
begin

  if Bytes div 1000 < 1 then Result := IntToStr(Bytes) + ' байт';

  if Bytes div 1000 >= 1 then Result := FloatToStrF(Bytes/1000, ffNumber, 18, 1) + ' Кб';

  if Bytes div 1000 >= 1000 then Result := FloatToStrF(Bytes/1000000, ffNumber, 18, 1) + ' Мб';

end;

////////////////////////////////////////////////////////////////////////////////

function GetFileVersion(FileName : String) : String;
var
  Data : Pointer;
  DataSize, InfoSize : Dword;
  Dummy : Cardinal;
  Buffer: array [0..MAX_PATH] of Char;
  Major1, Major2, Minor1, Minor2 : Integer;
  FileInfo : PVSFixedFileInfo;

begin

  StrCat(Buffer, PChar(FileName));
  DataSize := GetFileVersionInfoSize(Buffer, Dummy);

  if DataSize > 0 then
  begin

    GetMem(Data, DataSize);
    GetFileVersionInfo(Buffer, 0, DataSize, Data);
    VerQueryValue(Data, '\', Pointer(FileInfo), InfoSize);

    Major1 := FileInfo.dwFileVersionMS shr 16;
    Major2 := FileInfo.dwFileVersionMS and $FFFF;
    Minor1 := FileInfo.dwFileVersionLS shr 16;
    Minor2 := FileInfo.dwFileVersionLS and $FFFF;

    Result := IntToStr(Major1) + '.' + IntToStr(Major2) + '.' + IntToStr(Minor1) + ' build ' + IntToStr(Minor2);

    FreeMem(Data, DataSize);

  end;

end;

////////////////////////////////////////////////////////////////////////////////

function BrowserFolder(Owner : THandle) : String;
var
  TitleName   : String;
  lpItemID    : PItemIDList;
  BrowseInfo  : TBrowseInfo;
  DisplayName : Array [0..MAX_PATH] of char;
  TempPath    : Array [0..MAX_PATH] of char;

begin

  FillChar(BrowseInfo, SizeOf(TBrowseInfo), #0);

  BrowseInfo.hwndOwner := Owner;
  BrowseInfo.pszDisplayName := @DisplayName;

  TitleName := 'Выберите директорию';

  BrowseInfo.lpszTitle := PChar(TitleName);
  BrowseInfo.ulFlags := BIF_RETURNONLYFSDIRS;

  lpItemID := SHBrowseForFolder(BrowseInfo);

  if lpItemId <> nil then
  begin

    SHGetPathFromIDList(lpItemID, TempPath);
    GlobalFreePtr(lpItemID);

    Result := TempPath;

  end else
  begin

    Result := '';

  end;

end;

////////////////////////////////////////////////////////////////////////////////

function CreateFileName(Url : String) : String;
var
  i : Integer;

begin

  Result := '';

  if Pos('//', Url) > 0 then Delete(Url, 1, Pos('//', Url) + 1);

  if Url = '' then Exit;
  
  if Pos('/', Url) > 0 then Delete(Url, 1, Pos('/', Url))
  else Delete(Url, 1, Length(Url));

  if Url = '' then
  begin

    Result := 'index.html';
    Exit;

  end;

  if Url[Length(Url)] <> '/' then
  begin

    i := Length(Url);

    repeat

      i := i - 1;

    until Url[i] = '/';

    Result := Copy(Url, i + 1, Length(Url) - i);

  end else Result := 'index.html';

end;

////////////////////////////////////////////////////////////////////////////////

function LocalAddress(Url : String) : Boolean;
begin

  Result := False;

  if Pos('//', Url) > 0 then Delete(Url, 1, Pos('//', Url) + 1);
  if Pos('/', Url) > 0 then Delete(Url, Pos('/', Url), Length(Url));

  if LowerCase(Url) = 'localhost' then Result := True;
  if LowerCase(Url) = '127.0.0.1' then Result := True;

end;

////////////////////////////////////////////////////////////////////////////////

function ExtractAddress(Url : String) : String;
begin

  if Pos('//', Url) > 0 then Delete(Url, 1, Pos('//', Url) + 1);
  if Pos('/', Url) > 0 then Delete(Url, Pos('/', Url), Length(Url));

  Result := Url;

end;

////////////////////////////////////////////////////////////////////////////////

function ExtractFileName(Url : String) : String;
begin

  if Pos('//', Url) > 0 then Delete(Url, 1, Pos('//', Url) + 1);
  if Pos('/', Url) > 0 then Delete(Url, 1, Pos('/', Url));

  Result := Url;

end;

////////////////////////////////////////////////////////////////////////////////

function GetFreeSpace(Disk : String) : Int64;
var
  TotalBytes     : Int64;
  TotalFreeBytes : PLargeInteger;
  FreeBytesCall  : Int64;

begin

  New(TotalFreeBytes);

  try

    GetDiskFreeSpaceEx(PChar(Disk), FreeBytesCall, TotalBytes, TotalFreeBytes);;
    Result := TotalFreeBytes^;

  finally

    Dispose(TotalFreeBytes);
    
  end;

end;

////////////////////////////////////////////////////////////////////////////////

function IsRun : Boolean;
var
  Mutex : integer;
  
begin

  Result := False;

  Mutex := CreateMutex(nil , True, 'BankClientServer');

  if GetLastError <> 0 then
  begin


    CloseHandle(Mutex);
    Result := True;

  end;

end;

////////////////////////////////////////////////////////////////////////////////

function GetTimeStr(Secs : Integer) : String;

  function LeadingZero(N:Integer) : String;
  begin

    if N < 10 then Result := '0' + IntToStr(N) else Result := IntToStr(N);
    
  end;

var
  Hours, Mins : Integer;

begin

  Hours := Secs div 3600;
  Secs  := Secs - Hours * 3600;
  Mins  := Secs div 60;
  Secs  := Secs - Mins * 60;

  Result := LeadingZero(Hours) + ':' + LeadingZero(Mins) + ':' + LeadingZero(Secs);

end;

end.
