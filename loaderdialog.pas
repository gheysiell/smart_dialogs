unit LoaderDialog;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs,
  SDLoaderDialogForm, SDMyThread;

type
  TSlowProcess = procedure of object;

type
  TLoaderDialog = class(TComponent)
  private
    FVisible: Boolean;
    FSlowProcess: TSlowProcess;
    procedure SetVisible(AValue: Boolean);
    procedure ShowLoaderDialog(Form: TForm);
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
  SDfunctions;

constructor TLoaderDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FVisible := False;
end;

procedure TLoaderDialog.SetVisible(AValue: Boolean);
var
  ParentForm: TForm;
begin
  if FVisible = AValue then Exit;
  FVisible := AValue;

  ParentForm := SDfunctions.GetParentForm(Owner);

  if FVisible then
    ShowLoaderDialog(ParentForm)
  else
    frLoaderDialog.Close();
end;

procedure TLoaderDialog.ShowLoaderDialog(Form: TForm);
var
  CenterLeft: Integer=0;
  CenterTop: Integer=0;
begin
  SDfunctions.ShowSDBackgroundFullScreen(Form);

  if not Assigned(frLoaderDialog) then
    frLoaderDialog := TfrLoaderDialog.Create(Application);

  frLoaderDialog.Position := poDesigned;

  SDfunctions.GetFormCenters(
      Form,
      frLoaderDialog,
      CenterLeft,
      CenterTop
  );

  frLoaderDialog.Left := CenterLeft;
  frLoaderDialog.Top := CenterTop;

  frLoaderDialog.FormStyle := fsStayOnTop;
  frLoaderDialog.Show;

  frLoaderDialog.BringToFront;

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
