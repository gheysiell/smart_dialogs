unit LoaderDialog;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, Math,
  SDLoaderDialogForm, SDMyThread, SDBackgroundFullScreen;

type
  TSlowProcess = procedure of object;

type
  TLoaderDialog = class(TComponent)
    procedure Show;
  private
    FVisible: Boolean;
    FFullScreen: Boolean;
    FSlowProcess: TSlowProcess;
    FMessage: String;
    procedure SetVisible(AValue: Boolean);
    procedure SetFullScreen(AValue: Boolean);
    procedure CloseLoader;
    procedure SetMessage(AValue: String);
  protected

  public
    constructor Create(AOwner: TComponent); override;
    property SlowProcess: TSlowProcess read FSlowProcess write FSlowProcess;
  published
    property Visible: Boolean read FVisible write SetVisible default False;
    property FullScreen: Boolean read FFullScreen write SetFullScreen default False;
    property Message: String read FMessage write SetMessage;
  end;

procedure Register;

implementation

uses
  SDfunctions;

constructor TLoaderDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FVisible := False;
  Message := '';
end;

procedure TLoaderDialog.SetVisible(AValue: Boolean);
begin
  FVisible := AValue;

  Application.ProcessMessages;

  if FVisible then
    Show()
  else
    frLoaderDialog.Close();
end;

procedure TLoaderDialog.SetFullScreen(AValue: Boolean);
begin
  FFullScreen := AValue;
end;

procedure TLoaderDialog.SetMessage(AValue: String);
begin
  FMessage := AValue;
end;

procedure TLoaderDialog.Show;
var
  CenterLeft: Integer=0;
  CenterTop: Integer=0;
  Form: TForm;
begin
  Form := SDfunctions.GetParentForm(Owner);

  TfrmSDBackgroundFullScreen.ShowSDBackgroundFullScreen(Form, FFullScreen);

  if not Assigned(frLoaderDialog) then
    frLoaderDialog := TfrLoaderDialog.Create(Form);

  frLoaderDialog.lblMessage.Caption := FMessage;
  frLoaderDialog.Position := poDesigned;
  frLoaderDialog.FullScreen := FFullScreen;

  SDfunctions.GetFormCenters(
    Form,
    frLoaderDialog,
    CenterLeft,
    CenterTop
  );

  frLoaderDialog.Left := CenterLeft;
  frLoaderDialog.Top := IfThen(
    FFullScreen,
    CenterTop,
    CenterTop - Trunc(SDFunctions.GetTaskBarHeight div 2)
  );

  frLoaderDialog.Show;

  if Assigned(Form) then
    Form.BringToFront;

  if Assigned(FSlowProcess) then
    TSDMyThread.Create(FSlowProcess, @CloseLoader);
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
