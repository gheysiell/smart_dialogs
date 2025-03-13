unit BackgroundFullScreen;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, loader_dialog;

type

  { TfrmBackgroundFullScreen }

  TfrmBackgroundFullScreen = class(TForm)
    procedure FormClick(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
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
begin
  inherited Create(AOwner);
  BorderStyle := bsNone;
  FormStyle := fsStayOnTop;
  Color := clBlack;
  AlphaBlend := True;
  AlphaBlendValue := 128;
  SetBounds(0, 0, Screen.Width, Screen.Height);
end;

end.

