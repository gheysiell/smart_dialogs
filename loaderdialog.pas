unit LoaderDialog;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs,
  BackgroundFullScreen, loader_dialog;

procedure ShowLoaderDialog();
procedure ShowBackgroundFullScreen();
procedure CloseBackgroundFullScreen();

type
  TLoaderDialog = class(TComponent)
  private
    FVisible: Boolean;
    procedure SetVisible(AValue: Boolean);
  protected

  public
    constructor Create(AOwner: TComponent); override;
  published
    property Visible: Boolean read FVisible write SetVisible default False;
  end;

procedure Register;

implementation

constructor TLoaderDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FVisible := False;
end;

procedure TLoaderDialog.SetVisible(AValue: Boolean);
begin
  if FVisible = AValue then Exit;
  FVisible := AValue;

  if FVisible then
    ShowLoaderDialog()
  else
    frLoaderDialog.Close();

  //Invalidate;
end;

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

procedure Register;
begin
  {$I loaderdialog_icon.lrs}
  RegisterComponents('Smart Dialogs',[TLoaderDialog]);
end;

end.
