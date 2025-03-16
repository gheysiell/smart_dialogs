unit LoaderDialog;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs,
  LoaderDialogForm, MyThread;

type
  TSlowProcess = procedure of object;

type
  TLoaderDialog = class(TComponent)
  private
    FVisible: Boolean;
    FSlowProcess: TSlowProcess;
    procedure SetVisible(AValue: Boolean);
    procedure ShowLoaderDialog;
    procedure CloseLoader;
  protected

  public
    constructor Create(AOwner: TComponent); override;
    property SlowProcess: TSlowProcess read FSlowProcess write FSlowProcess;
  published
    property Visible: Boolean read FVisible write SetVisible default False;
  end;

procedure Register;

implementation

uses
  functions;

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

procedure TLoaderDialog.ShowLoaderDialog;
begin
  functions.ShowBackgroundFullScreen();

  if not Assigned(frLoaderDialog) then
    frLoaderDialog := TfrLoaderDialog.Create(Application);

  frLoaderDialog.FormStyle := fsStayOnTop;
  frLoaderDialog.Show;
  frLoaderDialog.BringToFront;

  if Assigned(FSlowProcess) then
    TMyThread.Create(FSlowProcess, @CloseLoader);
end;

procedure TLoaderDialog.CloseLoader;
begin
  SetVisible(False);
end;


procedure Register;
begin
  {$I loaderdialog_icon.lrs}
  RegisterComponents('Smart Dialogs',[TLoaderDialog]);
end;

end.
