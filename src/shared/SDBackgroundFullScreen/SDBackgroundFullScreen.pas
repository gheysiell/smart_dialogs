unit SDBackgroundFullScreen;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
  Windows, ShellApi, Math;

type

  { TfrmSDBackgroundFullScreen }

  TfrmSDBackgroundFullScreen = class(TForm)
    procedure FormClick(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    function GetTaskBarHeight: Integer;
  public
    constructor Create(AOwner: TComponent); override;

    class procedure ShowSDBackgroundFullScreen(FormRef: TForm; FullScreen: Boolean);
    class procedure CloseSDBackgroundFullScreen;
  end;

var
  frmSDBackgroundFullScreen: TfrmSDBackgroundFullScreen;

implementation

uses
  SDLoaderDialogForm;

{$R *.lfm}

procedure TfrmSDBackgroundFullScreen.FormClick(Sender: TObject);
begin
  if Assigned(frLoaderDialog) then
    frLoaderDialog.BringToFront;
end;

procedure TfrmSDBackgroundFullScreen.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
    FormClick(Sender);
end;

constructor TfrmSDBackgroundFullScreen.Create(AOwner: TComponent);
var
  TaskbarHeight: Integer;
begin
  inherited Create(AOwner);

  BorderStyle := bsNone;
  Color := clBlack;
  AlphaBlend := True;
  AlphaBlendValue := 128;

  TaskbarHeight := GetTaskBarHeight;

  SetBounds(0, 0, Screen.Width, Screen.Height - TaskbarHeight);
end;

function TfrmSDBackgroundFullScreen.GetTaskBarHeight: Integer;
var
  hTaskbar: HWND;
  Rect: TRect;
begin
  hTaskbar := FindWindow('Shell_TrayWnd', nil);

  if hTaskbar = 0 then
    Exit(0);

  if not GetWindowRect(hTaskbar, Rect) then
    RaiseLastOSError;

  Result := Rect.Bottom - Rect.Top;
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

  TaskBarHeight := IfThen(FullScreen, 0,
    frmSDBackgroundFullScreen.GetTaskBarHeight);

  with frmSDBackgroundFullScreen do
  begin
    Left   := AMonitor.Left;
    Top    := AMonitor.Top;
    Width  := AMonitor.Width;
    Height := AMonitor.Height - TaskBarHeight;
    Show;
    BringToFront;
  end;
end;

class procedure TfrmSDBackgroundFullScreen.CloseSDBackgroundFullScreen;
begin
  if Assigned(frmSDBackgroundFullScreen) then
  begin
    frmSDBackgroundFullScreen.Close;
    FreeAndNil(frmSDBackgroundFullScreen);
  end;
end;

end.
