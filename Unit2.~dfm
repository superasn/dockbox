object settingsform: Tsettingsform
  Left = 545
  Top = 344
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Settings'
  ClientHeight = 183
  ClientWidth = 529
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 55
    Height = 16
    Caption = 'File filter:'
  end
  object Label2: TLabel
    Left = 401
    Top = 41
    Width = 113
    Height = 16
    Caption = '(comma separated)'
  end
  object Label3: TLabel
    Left = 8
    Top = 72
    Width = 67
    Height = 16
    Caption = 'Editor path:'
  end
  object filter: TEdit
    Left = 8
    Top = 37
    Width = 385
    Height = 24
    TabOrder = 0
    Text = 'css,php,pl,html'
  end
  object path: TEdit
    Left = 8
    Top = 96
    Width = 385
    Height = 24
    TabOrder = 1
    Text = 'notepad.exe'
  end
  object Button1: TButton
    Left = 400
    Top = 95
    Width = 91
    Height = 22
    Caption = 'Locate..'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 201
    Top = 144
    Width = 107
    Height = 25
    Caption = 'Save settings'
    TabOrder = 3
    OnClick = Button2Click
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '*.exe'
    Filter = '*.exe'
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Title = 'Editor Path:'
    Left = 288
    Top = 72
  end
end
