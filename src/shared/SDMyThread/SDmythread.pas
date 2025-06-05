unit SDMyThread;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TSlowProcess = procedure of object;
  TThreadFinished = procedure of object;

  TSDMyThread = class(TThread)
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

constructor TSDMyThread.Create(ASlowProcess: TSlowProcess; AOnFinished: TThreadFinished);
begin
  inherited Create(True);
  FSlowProcess := ASlowProcess;
  FOnFinished := AOnFinished;
  FreeOnTerminate := True;
  Start;
end;

procedure TSDMyThread.Execute;
begin
  if Assigned(FSlowProcess) then
    FSlowProcess();

  Synchronize(@DoOnFinished);
end;

procedure TSDMyThread.DoOnFinished;
begin
  if Assigned(FOnFinished) then
    FOnFinished();
end;

end.

