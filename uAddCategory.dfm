object fAddCategory: TfAddCategory
  Left = 314
  Top = 140
  BorderStyle = bsDialog
  Caption = #1053#1086#1074#1072#1103' '#1082#1072#1090#1077#1075#1086#1088#1080#1103
  ClientHeight = 163
  ClientWidth = 299
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 5
    Top = 7
    Width = 52
    Height = 13
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077':'
  end
  object Label2: TLabel
    Left = 5
    Top = 33
    Width = 66
    Height = 13
    Caption = #1056#1072#1079#1084#1077#1097#1077#1085#1080#1077':'
  end
  object Label3: TLabel
    Left = 5
    Top = 58
    Width = 71
    Height = 13
    Caption = #1058#1080#1087#1099' '#1092#1072#1081#1083#1086#1074':'
  end
  object edName: TEdit
    Left = 80
    Top = 4
    Width = 217
    Height = 21
    TabOrder = 0
  end
  object edPath: TEdit
    Left = 80
    Top = 30
    Width = 189
    Height = 21
    TabOrder = 1
  end
  object Memo1: TMemo
    Left = 5
    Top = 78
    Width = 292
    Height = 50
    TabOrder = 2
  end
  object Button1: TButton
    Left = 271
    Top = 29
    Width = 25
    Height = 23
    Caption = '...'
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 84
    Top = 136
    Width = 75
    Height = 23
    Caption = 'OK'
    TabOrder = 4
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 164
    Top = 136
    Width = 75
    Height = 23
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 5
    OnClick = Button3Click
  end
end
