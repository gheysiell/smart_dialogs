unit SDLoaderDialogForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  LCLType, LCLIntf, LCLProc, BCFluentProgressRing;

type

  { TfrLoaderDialog }

  TfrLoaderDialog = class(TForm)
    BCFluentProgressRing1: TBCFluentProgressRing;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure CloseLoader();
    procedure RestoreOwnerFocus(Data: PtrInt);
  private
    FOwnerForm: TForm;

    procedure SetRoundedCorners(Radius: Integer);
  public
    constructor Create(AOwner: TComponent); override;
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
begin
  SetRoundedCorners(50);
end;

procedure TfrLoaderDialog.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  SDfunctions.closeSDBackgroundFullScreen();

  CloseAction := caFree;
  frLoaderDialog := nil;

  if Assigned(FOwnerForm) then
    Application.QueueAsyncCall(@RestoreOwnerFocus, PtrInt(FOwnerForm));  
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

end.

