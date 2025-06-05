unit SDfunctions;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  SDBackgroundFullScreen;

procedure ShowSDBackgroundFullScreen();
procedure CloseSDBackgroundFullScreen();
function Ternary(ACondition: Boolean; ATrueValue, AFalseValue: Variant): Variant;
function GetParentForm(Owner: TComponent): TForm;
function GetLabelHeight(ALabel: TLabel): Integer;

implementation

procedure ShowSDBackgroundFullScreen();
begin
  if not Assigned(frmSDBackgroundFullScreen) then
    frmSDBackgroundFullScreen := TfrmSDBackgroundFullScreen.Create(Application);

  frmSDBackgroundFullScreen.Show;
  frmSDBackgroundFullScreen.BringToFront;
end;

procedure CloseSDBackgroundFullScreen();
begin
  if Assigned(SDBackgroundFullScreen.frmSDBackgroundFullScreen) then
  begin
    SDBackgroundFullScreen.frmSDBackgroundFullScreen.Close;
    SDBackgroundFullScreen.frmSDBackgroundFullScreen.Free;
    SDBackgroundFullScreen.frmSDBackgroundFullScreen := nil;
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
