unit SDLoaderDialogForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, LCLType, LCLIntf,
  LCLProc, StdCtrls, BCFluentProgressRing, SDBackgroundFullScreen;

type

  { TfrLoaderDialog }

  TfrLoaderDialog = class(TForm)
    Loader: TBCFluentProgressRing;
    lblMessage: TLabel;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CloseLoader;
    procedure AsyncRestoreFormFocus(Data: PtrInt);
  private
    FOwnerForm: TForm;
    FFullScreen: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    property FullScreen: Boolean read FFullScreen write FFullScreen;
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
  if Trim(lblMessage.Caption) = '' then
    Loader.Top := 64
  else
    Loader.Top := 40;

  lblMessage.Height := SDfunctions.GetLabelHeight(lblMessage);
  frLoaderDialog.Height := 230;
  frLoaderDialog.Height := frLoaderDialog.Height + lblMessage.Height - 30;

  SetRoundedCorners(Self, 50);
  CenterForm(Self, Owner, FullScreen);
end;

procedure TfrLoaderDialog.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  TfrmSDBackgroundFullScreen.closeSDBackgroundFullScreen();

  CloseAction := caFree;
  frLoaderDialog := nil;

  if Assigned(FOwnerForm) then
    Application.QueueAsyncCall(@AsyncRestoreFormFocus, PtrInt(FOwnerForm));
end;

procedure TfrLoaderDialog.AsyncRestoreFormFocus(Data: PtrInt);
begin
  RestoreFormFocus(TCustomForm(Data));
end;

procedure TfrLoaderDialog.FormResize(Sender: TObject);
begin
  lblMessage.Left := (ClientWidth - lblMessage.Width) div 2;
end;

procedure TfrLoaderDialog.CloseLoader;
begin
  ModalResult := mrOK;
end;

end.

