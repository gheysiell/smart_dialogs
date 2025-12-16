# smart_dialogs

## Description

This is a documentation of the **smart_dialogs** project, a Lazarus package
with UI components.

## Project statatistics

- **Lines of code**: 2.437
- **Files**: 14
- **Folders**: 7
- **Screens**: 3
- **Dependencies**: 3
- **Average lines per file**: 172

## Steps to add package in your project

In lazarus IDE go to Package -> Open package file (.lpk) and select the SmartDialogs.lpk
file, after this, Use -> Add to project and after Use -> Install

## LoaderDialog SlowProcess Explanation

The `LoaderDialog` component includes a property called `SlowProcess`. This property is responsible for handling slow tasks while keeping the loader visible, ensuring a smooth user experience during long-running processes.

The `SlowProcess` property should be assigned to a procedure that contains the task to be executed. Below is an example demonstrating how to link a slow task to the `LoaderDialog` and display it while the task is being processed.

### Example Code

```Object Pascal
procedure TForm1.Button1Click(Sender: TObject);
begin
  // Assign the slow process to the LoaderDialog
  LoaderDialog1.SlowProcess := @SampleSlowProcess;

  // Make the LoaderDialog visible while the process is running
  LoaderDialog1.Visible := True;
end;

procedure TForm1.SampleSlowProcess;
begin  
  Sleep(4000);
end;
