unit MyThread;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TSlowProcess = procedure of object;
  TThreadFinished = procedure of object;

  TMyThread = class(TThread)
  private
    FSlowProcess: TSlowProcess;
    FOnFinished: TThreadFinished;
  protected
    procedure Execute; override;
    procedure DoOnFinished;
  public
    constructor Create(ASlowProcess: TSlowProcess; AOnFinished: TThreadFinished);
  end;

implementation

constructor TMyThread.Create(ASlowProcess: TSlowProcess; AOnFinished: TThreadFinished);
begin
  inherited Create(True);
  FSlowProcess := ASlowProcess;
  FOnFinished := AOnFinished;
  FreeOnTerminate := True;
  Start;
end;

procedure TMyThread.Execute;
begin
  if Assigned(FSlowProcess) then
    FSlowProcess();

  Synchronize(@DoOnFinished);
end;

procedure TMyThread.DoOnFinished;
begin
  if Assigned(FOnFinished) then
    FOnFinished();
end;

end.

