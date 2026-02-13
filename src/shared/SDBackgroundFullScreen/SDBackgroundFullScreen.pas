unit SDBackgroundFullScreen;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Math;

type

  { TfrmSDBackgroundFullScreen }

  TfrmSDBackgroundFullScreen = class(TForm)
  public
    constructor Create(AOwner: TComponent); override;

    class procedure ShowSDBackgroundFullScreen(FormRef: TForm; FullScreen: Boolean);
    class procedure CloseSDBackgroundFullScreen;
  end;

var
  frmSDBackgroundFullScreen: TfrmSDBackgroundFullScreen;

implementation

uses
  SDLoaderDialogForm, SDfunctions;

{$R *.lfm}

constructor TfrmSDBackgroundFullScreen.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

class procedure TfrmSDBackgroundFullScreen.ShowSDBackgroundFullScreen(FormRef: TForm; FullScreen: Boolean);
var
  AMonitor: TMonitor;
  TaskBarHeight: Integer;
begin
  if not Assigned(frmSDBackgroundFullScreen) then
    frmSDBackgroundFullScreen :=
      TfrmSDBackgroundFullScreen.Create(Application);

  if Assigned(FormRef) then
    AMonitor := Screen.MonitorFromWindow(FormRef.Handle)
  else
    AMonitor := Screen.PrimaryMonitor;

  TaskBarHeight := IfThen(FullScreen, 0, SDfunctions.GetTaskBarHeight);

  with frmSDBackgroundFullScreen do
  begin
    Left   := AMonitor.Left;
    Top    := AMonitor.Top;
    Width  := AMonitor.Width;
    Height := AMonitor.Height - TaskBarHeight;
    Show;
  end;
end;

class procedure TfrmSDBackgroundFullScreen.CloseSDBackgroundFullScreen;
begin
  if Assigned(frmSDBackgroundFullScreen) then
  begin
    frmSDBackgroundFullScreen.Hide;
  end;
end;

end.
