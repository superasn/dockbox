Unit Unit1;

Interface

Uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
   Dialogs, ShlObj, ExtCtrls, StdCtrls, ShellAPI, ComCtrls, Buttons, ActiveX,
   Hashes, ImgList, pngimage;

Type
   TEasyForm = Class(TForm)
      Timer1: TTimer;
      exitBtn: TLabel;
      tv: TTreeView;
      ImageList1: TImageList;
      settingsBtn: TImage;
      Function GetDesktopFolder: String;
      Procedure FormCreate(Sender: TObject);
      Procedure Timer1Timer(Sender: TObject);
      Procedure FindAll(Const Path: String; Attr: Integer; List: TStrings);
      Procedure FormShow(Sender: TObject);
      Procedure FormHide(Sender: TObject);
      Procedure exitBtnClick(Sender: TObject);
      Procedure tvClick(Sender: TObject);
      Procedure settingsBtnClick(Sender: TObject);
      Procedure exitBtnMouseEnter(Sender: TObject);
      Procedure exitBtnMouseLeave(Sender: TObject);

   Private
   Public
      { Public declarations }
   End;

   TShellLinkInfo = Record
      PathName: String;
      Arguments: String;
      Description: String;
      WorkingDirectory: String;
      IconLocation: String;
      IconIndex: integer;
      ShowCmd: integer;
      HotKey: word;
   End;

   prNodeData = ^rNodeData;
   rNodeData = Record
      sText: String;
   End;

Var
   EasyForm: TEasyForm;

Implementation

Uses ComObj, Unit2;

{$R *.dfm}

Function TEasyForm.GetDesktopFolder: String;
Var
   buffr: Array[0..MAX_PATH] Of char;
   idList: PItemIDList;
Begin
   Result := 'No Desktop Folder found.';
   SHGetSpecialFolderLocation(Application.Handle, CSIDL_RECENT, idList);
   If (idList <> Nil) Then
      If (SHGetPathFromIDList(idList, buffr)) Then
         Result := buffr;
End;

Procedure GetShellLinkInfo(Const LinkFile: WideString; Var SLI: TShellLinkInfo);
{ Retrieves information on an existing shell link }
Var
   SL: IShellLink;
   PF: IPersistFile;
   FindData: TWin32FindData;
   AStr: Array[0..MAX_PATH] Of char;
Begin
   OleCheck(CoCreateInstance(CLSID_ShellLink, Nil, CLSCTX_INPROC_SERVER,
      IShellLink, SL));
   { The IShellLink implementer must also support the IPersistFile }
   { interface. Get an interface pointer to it. }
   PF := SL As IPersistFile;
   { Load file into IPersistFile object }
   OleCheck(PF.Load(PWideChar(LinkFile), STGM_READ));
   { Resolve the link by calling the Resolve interface function. }
   OleCheck(SL.Resolve(0, SLR_ANY_MATCH Or SLR_NO_UI));
   { Get all the info! }
   With SLI Do
      Begin
         OleCheck(SL.GetPath(AStr, MAX_PATH, FindData, 0));
         PathName := AStr;
         OleCheck(SL.GetArguments(AStr, MAX_PATH));
         Arguments := AStr;
         OleCheck(SL.GetDescription(AStr, MAX_PATH));
         Description := AStr;
         OleCheck(SL.GetWorkingDirectory(AStr, MAX_PATH));
         WorkingDirectory := AStr;
         OleCheck(SL.GetIconLocation(AStr, MAX_PATH, IconIndex));
         IconLocation := AStr;
         OleCheck(SL.GetShowCmd(ShowCmd));
         OleCheck(SL.GetHotKey(HotKey));
      End;
End;

Procedure TEasyForm.FormCreate(Sender: TObject);
Begin
   application.ShowMainForm := false;
End;

Procedure TEasyForm.Timer1Timer(Sender: TObject);
Var
   mous: TPoint;
Begin
   mous := mouse.CursorPos;
   If (mous.X < 5) And (mous.y < 5) Then
      Begin
         EasyForm.Left := 0;
         EasyForm.Top := 0;
         EasyForm.Show;
         timer1.Interval := 1000;
      End;

   If (mous.x > EasyForm.Width + 1) Or (mous.y > EasyForm.Height + 1) Then
      Begin
         EasyForm.Hide;
         timer1.Interval := 100;
      End;
End;

