unit LoaderDialog;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs,
  functions, loader_dialog;

procedure ShowLoaderDialog();

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
end;

procedure ShowLoaderDialog;
begin
  functions.ShowBackgroundFullScreen();

  if not Assigned(frLoaderDialog) then
    frLoaderDialog := TfrLoaderDialog.Create(Application);

  frLoaderDialog.FormStyle := fsStayOnTop;
  frLoaderDialog.Show;
  frLoaderDialog.BringToFront;
end;

procedure Register;
begin
  {$I loaderdialog_icon.lrs}
  RegisterComponents('Smart Dialogs',[TLoaderDialog]);
end;

end.
