unit SDSimpleDialogForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, Math,
  LCLType, LCLIntf, LCLProc, SimpleDialog, SDenums, SDBackgroundFullScreen;

type

  { TfrSimpleDialog }

  TfrSimpleDialog = class(TForm)
    Image: TImage;
    ImageList1: TImageList;
    imgClose: TImage;
    lblTitle: TLabel;
    lblSubTitle: TLabel;
    pnlContainer: TPanel;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure imgCloseClick(Sender: TObject);
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
  frSimpleDialog: TfrSimpleDialog;
  typeMessage: TTypeMessage = TTypeMessage.tmInfo;

implementation

uses
  SDfunctions;

{$R *.lfm}

{ TfrSimpleDialog }

constructor TfrSimpleDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if AOwner is TForm then
    FOwnerForm := TForm(AOwner);
end;

procedure TfrSimpleDialog.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  TfrmSDBackgroundFullScreen.closeSDBackgroundFullScreen();

  CloseAction := caFree;
  frSimpleDialog := nil;

  if Assigned(FOwnerForm) then
    Application.QueueAsyncCall(@RestoreOwnerFocus, PtrInt(FOwnerForm));
end;

procedure TfrSimpleDialog.RestoreOwnerFocus(Data: PtrInt);
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

procedure TfrSimpleDialog.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Self.Close;
end;

procedure TfrSimpleDialog.FormResize(Sender: TObject);
begin
  Image.Left := (pnlContainer.Width - Image.Width) div 2;
  lblTitle.Left := (ClientWidth - lblTitle.Width) div 2;
  lblSubTitle.Left := (ClientWidth - lblSubTitle.Width) div 2;
end;

procedure TfrSimpleDialog.FormShow(Sender: TObject);
begin
  inherited;

  lblSubTitle.Height := SDfunctions.GetLabelHeight(lblSubTitle);
  frSimpleDialog.Height := 255;
  frSimpleDialog.Height := frSimpleDialog.Height + lblSubTitle.Height - 30;

  case typeMessage of
    TTypeMessage.tmInfo:
      begin
        frSimpleDialog.lblTitle.Caption := 'Olá';
        ImageList1.GetBitmap(0, Self.Image.Picture.Bitmap);
        frSimpleDialog.Color := $00FFF1E8;
      end;
    TTypeMessage.tmWarning:
      begin
        frSimpleDialog.lblTitle.Caption := 'Atenção';
        ImageList1.GetBitmap(1, Self.Image.Picture.Bitmap);
        frSimpleDialog.Color := $00E8FFFA;
      end;
    TTypeMessage.tmError:
      begin
        frSimpleDialog.lblTitle.Caption := 'Erro';
        ImageList1.GetBitmap(2, Self.Image.Picture.Bitmap);
        frSimpleDialog.Color := $00E8ECFF;
      end;
     TTypeMessage.tmQuestion:
       begin
         frSimpleDialog.lblTitle.Caption := 'Pergunta';
         ImageList1.GetBitmap(3, Self.Image.Picture.Bitmap);
         frSimpleDialog.Color := $00FFF1E8;
       end;
  end;

  SetRoundedCorners(50);
  Recenter;
end;

procedure TfrSimpleDialog.imgCloseClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrSimpleDialog.SetRoundedCorners(Radius: Integer);
var
  Rgn: HRGN;
begin
  Rgn := CreateRoundRectRgn(0, 0, Width + 1, Height + 1, Radius, Radius);
  SetWindowRgn(Handle, Rgn, True);
end;

procedure TfrSimpleDialog.Recenter;
var
  CenterLeft, CenterTop: Integer;
  ParentForm: TForm;
begin
  ParentForm := SDfunctions.GetParentForm(Owner);

  SDfunctions.GetFormCenters(
    ParentForm,
    Self,
    CenterLeft,
    CenterTop
  );

  Left := CenterLeft;
  Top := IfThen(
    FFullScreen,
    CenterTop,
    CenterTop - Trunc(SDFunctions.GetTaskBarHeight div 2)
  );
end;

end.
