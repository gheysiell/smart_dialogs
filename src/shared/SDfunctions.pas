unit SDfunctions;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  SDBackgroundFullScreen;

procedure ShowSDBackgroundFullScreen(FormRef: TForm);
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

implementation

procedure ShowSDBackgroundFullScreen(FormRef: TForm);
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

  TaskBarHeight := frmSDBackgroundFullScreen.GetTaskBarHeight;
  FormWidth := Monitor.Width;
  FormHeight := Monitor.Height - TaskBarHeight;

  if Assigned(FormRef) then
  begin
    CenterLeft := FormRef.Left + (FormRef.Width - FormWidth) div 2;
    CenterTop  := FormRef.Top  + (FormRef.Height - FormHeight) div 2;
  end
  else
  begin
    CenterLeft := Monitor.Left + (Monitor.Width - FormWidth) div 2;
    CenterTop  := Monitor.Top  + (Monitor.Height - FormHeight) div 2;
  end;

  with frmSDBackgroundFullScreen do
  begin
    FormStyle := fsStayOnTop;
    Left := CenterLeft;
    Top := CenterTop;
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
