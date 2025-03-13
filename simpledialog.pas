unit SimpleDialog;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, functions;

type
  TTypeOfMessage = (tmInfo, tmWarning, tmError);

procedure ShowAlertDialog(subTitle: String; typeOfMessage: TTypeOfMessage; AForm: TForm);

type
  TSimpleDialog = class(TComponent)
  private
    FVisible: Boolean;
    FTypeOfMessage: TTypeOfMessage;
    FMessage: String;
    procedure SetVisible(AValue: Boolean);
    procedure SetTypeOfMessage(AValue: TTypeOfMessage);
    procedure SetMessage(AValue: String);
  protected
    function GetParentForm: TForm;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Visible: Boolean read FVisible write SetVisible default False;
    property TypeOfMessage: TTypeOfMessage read FTypeOfMessage write SetTypeOfMessage default TTypeOfMessage.tmInfo;
    property Message: String read FMessage write SetMessage;
  end;

procedure Register;

implementation

uses
  simple_dialog;

constructor TSimpleDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FVisible := False;
  TypeOfMessage := TTypeOfMessage.tmInfo;
  Message := 'Olá';
end;

procedure TSimpleDialog.SetVisible(AValue: Boolean);
var
  ParentForm: TForm;
begin
  FVisible := AValue;

  ParentForm := GetParentForm;

  if FVisible then
    ShowAlertDialog(FMessage, FTypeOfMessage, ParentForm)
  else if Assigned(frSimpleDialog) then
    frSimpleDialog.Close();
end;

procedure TSimpleDialog.SetTypeOfMessage(AValue: TTypeOfMessage);
begin
  if FTypeOfMessage = AValue then Exit;
  FTypeOfMessage := AValue;
end;

procedure TSimpleDialog.SetMessage(AValue: String);
begin
  if FMessage = AValue then Exit;
  FMessage := AValue;
end;

function TSimpleDialog.GetParentForm: TForm;
begin
  Result := TForm(Owner);
end;

procedure ShowAlertDialog(subTitle: string; typeOfMessage: TTypeOfMessage; AForm: TForm);
begin
  ShowBackgroundFullScreen();

  if not Assigned(frSimpleDialog) then
    frSimpleDialog := TfrSimpleDialog.Create(Application);

  frSimpleDialog.lblSubTitle.Caption := subTitle;
  simple_dialog.typeOfMessage := typeOfMessage;

  simple_dialog.frSimpleDialog.ShowModal;

  if Assigned(AForm) then
    AForm.BringToFront;
end;

procedure Register;
begin
  {$I simpledialog_icon.lrs}
  RegisterComponents('Smart Dialogs',[TSimpleDialog]);
end;

end.
