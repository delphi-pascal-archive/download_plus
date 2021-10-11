object fLoading: TfLoading
  Left = 321
  Top = 210
  BorderStyle = bsDialog
  Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1092#1072#1081#1083#1072
  ClientHeight = 155
  ClientWidth = 307
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ProgressBar: TGauge
    Left = 9
    Top = 28
    Width = 90
    Height = 90
    BorderStyle = bsNone
    ForeColor = clHighlight
    Kind = gkPie
    Progress = 0
  end
  object Label6: TLabel
    Left = 109
    Top = 33
    Width = 59
    Height = 13
    Caption = #1047#1072#1075#1088#1091#1078#1077#1085#1086':'
  end
  object Label7: TLabel
    Left = 173
    Top = 33
    Width = 131
    Height = 13
    AutoSize = False
  end
  object Label8: TLabel
    Left = 109
    Top = 53
    Width = 52
    Height = 13
    Caption = #1057#1082#1086#1088#1086#1089#1090#1100':'
  end
  object Label9: TLabel
    Left = 167
    Top = 54
    Width = 137
    Height = 13
    AutoSize = False
  end
  object Label10: TLabel
    Left = 109
    Top = 75
    Width = 82
    Height = 13
    Caption = #1042#1088#1077#1084#1103' '#1079#1072#1075#1088#1091#1079#1082#1080':'
  end
  object Label11: TLabel
    Left = 197
    Top = 75
    Width = 107
    Height = 13
    AutoSize = False
  end
  object Label12: TLabel
    Left = 109
    Top = 96
    Width = 97
    Height = 13
    Caption = #1054#1089#1090#1072#1083#1086#1089#1100' '#1074#1088#1077#1084#1077#1085#1080':'
  end
  object Label13: TLabel
    Left = 211
    Top = 96
    Width = 93
    Height = 13
    AutoSize = False
  end
  object Label2: TLabel
    Left = 4
    Top = 8
    Width = 300
    Height = 13
    AutoSize = False
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Button1: TButton
    Left = 165
    Top = 129
    Width = 75
    Height = 23
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 85
    Top = 129
    Width = 75
    Height = 23
    Caption = #1054#1089#1090#1072#1085#1086#1074#1080#1090#1100
    TabOrder = 1
    OnClick = Button2Click
  end
  object Timer: TTimer
    Enabled = False
    OnTimer = TimerTimer
    Left = 4
    Top = 125
  end
end
