unit SDLoaderDialogForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, LCLType, Math,
  LCLIntf, LCLProc, StdCtrls, BCFluentProgressRing, SDBackgroundFullScreen;

type

  { TfrLoaderDialog }

  TfrLoaderDialog = class(TForm)
    Loader: TBCFluentProgressRing;
    lblMessage: TLabel;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CloseLoader();
    procedure RestoreOwnerFocus(Data: PtrInt);
  private
    FOwnerForm: TForm;
    FFullScreen: Boolean;

    procedure SetRoundedCorners(Radius: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    property FullScreen: Boolean read FFullScreen write FFullScreen;

    procedure Recenter;
  end;

var
  frLoaderDialog: TfrLoaderDialog;

implementation

uses
  SDfunctions;

{$R *.lfm}

constructor TfrLoaderDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if AOwner is TForm then
    FOwnerForm := TForm(AOwner);
end;

procedure TfrLoaderDialog.FormShow(Sender: TObject);
var
  InitialHeight: Integer=0;
begin
  if Trim(lblMessage.Caption) = '' then
    Loader.Top := 64
  else
    Loader.Top := 40;

  lblMessage.Height := SDfunctions.GetLabelHeight(lblMessage);
  frLoaderDialog.Height := 230;
  frLoaderDialog.Height := frLoaderDialog.Height + lblMessage.Height - 30;

  SetRoundedCorners(50);
  Recenter;
end;

procedure TfrLoaderDialog.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  TfrmSDBackgroundFullScreen.closeSDBackgroundFullScreen();

  CloseAction := caFree;
  frLoaderDialog := nil;

  if Assigned(FOwnerForm) then
    Application.QueueAsyncCall(@RestoreOwnerFocus, PtrInt(FOwnerForm));  
end;

procedure TfrLoaderDialog.FormResize(Sender: TObject);
begin
  lblMessage.Left := (ClientWidth - lblMessage.Width) div 2;
end;

procedure TfrLoaderDialog.RestoreOwnerFocus(Data: PtrInt);
var
  TargetForm: TCustomForm;
begin
  TargetForm := SDfunctions.GetTopMostModalForm(Self);

  if not Assigned(TargetForm) then
    TargetForm := Application.MainForm;

  if Assigned(TargetForm) then
  begin
    TargetForm.BringToFront;
    TargetForm.SetFocus;
  end;
end;

procedure TfrLoaderDialog.SetRoundedCorners(Radius: Integer);
var
  Rgn: HRGN;
begin
  Rgn := CreateRoundRectRgn(0, 0, Width + 1, Height + 1, Radius, Radius);
  SetWindowRgn(Handle, Rgn, True);
end;

procedure TfrLoaderDialog.CloseLoader;
begin
  ModalResult := mrOK;
end;

procedure TfrLoaderDialog.Recenter;
var
  CenterLeft, CenterTop: Integer;
  ParentForm: TForm;
begin
  ParentForm := SDfunctions.GetParentForm(Owner);

  SDfunctions.GetFormCenters(
    FullScreen,
    Self,
    CenterLeft,
    CenterTop
  );

  Left := CenterLeft;
  Top := CenterTop;
end;

end.

