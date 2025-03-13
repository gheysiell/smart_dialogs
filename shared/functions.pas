unit functions;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, BackgroundFullScreen,
  loader_dialog;

procedure ShowLoaderDialog();
procedure ShowBackgroundFullScreen();
procedure CloseBackgroundFullScreen();

implementation

procedure ShowLoaderDialog;
begin
  ShowBackgroundFullScreen();

  if not Assigned(frLoaderDialog) then
    frLoaderDialog := TfrLoaderDialog.Create(Application);

  frLoaderDialog.FormStyle := fsStayOnTop;
  frLoaderDialog.Show;
  frLoaderDialog.BringToFront;
end;

procedure ShowBackgroundFullScreen();
begin
  if not Assigned(frmBackgroundFullScreen) then
    frmBackgroundFullScreen := TfrmBackgroundFullScreen.Create(Application);

  frmBackgroundFullScreen.Show;
  frmBackgroundFullScreen.BringToFront;
end;

procedure CloseBackgroundFullScreen();
begin
  if Assigned(BackgroundFullScreen.frmBackgroundFullScreen) then
  begin
    BackgroundFullScreen.frmBackgroundFullScreen.Close;
    BackgroundFullScreen.frmBackgroundFullScreen.Free;
    BackgroundFullScreen.frmBackgroundFullScreen := nil;
  end;
end;

end.
