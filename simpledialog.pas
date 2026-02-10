unit SimpleDialog;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, SDfunctions,
  SDenums, SDBackgroundFullScreen, SDLoaderContext;

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
    FSyncSubTitle: String;
    FSyncTypeMessage: TTypeMessage;
    FCalledFromLoader: Boolean;

    procedure SetVisible(AValue: Boolean);
    procedure SetFullScreen(AValue: Boolean);
    procedure SetTypeMessage(AValue: TTypeMessage);
    procedure SetMessage(AValue: String);
    procedure SyncShow;
    procedure InternalShow(
      SubTitle: string;
      TypeMessage: TTypeMessage
    );
  protected

  public
    constructor Create(AOwner: TComponent); override;
  published
    property Visible: Boolean read FVisible write SetVisible default False;
    property FullScreen: Boolean read FFullScreen write SetFullScreen default False;
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
  FTypeMessage := AValue;
end;

procedure TSimpleDialog.SetMessage(AValue: String);
begin
  FMessage := AValue;
end;

procedure TSimpleDialog.Show(
  SubTitle: string;
  TypeMessage: TTypeMessage
);
begin
  if ((TThread.CurrentThread.ThreadID <> MainThreadID) and (SDLoaderContext.IsInsideLoader))then
  begin
    FCalledFromLoader := True;
    FSyncSubTitle := SubTitle;
    FSyncTypeMessage := TypeMessage;
    TThread.Synchronize(nil, @SyncShow);
  end
  else
  begin
    FCalledFromLoader := False;
    InternalShow(SubTitle, TypeMessage);
  end;
end;

procedure TSimpleDialog.SyncShow;
begin
  InternalShow(FSyncSubTitle, FSyncTypeMessage);
end;

procedure TSimpleDialog.InternalShow(
  SubTitle: string;
  TypeMessage: TTypeMessage
);
var
  CenterTop: Integer = 0;
  CenterLeft: Integer = 0;
  ParentForm: TForm;
begin
  ParentForm := SDfunctions.GetParentForm(Owner);

  if not FCalledFromLoader then
    TfrmSDBackgroundFullScreen.ShowSDBackgroundFullScreen(ParentForm, FFullScreen);

  if not Assigned(frSimpleDialog) then
    frSimpleDialog := TfrSimpleDialog.Create(ParentForm);

  frSimpleDialog.lblSubTitle.Caption := SubTitle;
  frSimpleDialog.FullScreen := FFullScreen;
  frSimpleDialog.CalledFromLoader := FCalledFromLoader;

  SDSimpleDialogForm.typeMessage := TypeMessage;

  SDfunctions.GetFormCenters(
    FullScreen,
    ParentForm,
    frSimpleDialog,
    CenterLeft,
    CenterTop
  );

  frSimpleDialog.Left := CenterLeft;
  frSimpleDialog.Top := CenterTop;

  frSimpleDialog.ShowModal;
end;

procedure Register;
begin
  {$I simpledialog_icon.lrs}
  RegisterComponents('Smart Dialogs',[TSimpleDialog]);
end;

end.
