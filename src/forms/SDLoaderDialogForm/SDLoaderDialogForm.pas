unit SDLoaderDialogForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  LCLType, LCLIntf, LCLProc, StdCtrls, BCFluentProgressRing;

type

  { TfrLoaderDialog }

  TfrLoaderDialog = class(TForm)
    BCFluentProgressRing1: TBCFluentProgressRing;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure CloseLoader();
  private
    procedure SetRoundedCorners(Radius: Integer);
  public

  end;

var
  frLoaderDialog: TfrLoaderDialog;

implementation

uses
  SDfunctions;

{$R *.lfm}

procedure TfrLoaderDialog.FormShow(Sender: TObject);
begin
  SetRoundedCorners(50);
end;

procedure TfrLoaderDialog.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  SDfunctions.closeSDBackgroundFullScreen();
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

