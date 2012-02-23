program DockBox;

uses
  Forms,
  Unit1 in 'Unit1.pas' {EasyForm},
  Unit2 in 'Unit2.pas' {settingsform};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'DockBox';
  Application.CreateForm(TEasyForm, EasyForm);
  Application.CreateForm(Tsettingsform, settingsform);
  Application.Run;
end.
