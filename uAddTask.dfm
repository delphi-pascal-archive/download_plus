object fAddTask: TfAddTask
  Left = 308
  Top = 175
  BorderStyle = bsDialog
  Caption = #1053#1086#1074#1072#1103' '#1079#1072#1076#1072#1095#1072
  ClientHeight = 347
  ClientWidth = 373
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 5
    Top = 9
    Width = 42
    Height = 13
    Caption = #1057#1089#1099#1083#1082#1072':'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 5
    Top = 36
    Width = 68
    Height = 13
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074':'
  end
  object Label3: TLabel
    Left = 5
    Top = 182
    Width = 97
    Height = 13
    Caption = #1048#1084#1103' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103':'
  end
  object Label4: TLabel
    Left = 5
    Top = 208
    Width = 41
    Height = 13
    Caption = #1055#1072#1088#1086#1083#1100':'
  end
  object Label5: TLabel
    Left = 226
    Top = 182
    Width = 29
    Height = 13
    Caption = #1055#1086#1088#1090':'
  end
  object Label9: TLabel
    Left = 5
    Top = 92
    Width = 58
    Height = 13
    Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103':'
  end
  object Label10: TLabel
    Left = 5
    Top = 64
    Width = 58
    Height = 13
    Caption = #1048#1084#1103' '#1092#1072#1081#1083#1072':'
  end
  object Label8: TLabel
    Left = 6
    Top = 120
    Width = 53
    Height = 13
    Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
  end
  object btnOK: TButton
    Left = 114
    Top = 321
    Width = 75
    Height = 23
    Caption = 'OK'
    TabOrder = 9
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 194
    Top = 321
    Width = 75
    Height = 23
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 10
    OnClick = btnCancelClick
  end
  object edLogin: TEdit
    Left = 108
    Top = 206
    Width = 105
    Height = 21
    Enabled = False
    TabOrder = 7
  end
  object edPassword: TEdit
    Left = 108
    Top = 180
    Width = 105
    Height = 21
    Enabled = False
    TabOrder = 6
  end
  object cbxSpecial: TCheckBox
    Left = 5
    Top = 153
    Width = 292
    Height = 17
    Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1086#1089#1086#1073#1099#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1074#1093#1086#1076#1072' '#1085#1072' '#1089#1077#1088#1074#1077#1088
    TabOrder = 5
    OnClick = cbxSpecialClick
  end
  object cbCategory: TComboBox
    Left = 77
    Top = 89
    Width = 293
    Height = 21
    ItemHeight = 13
    TabOrder = 3
  end
  object cbDirectory: TComboBox
    Left = 77
    Top = 33
    Width = 293
    Height = 21
    AutoDropDown = True
    AutoCloseUp = True
    ItemHeight = 13
    TabOrder = 1
    OnClick = cbDirectoryClick
    OnDropDown = cbDirectoryDropDown
    Items.Strings = (
      #1054#1073#1079#1086#1088' '#1087#1072#1087#1086#1082'...')
  end
  object edFileName: TEdit
    Left = 77
    Top = 61
    Width = 292
    Height = 21
    TabOrder = 2
  end
  object cbUrl: TComboBox
    Left = 77
    Top = 6
    Width = 293
    Height = 21
    ItemHeight = 13
    TabOrder = 0
    OnChange = cbUrlChange
  end
  object edDescription: TEdit
    Left = 77
    Top = 117
    Width = 292
    Height = 21
    TabOrder = 4
  end
  object sePort: TSpinEdit
    Left = 268
    Top = 180
    Width = 69
    Height = 22
    MaxValue = 65535
    MinValue = 0
    TabOrder = 8
    Value = 80
  end
  object GroupBox1: TGroupBox
    Left = 5
    Top = 235
    Width = 364
    Height = 78
    Caption = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091':'
    TabOrder = 11
    object RadioButton1: TRadioButton
      Left = 6
      Top = 17
      Width = 113
      Height = 17
      Caption = #1053#1077#1084#1077#1076#1083#1077#1085#1085#1086
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object RadioButton2: TRadioButton
      Left = 6
      Top = 36
      Width = 113
      Height = 17
      Caption = #1042#1088#1091#1095#1085#1091#1102
      TabOrder = 1
    end
    object RadioButton3: TRadioButton
      Left = 6
      Top = 54
      Width = 113
      Height = 17
      Caption = #1055#1086' '#1088#1072#1089#1089#1087#1080#1089#1072#1085#1080#1102
      TabOrder = 2
    end
  end
end
