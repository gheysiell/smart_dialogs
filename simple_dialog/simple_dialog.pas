unit simple_dialog;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  LCLType, LCLIntf, LCLProc, SimpleDialog;

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
    procedure SetHeightLabel;
  private
    procedure SetRoundedCorners(Radius: Integer);
  public

  end;

var
  frSimpleDialog: TfrSimpleDialog;
  typeOfMessage: TTypeOfMessage = TTypeOfMessage.tmInfo;

implementation

uses
  functions;

{$R *.lfm}

{ TfrSimpleDialog }

procedure TfrSimpleDialog.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Self.Close;
end;

procedure TfrSimpleDialog.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  functions.closeBackgroundFullScreen();
end;

procedure TfrSimpleDialog.FormResize(Sender: TObject);
begin
  lblTitle.Left := (ClientWidth - lblTitle.Width) div 2;
  lblSubTitle.Left := (ClientWidth - lblSubTitle.Width) div 2;
end;

procedure TfrSimpleDialog.FormShow(Sender: TObject);
begin
  inherited;

  SetHeightLabel;
  frSimpleDialog.Height := 250;
  frSimpleDialog.Height := frSimpleDialog.Height + lblSubTitle.Height - 30;

  if typeOfMessage = TTypeOfMessage.tmInfo then
  begin
    simple_dialog.frSimpleDialog.lblTitle.Caption := 'Olá';
    ImageList1.GetBitmap(0, Self.Image.Picture.Bitmap);
    frSimpleDialog.Color := $00FFF1E8;
  end
  else if typeOfMessage = TTypeOfMessage.tmWarning then
  begin
    simple_dialog.frSimpleDialog.lblTitle.Caption := 'Atenção';
    ImageList1.GetBitmap(1, Self.Image.Picture.Bitmap);
    frSimpleDialog.Color := $00E8FFFA;
  end
  else if typeOfMessage = TTypeOfMessage.tmError then
  begin
    simple_dialog.frSimpleDialog.lblTitle.Caption := 'Erro';
    ImageList1.GetBitmap(2, Self.Image.Picture.Bitmap);
    frSimpleDialog.Color := $00E8ECFF;
  end;

  SetRoundedCorners(50);
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

procedure TfrSimpleDialog.SetHeightLabel;
var
  TmpBitmap: TBitmap;
  TextHeight, Lines: Integer;
begin
  TmpBitmap := TBitmap.Create;
  try
    TmpBitmap.Canvas.Font.Assign(lblSubTitle.Font);
    TextHeight := TmpBitmap.Canvas.TextHeight('W');
    Lines := (TmpBitmap.Canvas.TextWidth(lblSubTitle.Caption) div lblSubTitle.Width) + 1;

    lblSubTitle.Height := Lines * TextHeight;
  finally
    TmpBitmap.Free;
  end;
end;

end.

