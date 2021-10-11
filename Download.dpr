program Download;

uses
  Forms,
  Windows,
  uMain in 'uMain.pas' {fMain},
  uAddTask in 'uAddTask.pas' {fAddTask},
  uObjects in 'uObjects.pas',
  uProcedures in 'uProcedures.pas',
  uOptions in 'uOptions.pas' {fOptions},
  uLoading in 'uLoading.pas' {fLoading},
  uThreads in 'uThreads.pas',
  uAddCategory in 'uAddCategory.pas' {fAddCategory},
  uEditTask in 'uEditTask.pas' {fEditTask},
  uAbout in 'uAbout.pas' {fAbout},
  uEditCategory in 'uEditCategory.pas' {fEditCategory},
  uDownload in 'uDownload.pas';

{$R *.res}

begin

  Application.Initialize;
  Application.Title := 'Download Plus';
  Application.CreateForm(TfMain, fMain);
  Application.Run;

end.
