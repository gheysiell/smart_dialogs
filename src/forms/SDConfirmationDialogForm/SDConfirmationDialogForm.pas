unit SDConfirmationDialogForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, Math,
  Windows, SDenums, SDBackgroundFullScreen;

type

  { TfrConfirmationDialog }

  TfrConfirmationDialog = class(TForm)
    ilClose: TImageList;
    ilIcons: TImageList;
    imMain: TImage;
    imClose: TImage;
    lbCancel: TLabel;
    lbConfirm: TLabel;
    lbSubTitle: TLabel;
    lbTitle: TLabel;
    pnWrapperCancel: TPanel;
    pnContainer: TPanel;
    pnWrapperConfirm: TPanel;
    spCancel: TShape;
    spConfirm: TShape;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure imCloseClick(Sender: TObject);
    procedure lbCancelClick(Sender: TObject);
    procedure lbCancelMouseEnter(Sender: TObject);
    procedure lbCancelMouseLeave(Sender: TObject);
    procedure lbConfirmClick(Sender: TObject);
    procedure lbConfirmMouseEnter(Sender: TObject);
    procedure lbConfirmMouseLeave(Sender: TObject);
    procedure pnWrapperCancelClick(Sender: TObject);
    procedure pnWrapperConfirmClick(Sender: TObject);
    procedure spCancelMouseEnter(Sender: TObject);
    procedure spCancelMouseLeave(Sender: TObject);
    procedure spCancelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure spConfirmMouseEnter(Sender: TObject);
    procedure spConfirmMouseLeave(Sender: TObject);
    procedure spConfirmMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ConfirmAndClose;
    procedure CancelAndClose;
  private
    FFullScreen: Boolean;
    FCalledFromLoader: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    property FullScreen: Boolean read FFullScreen write FFullScreen;
    property CalledFromLoader: Boolean read FCalledFromLoader write FCalledFromLoader;
  end;

var
  frConfirmationDialog: TfrConfirmationDialog;
  CanceledOrConfirmed: TCanceledOrConfirmed=TCanceledOrConfirmed.Canceled;
  typeMessage: TTypeMessage = TTypeMessage.tmQuestion;

implementation

uses
  SDfunctions;

{$R *.lfm}

{ TfrConfirmationDialog }

constructor TfrConfirmationDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TfrConfirmationDialog.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if not FCalledFromLoader then
    TSDBackgroundManager.PopBackground;

  CloseAction := caFree;
  frConfirmationDialog := nil;
end;

procedure TfrConfirmationDialog.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    ConfirmAndClose
  else if Key = VK_ESCAPE then
    CancelAndClose;
end;

procedure TfrConfirmationDialog.FormResize(Sender: TObject);
begin
  imMain.Left := (pnContainer.Width - imMain.Width) div 2;
  lbTitle.Left := (ClientWidth - lbTitle.Width) div 2;
  lbSubTitle.Left := (ClientWidth - lbSubTitle.Width) div 2;
end;

procedure TfrConfirmationDialog.FormShow(Sender: TObject);
begin
  inherited;

  lbSubTitle.Height := SDfunctions.GetLabelHeight(lbSubTitle);
  frConfirmationDialog.Height := Scale96ToForm(300);
  frConfirmationDialog.Height := frConfirmationDialog.Height + lbSubTitle.Height;

  case typeMessage of
    TTypeMessage.tmInfo:
      begin
        frConfirmationDialog.lbTitle.Caption := 'Olá';
        imMain.ImageIndex := 0;
        frConfirmationDialog.Color := $00FFF1E8;
      end;
    TTypeMessage.tmWarning:
      begin
        frConfirmationDialog.lbTitle.Caption := 'Atenção';
        imMain.ImageIndex := 1;
        frConfirmationDialog.Color := $00E8FFFA;
      end;
    TTypeMessage.tmError:
      begin
        frConfirmationDialog.lbTitle.Caption := 'Erro';
        imMain.ImageIndex := 2;
        frConfirmationDialog.Color := $00E8ECFF;
      end;
     TTypeMessage.tmQuestion:
       begin
         frConfirmationDialog.lbTitle.Caption := 'Pergunta';
         imMain.ImageIndex := 3;
         frConfirmationDialog.Color := $00FFFBE8;
       end;
  end;

  CanceledOrConfirmed := TCanceledOrConfirmed.Canceled;
  SetRoundedCorners(Self, 50);
  CenterForm(Self, Owner, FullScreen);
end;

procedure TfrConfirmationDialog.CancelAndClose;
begin
  CanceledOrConfirmed := TCanceledOrConfirmed.Canceled;
  Self.Close;
end;

procedure TfrConfirmationDialog.ConfirmAndClose;
begin
  CanceledOrConfirmed := TCanceledOrConfirmed.Confirmed;
  Self.Close;
end;

procedure TfrConfirmationDialog.imCloseClick(Sender: TObject);
begin
  CancelAndClose
end;

procedure TfrConfirmationDialog.lbCancelClick(Sender: TObject);
begin
  CancelAndClose;
end;

procedure TfrConfirmationDialog.pnWrapperCancelClick(Sender: TObject);
begin
  CancelAndClose;
end;

procedure TfrConfirmationDialog.spCancelMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
    CancelAndClose;
end;

procedure TfrConfirmationDialog.pnWrapperConfirmClick(Sender: TObject);
begin
  ConfirmAndClose;
end;

procedure TfrConfirmationDialog.lbConfirmClick(Sender: TObject);
begin
  ConfirmAndClose;
end;

procedure TfrConfirmationDialog.spConfirmMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
    ConfirmAndClose;
end;

procedure TfrConfirmationDialog.lbCancelMouseEnter(Sender: TObject);
begin
  spCancelMouseEnter(Sender);
end;

procedure TfrConfirmationDialog.lbCancelMouseLeave(Sender: TObject);
begin
  spCancelMouseLeave(Sender);
end;

procedure TfrConfirmationDialog.lbConfirmMouseEnter(Sender: TObject);
begin
  spConfirmMouseEnter(Sender);
end;

procedure TfrConfirmationDialog.lbConfirmMouseLeave(Sender: TObject);
begin
  spConfirmMouseLeave(Sender);
end;

procedure TfrConfirmationDialog.spCancelMouseEnter(Sender: TObject);
begin
  spCancel.Brush.Color := $00A0A0A0;
end;

procedure TfrConfirmationDialog.spCancelMouseLeave(Sender: TObject);
begin
  spCancel.Brush.Color := $00C8C8C8;
end;

procedure TfrConfirmationDialog.spConfirmMouseEnter(Sender: TObject);
begin
  spConfirm.Brush.Color := $00BE8C5C;
end;

procedure TfrConfirmationDialog.spConfirmMouseLeave(Sender: TObject);
begin
  spConfirm.Brush.Color := $00EDAF5C;
end;

end.
