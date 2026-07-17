unit SDSimpleDialogForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, LCLType,
  LCLIntf, LCLProc, SDenums, SDBackgroundFullScreen;

type

  { TfrSimpleDialog }

  TfrSimpleDialog = class(TForm)
    ilClose: TImageList;
    imMain: TImage;
    ilIcons: TImageList;
    imClose: TImage;
    lbTitle: TLabel;
    lbSubTitle: TLabel;
    pnContainer: TPanel;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure imCloseClick(Sender: TObject);
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
  if (Key = VK_ESCAPE) or (Key = VK_RETURN) then
    Self.Close;
end;

procedure TfrSimpleDialog.FormResize(Sender: TObject);
begin
  imMain.Left := (pnContainer.Width - imMain.Width) div 2;
  lbTitle.Left := (ClientWidth - lbTitle.Width) div 2;
  lbSubTitle.Left := (ClientWidth - lbSubTitle.Width) div 2;
end;

procedure TfrSimpleDialog.FormShow(Sender: TObject);
begin
  inherited;

  lbSubTitle.Height := SDfunctions.GetLabelHeight(lbSubTitle);
  frSimpleDialog.Height := Scale96ToForm(220);
  frSimpleDialog.Height := frSimpleDialog.Height + lbSubTitle.Height;

  case typeMessage of
    TTypeMessage.tmInfo:
      begin
        frSimpleDialog.lbTitle.Caption := 'Olá';
        imMain.ImageIndex := 0;
        frSimpleDialog.Color := $00FFF1E8;
      end;
    TTypeMessage.tmWarning:
      begin
        frSimpleDialog.lbTitle.Caption := 'Atenção';
        imMain.ImageIndex := 1;
        frSimpleDialog.Color := $00E8FFFA;
      end;
    TTypeMessage.tmError:
      begin
        frSimpleDialog.lbTitle.Caption := 'Erro';
        imMain.ImageIndex := 2;
        frSimpleDialog.Color := $00E8ECFF;
      end;
     TTypeMessage.tmQuestion:
       begin
         frSimpleDialog.lbTitle.Caption := 'Pergunta';
         imMain.ImageIndex := 3;
         frSimpleDialog.Color := $00FFF1E8;
       end;
  end;

  SetRoundedCorners(Self, 50);
  CenterForm(Self, Owner, FullScreen);
end;

procedure TfrSimpleDialog.imCloseClick(Sender: TObject);
begin
  Self.Close;
end;

end.
