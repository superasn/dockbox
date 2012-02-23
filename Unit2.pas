Unit Unit2;

Interface

Uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
   Dialogs, StdCtrls;

Type
   Tsettingsform = Class(TForm)
      Label1: TLabel;
      filter: TEdit;
      Label2: TLabel;
      Label3: TLabel;
      path: TEdit;
      Button1: TButton;
      OpenDialog1: TOpenDialog;
      Button2: TButton;
      Procedure Button1Click(Sender: TObject);
      Procedure Button2Click(Sender: TObject);
      Procedure FormCreate(Sender: TObject);
      Procedure FormShow(Sender: TObject);
   Private
      id, fn: String;
   Public
      { Public declarations }
   End;

Var
   settingsform: Tsettingsform;

Implementation

{$R *.dfm}

Procedure Tsettingsform.Button1Click(Sender: TObject);
Begin
   If (OpenDialog1.Execute) Then
      path.Text := OpenDialog1.FileName;
End;

Procedure Tsettingsform.Button2Click(Sender: TObject);
Begin
   If (Not FileExists(path.text)) Then
      MessageDlg('Warning: Editor path is either incomplete or it does not exists!', mtInformation, [mbOk], 0);

   WritePrivateProfileString(pchar(id), 'filter', pchar(filter.text), pchar(fn));
   WritePrivateProfileString(pchar(id), 'path', pchar(path.text), pchar(fn));
   Close;
End;

Procedure Tsettingsform.FormCreate(Sender: TObject);
Begin
   id := 'dockbox';
   fn := ExtractFilePath(Application.ExeName) + '\' + id + '.ini';
   FormShow(Sender);

   If (Not FileExists(fn)) Then Self.ShowModal;
End;

Function GetWinDir: String;
Var
   dir: Array[0..MAX_PATH] Of Char;
Begin
   GetWindowsDirectory(dir, MAX_PATH);
   Result := StrPas(dir);
End;

Procedure Tsettingsform.FormShow(Sender: TObject);
Var
   buf: Array[0..255] Of char;
Begin
   GetPrivateProfileString(pchar(id), 'filter', 'pl,php,html,css,js', buf, 255, pchar(fn));
   filter.Text := strpas(buf);
   GetPrivateProfileString(pchar(id), 'path', pchar(GetWinDir + '\notepad.exe'), buf, 255, pchar(fn));
   path.Text := strpas(buf);
End;

End.

