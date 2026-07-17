unit SDBackgroundFullScreen;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Math, Windows, Contnrs;

type

  { TfrSDBackgroundFullScreen }

  TfrSDBackgroundFullScreen = class(TForm)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  { TSDBackgroundManager }

  TSDBackgroundManager = class
  private
    class var FBackgroundStack: TObjectList;
    class function GetStack: TObjectList;
  public
    class procedure PushBackground(FormRef: TForm; FullScreen: Boolean);
    class procedure PopBackground;
    class procedure ClearAll;
    class procedure Finalize;
  end;

implementation

uses
  SDfunctions;

{$R *.lfm}

{ TSDBackgroundManager }

class function TSDBackgroundManager.GetStack: TObjectList;
begin
  if not Assigned(FBackgroundStack) then
    FBackgroundStack := TObjectList.Create(True);

  Result := FBackgroundStack;
end;

class procedure TSDBackgroundManager.PushBackground(FormRef: TForm; FullScreen: Boolean);
var
  AMonitor: TMonitor;
  TaskBarHeight: Integer;
  NewBG: TfrSDBackgroundFullScreen;
begin
  NewBG := TfrSDBackgroundFullScreen.Create(Application);

  if Assigned(FormRef) then
    AMonitor := Screen.MonitorFromWindow(FormRef.Handle)
  else
    AMonitor := Screen.PrimaryMonitor;

  TaskBarHeight := IfThen(FullScreen, 0, SDfunctions.GetTaskBarHeight);

  with NewBG do
  begin
    FormStyle := fsStayOnTop;
    Left      := AMonitor.Left;
    Top       := AMonitor.Top;
    Width     := AMonitor.Width;
    Height    := AMonitor.Height - TaskBarHeight;

    Show;
  end;

  GetStack.Add(NewBG);
end;

class procedure TSDBackgroundManager.PopBackground;
begin
  if (Assigned(FBackgroundStack)) and (FBackgroundStack.Count > 0) then
    FBackgroundStack.Delete(FBackgroundStack.Count - 1);
end;

class procedure TSDBackgroundManager.ClearAll;
begin
  if Assigned(FBackgroundStack) then
    FBackgroundStack.Clear;
end;

class procedure TSDBackgroundManager.Finalize;
begin
  if Assigned(FBackgroundStack) then
    FreeAndNil(FBackgroundStack);
end;

{ TfrSDBackgroundFullScreen }

constructor TfrSDBackgroundFullScreen.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Enabled := False;
end;

initialization

finalization
  TSDBackgroundManager.Finalize;

end.
