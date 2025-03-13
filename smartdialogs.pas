{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit SmartDialogs;

{$warn 5023 off : no warning about unused units}
interface

uses
  functions, SimpleDialog, LoaderDialog, simple_dialog, loader_dialog, 
  BackgroundFullScreen, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('SimpleDialog', @SimpleDialog.Register);
  RegisterUnit('LoaderDialog', @LoaderDialog.Register);
end;

initialization
  RegisterPackage('SmartDialogs', @Register);
end.
