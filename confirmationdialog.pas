unit ConfirmationDialog;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs,
  SDConfirmationDialogForm, SDfunctions, SDenums, SDBackgroundFullScreen;

type
  TTypeMessage = SDenums.TTypeMessage;

type
  TOnConfirmation = procedure() of Object;
  TOnCanceled = procedure() of Object;

  TConfirmationDialog = class(TComponent)
    function Show(
      Title: String;
      SubTitle: String;
      TypeMessage: TTypeMessage      
    ): Boolean;
  private
    FVisible: Boolean;
    FFullScreen: Boolean;
    FMessage: String;
    FTypeMessage: TTypeMessage;
    FOnConfirmation: TOnConfirmation;
    FOnCanceled: TOnCanceled;
    procedure SetVisible(AValue: Boolean);
    procedure SetFullScreen(AValue: Boolean);
    procedure SetMessage(AValue: String);
    procedure SetTypeMessage(AValue: TTypeMessage);
  protected

  public
    constructor Create(AOwner: TComponent); override;
  published
    property Visible: Boolean read FVisible write SetVisible default False;
    property FullScreen: Boolean read FFullScreen write SetFullScreen default False;
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
  FFullScreen := False;
  FMessage := 'Tem certeza que deseja realizar essa operação ?';
  TypeMessage := TTypeMessage.tmWarning;
end;

procedure TConfirmationDialog.SetVisible(AValue: Boolean);
begin
  FVisible := AValue;

  if (csDesigning in ComponentState) then
    Exit;  

  if FVisible then
    Show('Atenção', FMessage, FTypeMessage)
  else
    frConfirmationDialog.Close();
end;

procedure TConfirmationDialog.SetFullScreen(AValue: Boolean);
begin
  FFullScreen := AValue;
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

function TConfirmationDialog.Show(
  Title: string;
  SubTitle: string;
  TypeMessage: TTypeMessage
): Boolean;
var
  ResultConfirmation: Boolean;
  CenterLeft: Integer=0;
  CenterTop: Integer=0;
  Form: TForm;
begin
  Form := SDfunctions.GetParentForm(Owner);

  TfrmSDBackgroundFullScreen.ShowSDBackgroundFullScreen(Form, FFullScreen);

  if not Assigned(frConfirmationDialog) then
    frConfirmationDialog := TfrConfirmationDialog.Create(Form);

  frConfirmationDialog.lblTitle.Caption := Title;
  frConfirmationDialog.lblSubTitle.Caption := SubTitle;
  SDConfirmationDialogForm.typeMessage := TypeMessage;
  frConfirmationDialog.Position := poDesigned;

  SDfunctions.GetFormCenters(
    Form,
    frConfirmationDialog,
    CenterLeft,
    CenterTop
  );

  frConfirmationDialog.Left := CenterLeft;
  frConfirmationDialog.Top := CenterTop;

  frConfirmationDialog.ShowModal;

  if Assigned(Form) then
    Form.BringToFront;

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