Procedure TEasyForm.FindAll(Const Path: String; Attr: Integer; List: TStrings);
Var
   Res: TSearchRec;
   StringList: TStringList;
   EOFound: Boolean;
   I: integer;
Begin
   EOFound := False;
   If FindFirst(Path, Attr, Res) < 0 Then
      exit
   Else
      StringList := TStringList.Create;
   StringList.CommaText := settingsform.filter.Text;

   While Not EOFound Do
      Begin
         If StringList.Count = 0 Then
            List.Add(Res.Name)
         Else
            For I := 0 To StringList.Count - 1 Do
               If (Pos('.' + StringList[I], Res.Name) > 0) Then
                  List.Add(Res.Name);
         EOFound := FindNext(Res) <> 0;
      End;
   FindClose(Res);
End;

Procedure TEasyForm.FormShow(Sender: TObject);
Var
   Strings: TStringList;
   info: TShellLinkInfo;
   i, j: integer;
   h: TObjectHash;
   k, s, base: String;
   a, b: tstringlist;
   n, m: TTreeNode;
   hs: TStringHash;
   buf: Array[0..255] Of char;
Begin
   Strings := TStringList.Create;
   FindAll(GetDesktopFolder + '\*.*', faAnyFile, Strings);

   h := TObjectHash.Create;
   hs := TStringHash.Create;
   Base := GetDesktopFolder;

   For i := 0 To strings.Count - 1 Do
      Begin
         s := strings[i];

         If ((pos('.lnk', s) > 0) And FileExists(Base + '\' + s)) Then
            Begin
               GetShellLinkInfo(Base + '\' + s, info);
               s := info.PathName;
               If (FileExists(s)) Then
                  Begin
                     If (Not hs.Exists(s)) Then
                        Begin
                           hs[s] := '1';

                           k := extractfilepath(s);
                           If (k <> '') Then
                              Begin
                                 a := tstringlist.Create;
                                 b := Nil;

                                 If (h.Exists(k)) Then
                                    Begin
                                       b := tstringlist(h.Items[k]);
                                       a.AddStrings(b);
                                    End;

                                 a.Add(s);

                                 h[k] := a;
                              End;
                        End;
                  End;
            End;
      End;

   h.Restart;

   While h.Next Do
      Begin
         s := h.CurrentKey;
         n := tv.Items.AddFirst(Nil, s);
         b := tstringlist(h.items[s]);
         n.Data := New(prNodeData);
         prNodeData(n.Data)^.sText := 'folder';
         n.ImageIndex := 0;
         //b.Sort;

         For i := 0 To b.Count - 1 Do
            Begin
               m := tv.Items.AddChild(n, ExtractFileName(b[i]));
               m.ImageIndex := 1;
               m.Data := New(prNodeData);
               prNodeData(m.Data)^.sText := b[i];
            End;
      End;

   h.Free;
   hs.Free;

   tv.FullExpand;

   EasyForm.Height := 500; //MenuListBox.Items.Count * 17 + (pattern.Height + exitBtn.Height);
   exitBtn.Top := easyform.Height - exitBtn.Height;
   settingsBtn.Top := exitBtn.Top;
   settingsBtn.Left := width - settingsBtn.Width;

   TV.Height := exitBtn.Top;
End;

Procedure TEasyForm.FormHide(Sender: TObject);
Begin
   TV.Items.Clear;
End;

Procedure TEasyForm.exitBtnClick(Sender: TObject);
Begin
   Close;
End;

Procedure TEasyForm.tvClick(Sender: TObject);
Var
   Node: Ttreenode;
Begin
   Node := Tv.Selected;

   If (Assigned(Node.Data)) Then
      Begin
         If (prNodeData(Node.Data)^.sText = 'folder') Then
            ShellExecute(handle, 'open', pchar(node.text), '', '', SW_SHOW)
         Else
            ShellExecute(handle, 'open', pchar(settingsform.path.Text), pchar(prNodeData(Node.Data)^.sText), '', SW_SHOW);

         EasyForm.Hide;
      End;
End;

Procedure TEasyForm.settingsBtnClick(Sender: TObject);
Begin
   settingsform.showmodal;
End;

Procedure TEasyForm.exitBtnMouseEnter(Sender: TObject);
Begin
   exitBtn.Color := $006C6C6C;
End;

Procedure TEasyForm.exitBtnMouseLeave(Sender: TObject);
Begin
   exitBtn.Color := $00515151;
End;

End.

