unit ConfirmationDialogForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Windows, enums;

type

  { TfrConfirmationDialog }

  TfrConfirmationDialog = class(TForm)
    Image: TImage;
    ImageList1: TImageList;
    imgClose: TImage;
    lblCancel: TLabel;
    lblConfirm: TLabel;
    lblSubTitle: TLabel;
    lblTitle: TLabel;
    pnlWrapperCancel: TPanel;
    pnlContainer: TPanel;
    pnlWrapperConfirm: TPanel;
    shpCancel: TShape;
    shpConfirm: TShape;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure imgCloseClick(Sender: TObject);
    procedure lblCancelClick(Sender: TObject);
    procedure lblCancelMouseEnter(Sender: TObject);
    procedure lblCancelMouseLeave(Sender: TObject);
    procedure lblConfirmClick(Sender: TObject);
    procedure lblConfirmMouseEnter(Sender: TObject);
    procedure lblConfirmMouseLeave(Sender: TObject);
    procedure pnlWrapperCancelClick(Sender: TObject);
    procedure shpCancelChangeBounds(Sender: TObject);
    procedure shpCancelMouseEnter(Sender: TObject);
    procedure shpCancelMouseLeave(Sender: TObject);
    procedure shpCancelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure shpConfirmChangeBounds(Sender: TObject);
    procedure SetRoundedCorners(Radius: Integer);
    procedure shpConfirmMouseEnter(Sender: TObject);
    procedure shpConfirmMouseLeave(Sender: TObject);
    procedure shpConfirmMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private

  public

  end;

var
  frConfirmationDialog: TfrConfirmationDialog;
  CanceledOrConfirmed: TCanceledOrConfirmed=TCanceledOrConfirmed.Canceled;
  typeMessage: TTypeMessage = TTypeMessage.tmWarning;

implementation

uses
  functions;

{$R *.lfm}

{ TfrConfirmationDialog }

procedure TfrConfirmationDialog.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  functions.closeBackgroundFullScreen();
end;

procedure TfrConfirmationDialog.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key <> 13 then
    Self.Close
  else
    shpConfirmChangeBounds(Sender);
end;

procedure TfrConfirmationDialog.FormResize(Sender: TObject);
begin
  Image.Left := (pnlContainer.Width - Image.Width) div 2;
  lblTitle.Left := (ClientWidth - lblTitle.Width) div 2;
  lblSubTitle.Left := (ClientWidth - lblSubTitle.Width) div 2;
end;

procedure TfrConfirmationDialog.FormShow(Sender: TObject);
begin
  inherited;

  lblSubTitle.Height := functions.GetLabelHeight(lblSubTitle);
  frConfirmationDialog.Height := 305;
  frConfirmationDialog.Height := frConfirmationDialog.Height + lblSubTitle.Height;

  if typeMessage = TTypeMessage.tmInfo then
  begin
    frConfirmationDialog.lblTitle.Caption := 'Olá';
    ImageList1.GetBitmap(0, Self.Image.Picture.Bitmap);
    frConfirmationDialog.Color := $00FFF1E8;
  end
  else if typeMessage = TTypeMessage.tmWarning then
  begin
    frConfirmationDialog.lblTitle.Caption := 'Atenção';
    ImageList1.GetBitmap(1, Self.Image.Picture.Bitmap);
    frConfirmationDialog.Color := $00E8FFFA;
  end
  else if typeMessage = TTypeMessage.tmError then
  begin
    frConfirmationDialog.lblTitle.Caption := 'Erro';
    ImageList1.GetBitmap(2, Self.Image.Picture.Bitmap);
    frConfirmationDialog.Color := $00E8ECFF;
  end;

  CanceledOrConfirmed := TCanceledOrConfirmed.Canceled;
  SetRoundedCorners(50);
end;

procedure TfrConfirmationDialog.imgCloseClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrConfirmationDialog.lblCancelClick(Sender: TObject);
begin
  imgCloseClick(Sender);
end;

procedure TfrConfirmationDialog.lblCancelMouseEnter(Sender: TObject);
begin
  shpCancelMouseEnter(Sender);
end;

procedure TfrConfirmationDialog.lblCancelMouseLeave(Sender: TObject);
begin
  shpCancelMouseLeave(Sender);
end;

procedure TfrConfirmationDialog.lblConfirmClick(Sender: TObject);
begin
  shpConfirmChangeBounds(Sender);
end;

procedure TfrConfirmationDialog.lblConfirmMouseEnter(Sender: TObject);
begin
  shpConfirmMouseEnter(Sender);
end;

procedure TfrConfirmationDialog.lblConfirmMouseLeave(Sender: TObject);
begin
  shpConfirmMouseLeave(Sender);
end;

procedure TfrConfirmationDialog.pnlWrapperCancelClick(Sender: TObject);
begin

end;

procedure TfrConfirmationDialog.shpCancelChangeBounds(Sender: TObject);
begin
  CanceledOrConfirmed := TCanceledOrConfirmed.Canceled;
  imgCloseClick(Sender);
end;

procedure TfrConfirmationDialog.shpCancelMouseEnter(Sender: TObject);
begin
  shpCancel.Brush.Color := $00A0A0A0;
end;

procedure TfrConfirmationDialog.shpCancelMouseLeave(Sender: TObject);
begin
  shpCancel.Brush.Color := $00C8C8C8;
end;

procedure TfrConfirmationDialog.shpCancelMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
    imgCloseClick(Sender);
end;

procedure TfrConfirmationDialog.shpConfirmChangeBounds(Sender: TObject);
begin
  CanceledOrConfirmed := TCanceledOrConfirmed.Confirmed;
  imgCloseClick(Sender);
end;

procedure TfrConfirmationDialog.SetRoundedCorners(Radius: Integer);
var
  Rgn: HRGN;
begin
  Rgn := CreateRoundRectRgn(0, 0, Width + 1, Height + 1, Radius, Radius);
  SetWindowRgn(Handle, Rgn, True);
end;

procedure TfrConfirmationDialog.shpConfirmMouseEnter(Sender: TObject);
begin
  shpConfirm.Brush.Color := $00BE8C5C;
end;

procedure TfrConfirmationDialog.shpConfirmMouseLeave(Sender: TObject);
begin
  shpConfirm.Brush.Color := $00EDAF5C;
end;

procedure TfrConfirmationDialog.shpConfirmMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
    shpConfirmChangeBounds(Sender);
end;

end.

