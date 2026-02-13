unit SDfunctions;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Windows;

function Ternary(
  ACondition: Boolean;
  ATrueValue,
  AFalseValue: Variant
): Variant;
function GetParentForm(Owner: TComponent): TForm;
function GetLabelHeight(ALabel: TLabel): Integer;
function GetTopMostModalForm(Exclude: TCustomForm): TCustomForm;
function GetTaskBarHeight: Integer;
procedure GetFormCenters(
  FullScreen: Boolean;
  BaseForm: TCustomForm;
  DialogForm: TForm;
  var CenterLeft: Integer;
  var CenterTop: Integer
);
procedure SetRoundedCorners(Form: TForm; Radius: Integer);
procedure CenterForm(AForm: TForm; AOwner: TComponent; FullScreen: Boolean);

implementation

procedure GetFormCenters(
  FullScreen: Boolean;
  BaseForm: TCustomForm;
  DialogForm: TForm;
  var CenterLeft: Integer;
  var CenterTop: Integer
);
var
  M: TMonitor;
  R: TRect;
begin
  if Assigned(BaseForm) then
    M := BaseForm.Monitor
  else
    M := Screen.PrimaryMonitor;

  R := M.WorkAreaRect;

  CenterLeft := R.Left + (R.Width - DialogForm.Width) div 2;

  if FullScreen then
    CenterTop := R.Top + ((R.Height + GetTaskBarHeight) - DialogForm.Height) div 2
  else
    CenterTop := R.Top + (R.Height - DialogForm.Height) div 2;
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

procedure SetRoundedCorners(Form: TForm; Radius: Integer);
var
  Rgn: HRGN;
begin
  Rgn := CreateRoundRectRgn(0, 0, Form.Width + 1, Form.Height + 1, Radius, Radius);
  SetWindowRgn(Form.Handle, Rgn, True);
end;

procedure CenterForm(AForm: TForm; AOwner: TComponent; FullScreen: Boolean);
var
  ParentForm: TForm;
  L, T: Integer;
begin
  ParentForm := GetParentForm(AOwner);

  GetFormCenters(FullScreen, ParentForm, AForm, L, T);

  AForm.Left := L;
  AForm.Top := T;
end;

end.
