unit SimpleDialog;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, SDfunctions,
  SDenums, SDBackgroundFullScreen, Math;

type
  TTypeMessage = SDenums.TTypeMessage;

type
  TSimpleDialog = class(TComponent)
    procedure Show(
      SubTitle: String;
      TypeMessage: TTypeMessage      
    );
  private
    FVisible: Boolean;
    FFullScreen: Boolean;
    FTypeMessage: TTypeMessage;
    FMessage: String;    
    procedure SetVisible(AValue: Boolean);
    procedure SetFullScreen(AValue: Boolean);
    procedure SetTypeMessage(AValue: TTypeMessage);
    procedure SetMessage(AValue: String);
  protected

  public
    constructor Create(AOwner: TComponent); override;
  published
    property Visible: Boolean read FVisible write SetVisible default False;
    property FullScreen: Boolean read FFullScreen write SetFUllScreen default False;
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
  FFullScreen := False;
  Message := 'Olá';
  TypeMessage := TTypeMessage.tmInfo;
end;

procedure TSimpleDialog.SetVisible(AValue: Boolean);
begin
  FVisible := AValue;

  if (csDesigning in ComponentState) then
    Exit;

  if FVisible then
    Show(FMessage, FTypeMessage)
  else if Assigned(frSimpleDialog) then
    frSimpleDialog.Close();
end;

procedure TSimpleDialog.SetFullScreen(AValue: Boolean);
begin
  FFullScreen := AValue;
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

procedure TSimpleDialog.Show(
  SubTitle: string;
  TypeMessage: TTypeMessage  
);
var
  CenterLeft: Integer=0;
  CenterTop: Integer=0;
  Form: TForm;
begin
  Form := SDfunctions.GetParentForm(Owner);

  TfrmSDBackgroundFullScreen.ShowSDBackgroundFullScreen(Form, FFullScreen);

  if not Assigned(frSimpleDialog) then
    frSimpleDialog := TfrSimpleDialog.Create(Form);

  frSimpleDialog.lblSubTitle.Caption := SubTitle;
  frSimpleDialog.Position := poDesigned;
  frSimpleDialog.FullScreen := FFullScreen;

  SDSimpleDialogForm.typeMessage := TypeMessage;

  SDfunctions.GetFormCenters(
    Form,
    frSimpleDialog,
    CenterLeft,
    CenterTop
  );

  frSimpleDialog.Left := CenterLeft;
  frSimpleDialog.Top := IfThen(
    FFullScreen,
    CenterTop,
    CenterTop - Trunc(SDFunctions.GetTaskBarHeight div 2)
  );

  frSimpleDialog.ShowModal;

  if Assigned(Form) then
    Form.BringToFront;
end;

procedure Register;
begin
  {$I simpledialog_icon.lrs}
  RegisterComponents('Smart Dialogs',[TSimpleDialog]);
end;

end.
