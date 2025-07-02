unit SimpleDialog;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, SDfunctions,
  SDenums;

type
  TTypeMessage = SDenums.TTypeMessage;

procedure ShowAlertDialog(
  SubTitle: String;
  TypeMessage: TTypeMessage;
  Form: TForm
);
type
  TSimpleDialog = class(TComponent)
  private
    FVisible: Boolean;
    FTypeMessage: TTypeMessage;
    FMessage: String;
    procedure SetVisible(AValue: Boolean);
    procedure SetTypeMessage(AValue: TTypeMessage);
    procedure SetMessage(AValue: String);
  protected

  public
    constructor Create(AOwner: TComponent); override;
  published
    property Visible: Boolean read FVisible write SetVisible default False;
    property TypeMessage: TTypeMessage read FTypeMessage write SetTypeMessage default TTypeMessage.tmInfo;
    property Message: String read FMessage write SetMessage;
  end;

procedure Register;

implementation

uses
  SDSimpleDialogForm;

constructor TSimpleDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FVisible := False;
  Message := 'Olá';
  TypeMessage := TTypeMessage.tmInfo;
end;

procedure TSimpleDialog.SetVisible(AValue: Boolean);
var
  ParentForm: TForm;
begin
  FVisible := AValue;

  if (csDesigning in ComponentState) then
    Exit;

  ParentForm := SDfunctions.GetParentForm(Owner);

  if FVisible then
    ShowAlertDialog(FMessage, FTypeMessage, ParentForm)
  else if Assigned(frSimpleDialog) then
    frSimpleDialog.Close();
end;

procedure TSimpleDialog.SetTypeMessage(AValue: TTypeMessage);
begin
  if FTypeMessage = AValue then Exit;
  FTypeMessage := AValue;
end;

procedure TSimpleDialog.SetMessage(AValue: String);
begin
  if FMessage = AValue then Exit;
  FMessage := AValue;
end;

procedure ShowAlertDialog(
  SubTitle: string;
  TypeMessage: TTypeMessage;
  Form: TForm
);
var
  CenterLeft, CenterTop: Integer;
begin
  SDfunctions.ShowSDBackgroundFullScreen(Form);

  if not Assigned(frSimpleDialog) then
    frSimpleDialog := TfrSimpleDialog.Create(Application);

  frSimpleDialog.lblSubTitle.Caption := SubTitle;
  SDSimpleDialogForm.typeMessage := TypeMessage;

  frSimpleDialog.Position := poDesigned;

  SDfunctions.GetFormCenters(
    form,
    frSimpleDialog,
    CenterLeft,
    CenterTop
  );

  frSimpleDialog.Left := CenterLeft;
  frSimpleDialog.Top := CenterTop;

  frSimpleDialog.ShowModal;

  if Assigned(form) then
    form.BringToFront;
end;

procedure Register;
begin
  {$I simpledialog_icon.lrs}
  RegisterComponents('Smart Dialogs',[TSimpleDialog]);
end;

end.
