unit SDSimpleDialogForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, LCLType,
  LCLIntf, LCLProc, SDenums, SDBackgroundFullScreen;

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
  private
    FFullScreen: Boolean;
    FCalledFromLoader: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    property FullScreen: Boolean read FFullScreen write FFullScreen;
    property CalledFromLoader: Boolean read FCalledFromLoader write FCalledFromLoader;
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
end;

procedure TfrSimpleDialog.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if not FCalledFromLoader then
    TSDBackgroundManager.PopBackground;

  CloseAction := caFree;
  frSimpleDialog := nil;
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
  frSimpleDialog.Height := 242;
  frSimpleDialog.Height := frSimpleDialog.Height + lblSubTitle.Height;

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

  SetRoundedCorners(Self, 50);
  CenterForm(Self, Owner, FullScreen);
end;

procedure TfrSimpleDialog.imgCloseClick(Sender: TObject);
begin
  Self.Close;
end;

end.
