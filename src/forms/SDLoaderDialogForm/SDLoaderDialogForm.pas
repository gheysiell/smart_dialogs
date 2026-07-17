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
    lbMessage: TLabel;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CloseLoader;
  private
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
end;

procedure TfrLoaderDialog.FormShow(Sender: TObject);
begin
  if Trim(lbMessage.Caption) = '' then
  begin
    Loader.Top := Scale96ToForm(65);
    frLoaderDialog.Height := Scale96ToForm(231);
  end
  else
  begin
    lbMessage.Height := SDfunctions.GetLabelHeight(lbMessage);

    Loader.Top := Scale96ToForm(40);
    frLoaderDialog.Height := Scale96ToForm(200);
    frLoaderDialog.Height := frLoaderDialog.Height + lbMessage.Height;
  end;

  SetRoundedCorners(Self, 50);
  CenterForm(Self, Owner, FullScreen);
end;

procedure TfrLoaderDialog.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  TSDBackgroundManager.PopBackground;

  CloseAction := caFree;
  frLoaderDialog := nil;
end;

procedure TfrLoaderDialog.FormResize(Sender: TObject);
begin
  lbMessage.Left := (ClientWidth - lbMessage.Width) div 2;
end;

procedure TfrLoaderDialog.CloseLoader;
begin
  ModalResult := mrOK;
end;

end.

