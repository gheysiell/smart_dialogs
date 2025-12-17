unit SDfunctions;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  SDBackgroundFullScreen;

procedure ShowSDBackgroundFullScreen(FormRef: TForm; FullScreen: Boolean);
procedure CloseSDBackgroundFullScreen;
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

implementation

procedure ShowSDBackgroundFullScreen(FormRef: TForm; FullScreen: Boolean);
var
  Monitor: TMonitor;
  FormWidth, FormHeight, TaskBarHeight: Integer;
  CenterLeft: Integer=0;
  CenterTop: Integer=0;
begin
  if not Assigned(frmSDBackgroundFullScreen) then
    frmSDBackgroundFullScreen := TfrmSDBackgroundFullScreen.Create(Application);

  frmSDBackgroundFullScreen.Position := poDesigned;

  if Assigned(FormRef) then
    Monitor := Screen.MonitorFromWindow(FormRef.Handle)
  else
    Monitor := Screen.PrimaryMonitor;

  TaskBarHeight := Ternary(FullScreen, 0, frmSDBackgroundFullScreen.GetTaskBarHeight);
  FormWidth := Monitor.Width;
  FormHeight := Monitor.Height - TaskBarHeight;

  with frmSDBackgroundFullScreen do
  begin
    Left := 0;
    Top := 0;
    Width := FormWidth;
    Height := FormHeight;
    Show;
    BringToFront;
  end;
end;

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

procedure CloseSDBackgroundFullScreen;
begin
  if Assigned(SDBackgroundFullScreen.frmSDBackgroundFullScreen) then
  begin
    SDBackgroundFullScreen.frmSDBackgroundFullScreen.Close;
    SDBackgroundFullScreen.frmSDBackgroundFullScreen.Free;
    SDBackgroundFullScreen.frmSDBackgroundFullScreen := nil;
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

end.
