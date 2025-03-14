{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit SmartDialogs;

{$warn 5023 off : no warning about unused units}
interface

uses
  SimpleDialog, ConfirmationDialog, LoaderDialog, confirmation_dialog, 
  loader_dialog, simple_dialog, BackgroundFullScreen, enums, functions, 
  LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('SimpleDialog', @SimpleDialog.Register);
  RegisterUnit('ConfirmationDialog', @ConfirmationDialog.Register);
  RegisterUnit('LoaderDialog', @LoaderDialog.Register);
end;

initialization
  RegisterPackage('SmartDialogs', @Register);
end.
