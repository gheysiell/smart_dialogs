unit functions;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  BackgroundFullScreen;

procedure ShowBackgroundFullScreen();
procedure CloseBackgroundFullScreen();
function Ternary(ACondition: Boolean; ATrueValue, AFalseValue: Variant): Variant;
function GetParentForm(Owner: TComponent): TForm;
function GetLabelHeight(ALabel: TLabel): Integer;

implementation

procedure ShowBackgroundFullScreen();
begin
  if not Assigned(frmBackgroundFullScreen) then
    frmBackgroundFullScreen := TfrmBackgroundFullScreen.Create(Application);

  frmBackgroundFullScreen.Show;
  frmBackgroundFullScreen.BringToFront;
end;

procedure CloseBackgroundFullScreen();
begin
  if Assigned(BackgroundFullScreen.frmBackgroundFullScreen) then
  begin
    BackgroundFullScreen.frmBackgroundFullScreen.Close;
    BackgroundFullScreen.frmBackgroundFullScreen.Free;
    BackgroundFullScreen.frmBackgroundFullScreen := nil;
  end;
end;

function Ternary(ACondition: Boolean; ATrueValue, AFalseValue: Variant): Variant;
begin
  if ACondition then
    Result := ATrueValue
  else
    Result := AFalseValue;
end;

function GetParentForm(Owner: TComponent): TForm;
begin
  Result := TForm(Owner);
end;

function GetLabelHeight(ALabel: TLabel): Integer;
var
  TmpBitmap: TBitmap;
  TextHeight, Lines, LabelHeight: Integer;
begin
  TmpBitmap := TBitmap.Create;
  try
    TmpBitmap.Canvas.Font.Assign(ALabel.Font);
    TextHeight := TmpBitmap.Canvas.TextHeight('W');
    Lines := (TmpBitmap.Canvas.TextWidth(ALabel.Caption) div ALabel.Width) + 1;

    LabelHeight := Lines * TextHeight;

    Result := LabelHeight;
  finally
    TmpBitmap.Free;
  end;
end;

end.
