unit SDBackgroundFullScreen;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, SDLoaderDialogForm,
  Windows, ShellApi;

type

  { TfrmSDBackgroundFullScreen }

  TfrmSDBackgroundFullScreen = class(TForm)
    procedure FormClick(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    function GetTaskBarHeight: Integer;
  private

  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmSDBackgroundFullScreen: TfrmSDBackgroundFullScreen;

implementation

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
  begin
    RaiseLastOSError;
    Exit;
  end;

  Result := Rect.Bottom - Rect.Top;
end;

end.

