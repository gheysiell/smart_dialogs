unit BackgroundFullScreen;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, LoaderDialogForm,
  Windows, ShellApi;

type

  { TfrmBackgroundFullScreen }

  TfrmBackgroundFullScreen = class(TForm)
    procedure FormClick(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    function GetTaskBarHeight: Integer;
  private

  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmBackgroundFullScreen: TfrmBackgroundFullScreen;

implementation

{$R *.lfm}

procedure TfrmBackgroundFullScreen.FormClick(Sender: TObject);
begin
  if Assigned(frLoaderDialog) then
    frLoaderDialog.BringToFront;
end;

procedure TfrmBackgroundFullScreen.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
    FormClick(Sender);
end;

constructor TfrmBackgroundFullScreen.Create(AOwner: TComponent);
var
  TaskbarHeight: Integer;
begin
  inherited Create(AOwner);
  BorderStyle := bsNone;
  FormStyle := fsStayOnTop;
  Color := clBlack;
  AlphaBlend := True;
  AlphaBlendValue := 128;

  TaskbarHeight := GetTaskBarHeight;

  SetBounds(0, 0, Screen.Width, Screen.Height - TaskbarHeight);
end;

function TfrmBackgroundFullScreen.GetTaskBarHeight: Integer;
var
  hTaskbar: HWND;
  Rect: TRect;
begin
  hTaskbar := FindWindow('Shell_TrayWnd', nil);

  if hTaskbar = 0 then
  begin
    RaiseLastOSError;
    Exit;
  end;

  if not GetWindowRect(hTaskbar, Rect) then
  begin
    RaiseLastOSError;
    Exit;
  end;

  Result := Rect.Bottom - Rect.Top;
end;

end.

