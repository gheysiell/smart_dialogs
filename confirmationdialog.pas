unit ConfirmationDialog;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs,
  SDConfirmationDialogForm, SDfunctions, SDenums;

type
  TTypeMessage = SDenums.TTypeMessage;

type
  TOnConfirmation = procedure() of Object;
  TOnCanceled = procedure() of Object;

  TConfirmationDialog = class(TComponent)
    function ShowConfirmationDialog(title: String; subTitle: String; typeMessage: TTypeMessage; form: TForm): Boolean;
  private
    FVisible: Boolean;
    FMessage: String;
    FTypeMessage: TTypeMessage;
    FOnConfirmation: TOnConfirmation;
    FOnCanceled: TOnCanceled;
    procedure SetVisible(AValue: Boolean);
    procedure SetMessage(AValue: String);
    procedure SetTypeMessage(AValue: TTypeMessage);
  protected

  public
    constructor Create(AOwner: TComponent); override;
  published
    property Visible: Boolean read FVisible write SetVisible default False;
    property Message: String read FMessage write SetMessage;
    property TypeMessage: TTypeMessage read FTypeMessage write SetTypeMessage default TTypeMessage.tmWarning;
    property OnConfirmation: TOnConfirmation read FOnConfirmation write FOnConfirmation;
    property OnCanceled: TOnCanceled read FOnCanceled write FOnCanceled;
  end;

procedure Register;

implementation

constructor TConfirmationDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FVisible := False;
  FMessage := 'Tem certeza que deseja realizar essa operação ?';
  TypeMessage := TTypeMessage.tmWarning;
end;

procedure TConfirmationDialog.SetVisible(AValue: Boolean);
var
  ParentForm: TForm;
begin
  FVisible := AValue;

  if (csDesigning in ComponentState) then
    Exit;

  ParentForm := SDfunctions.GetParentForm(Owner);

  if FVisible then
    ShowConfirmationDialog('Atenção', FMessage, FTypeMessage, ParentForm)
  else
    frConfirmationDialog.Close();
end;

procedure TConfirmationDialog.SetTypeMessage(AValue: TTypeMessage);
begin
  if FTypeMessage = AValue then Exit;
  FTypeMessage := AValue;
end;

procedure TConfirmationDialog.SetMessage(AValue: String);
begin
  FMessage := AValue;
end;

function TConfirmationDialog.ShowConfirmationDialog(
  Title: string;
  SubTitle: string;
  TypeMessage: TTypeMessage;
  Form: TForm
): Boolean;
var
  ResultConfirmation: Boolean;
  CenterLeft, CenterTop: Integer;
begin
  SDfunctions.ShowSDBackgroundFullScreen(Form);

  if not Assigned(frConfirmationDialog) then
    frConfirmationDialog := TfrConfirmationDialog.Create(Application);

  frConfirmationDialog.lblTitle.Caption := Title;
  frConfirmationDialog.lblSubTitle.Caption := SubTitle;
  SDConfirmationDialogForm.typeMessage := TypeMessage;
  frConfirmationDialog.Position := poDesigned;

  SDfunctions.GetFormCenters(
      form,
      frConfirmationDialog,
      CenterLeft,
      CenterTop
  );

  frConfirmationDialog.Left := CenterLeft;
  frConfirmationDialog.Top := CenterTop;

  frConfirmationDialog.ShowModal;

  if Assigned(form) then
    form.BringToFront;

  ResultConfirmation := Ternary(SDConfirmationDialogForm.CanceledOrConfirmed = TCanceledOrConfirmed.Confirmed, True, False);

  if (Assigned(FOnConfirmation) AND ResultConfirmation) then
    FOnConfirmation();

  if (Assigned(FOnCanceled) AND (not ResultConfirmation)) then
    FOnCanceled();

  Result := ResultConfirmation;
end;

procedure Register;
begin
  {$I confirmationdialog_icon.lrs}
  RegisterComponents('Smart Dialogs',[TConfirmationDialog]);
end;

end.
