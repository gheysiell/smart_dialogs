unit ConfirmationDialog;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, functions,
  confirmation_dialog, enums;

type
  TTypeMessage = enums.TTypeMessage;

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
  FMessage := 'Tem certeza ?';
  TypeMessage := TTypeMessage.tmWarning;
end;

procedure TConfirmationDialog.SetVisible(AValue: Boolean);
var
  ParentForm: TForm;
begin
  FVisible := AValue;

  if (csDesigning in ComponentState) then
    Exit;

  ParentForm := functions.GetParentForm(Owner);

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

function TConfirmationDialog.ShowConfirmationDialog(title: string; subTitle: string; typeMessage: TTypeMessage; form: TForm): Boolean;
var
  ResultConfirmation: Boolean;
begin
  functions.ShowBackgroundFullScreen();

  if not Assigned(frConfirmationDialog) then
    frConfirmationDialog := TfrConfirmationDialog.Create(Application);

  confirmation_dialog.frConfirmationDialog.lblTitle.Caption := title;
  confirmation_dialog.frConfirmationDialog.lblSubTitle.Caption := subTitle;
  confirmation_dialog.typeMessage := typeMessage;

  confirmation_dialog.frConfirmationDialog.ShowModal;

  if Assigned(form) then
    form.BringToFront;

  ResultConfirmation := Ternary(confirmation_dialog.CanceledOrConfirmed = TCanceledOrConfirmed.Confirmed, True, False);

  if Assigned(FOnConfirmation) then
  begin
    if ResultConfirmation then
      FOnConfirmation()
    else
      FOnCanceled();
  end;
end;

procedure Register;
begin
  {$I confirmationdialog_icon.lrs}
  RegisterComponents('Smart Dialogs',[TConfirmationDialog]);
end;

end.
