unit ConfirmationDialog;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, SDfunctions,
  SDConfirmationDialogForm, SDenums, SDBackgroundFullScreen, SDLoaderContext;

type
  TTypeMessage = SDenums.TTypeMessage;

type
  TOnConfirmation = procedure() of Object;
  TOnCanceled = procedure() of Object;

  TConfirmationDialog = class(TComponent)
    function Show(
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
    FSyncSubTitle: String;
    FSyncTypeMessage: TTypeMessage;
    FSyncResult: Boolean;
    FCalledFromLoader: Boolean;

    procedure SetVisible(AValue: Boolean);
    procedure SetFullScreen(AValue: Boolean);
    procedure SetMessage(AValue: String);
    procedure SetTypeMessage(AValue: TTypeMessage);
    procedure SyncShow;
    function InternalShow(
      SubTitle: string;
      TypeMessage: TTypeMessage
    ): Boolean;
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
    Show(FMessage, FTypeMessage)
  else if Assigned(frConfirmationDialog) then
    frConfirmationDialog.Close();
end;

procedure TConfirmationDialog.SetFullScreen(AValue: Boolean);
begin
  FFullScreen := AValue;
end;

procedure TConfirmationDialog.SetTypeMessage(AValue: TTypeMessage);
begin
  FTypeMessage := AValue;
end;

procedure TConfirmationDialog.SetMessage(AValue: String);
begin
  FMessage := AValue;
end;

function TConfirmationDialog.Show(
  SubTitle: string;
  TypeMessage: TTypeMessage
): Boolean;
begin
  if ((TThread.CurrentThread.ThreadID <> MainThreadID) and (SDLoaderContext.IsInsideLoader)) then
  begin
    FCalledFromLoader := True;
    FSyncSubTitle := SubTitle;
    FSyncTypeMessage := TypeMessage;
    TThread.Synchronize(nil, @SyncShow);
    Result := FSyncResult;
  end
  else
  begin
    FCalledFromLoader := False;
    Result := InternalShow(SubTitle, TypeMessage)
  end;
end;

procedure TConfirmationDialog.SyncShow;
begin
  FSyncResult := InternalShow(FSyncSubTitle, FSyncTypeMessage);
end;

function TConfirmationDialog.InternalShow(
  SubTitle: string;
  TypeMessage: TTypeMessage
): Boolean;
var
  CenterLeft: Integer = 0;
  CenterTop: Integer = 0;
  ParentForm: TForm;
begin
  ParentForm := SDfunctions.GetParentForm(Owner);

  if not FCalledFromLoader then
    TSDBackgroundManager.PushBackground(ParentForm, FFullScreen);

  if not Assigned(frConfirmationDialog) then
    frConfirmationDialog := TfrConfirmationDialog.Create(ParentForm);

  frConfirmationDialog.lbSubTitle.Caption := SubTitle;
  frConfirmationDialog.FullScreen := FFullScreen;
  frConfirmationDialog.CalledFromLoader := FCalledFromLoader;

  SDConfirmationDialogForm.typeMessage := TypeMessage;

  SDfunctions.GetFormCenters(
    FullScreen,
    ParentForm,
    frConfirmationDialog,
    CenterLeft,
    CenterTop
  );

  frConfirmationDialog.Left := CenterLeft;
  frConfirmationDialog.Top := CenterTop;

  frConfirmationDialog.ShowModal;

  Result :=
    SDConfirmationDialogForm.CanceledOrConfirmed =
    TCanceledOrConfirmed.Confirmed;

  if Assigned(FOnConfirmation) and Result then
    FOnConfirmation();

  if Assigned(FOnCanceled) and (not Result) then
    FOnCanceled();

  ParentForm.BringToFront;
  ParentForm.SetFocus;    
end;

procedure Register;
begin
  {$I confirmationdialog_icon.lrs}
  RegisterComponents('Smart Dialogs',[TConfirmationDialog]);
end;

end.
