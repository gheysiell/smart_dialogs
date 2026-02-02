unit SDfunctions;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Windows;

procedure GetFormCenters(
   Form: TForm;
   FormDialog: TForm;
   var CenterLeft: Integer;
   var CenterTop: Integer
);
function Ternary(
   ACondition: Boolean;
   ATrueValue,
   AFalseValue: Variant
): Variant;
function GetParentForm(Owner: TComponent): TForm;
function GetLabelHeight(ALabel: TLabel): Integer;
function GetTopMostModalForm(Exclude: TCustomForm): TCustomForm;
function GetTaskBarHeight: Integer;

implementation

procedure GetFormCenters(
   Form: TForm;
   FormDialog: TForm;
   var CenterLeft: Integer;
   var CenterTop: Integer
);
begin
  if Assigned(Form) then
  begin
    CenterLeft := Form.Left + (Form.Width - FormDialog.Width) div 2;
    CenterTop := Form.Top + (Form.Height - FormDialog.Height) div 2;
  end
  else
  begin
    CenterLeft := (Form.Width - FormDialog.Width) div 2;
    CenterTop := (Form.Height - FormDialog.Height) div 2;
  end;
end;

function Ternary(
   ACondition: Boolean;
   ATrueValue, AFalseValue: Variant
): Variant;
begin
  if ACondition then
    Result := ATrueValue
  else
    Result := AFalseValue;
end;

function GetParentForm(Owner: TComponent): TForm;
begin
  Result := nil;

  while Assigned(Owner) do
  begin
    if Owner is TForm then
      Exit(TForm(Owner));

    Owner := Owner.Owner;
  end;
end;

function GetLabelHeight(ALabel: TLabel): Integer;
var
  TmpBitmap: Graphics.TBitmap;
  TextHeight, Lines, LabelHeight: Integer;
begin
  TmpBitmap := Graphics.TBitmap.Create;

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

function GetTopMostModalForm(Exclude: TCustomForm): TCustomForm;
var
  I: Integer;
  F: TCustomForm;
begin
  Result := nil;

  for I := Screen.FormCount - 1 downto 0 do
  begin
    F := Screen.Forms[I];

    if (F <> Exclude)
      and F.Visible
      and (fsModal in F.FormState)
      and F.Enabled then
    begin
      Exit(F);
    end;
  end;
end;

function GetTaskBarHeight: Integer;
var
  hTaskbar: HWND;
  Rect: TRect;
begin
  hTaskbar := FindWindow('Shell_TrayWnd', nil);

  if hTaskbar = 0 then
    Exit(0);

  if not GetWindowRect(hTaskbar, Rect) then
    RaiseLastOSError;

  Result := Rect.Bottom - Rect.Top;
end;

end.
