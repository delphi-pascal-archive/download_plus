object fOptions: TfOptions
  Left = 349
  Top = 123
  BorderStyle = bsDialog
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
  ClientHeight = 366
  ClientWidth = 413
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
  object btnOK: TButton
    Left = 255
    Top = 339
    Width = 75
    Height = 23
    Caption = 'OK'
    TabOrder = 0
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 335
    Top = 339
    Width = 75
    Height = 23
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 413
    Height = 334
    ActivePage = TabSheet3
    TabOrder = 2
    object TabSheet3: TTabSheet
      Caption = #1054#1073#1097#1080#1077
      ImageIndex = 2
      object Label23: TLabel
        Left = 5
        Top = 208
        Width = 335
        Height = 13
        Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' '#1085#1072#1095#1080#1085#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1080' '#1076#1083#1103' '#1089#1083#1077#1076#1091#1102#1097#1080#1093' '#1088#1072#1089#1089#1096#1080#1088#1077#1085#1080#1081':'
      end
      object Label6: TLabel
        Left = 5
        Top = 184
        Width = 92
        Height = 13
        Caption = #1043#1086#1088#1103#1095#1072#1103' '#1075#1083#1072#1074#1080#1096#1072':'
      end
      object cbxRunWithWindows: TCheckBox
        Left = 5
        Top = 7
        Width = 225
        Height = 17
        Caption = #1047#1072#1087#1091#1089#1082#1072#1090#1100' '#1087#1088#1080' '#1089#1090#1072#1088#1090#1077' Windows'
        TabOrder = 0
      end
      object cbxHookClipboard: TCheckBox
        Left = 5
        Top = 64
        Width = 185
        Height = 17
        Caption = #1057#1083#1077#1076#1080#1090#1100' '#1079#1072' '#1073#1091#1092#1077#1088#1086#1084' '#1086#1073#1084#1077#1085#1072
        TabOrder = 1
      end
      object cbxMinToTray: TCheckBox
        Left = 5
        Top = 26
        Width = 179
        Height = 17
        Caption = #1057#1074#1086#1088#1072#1095#1080#1074#1072#1090#1100' '#1074' System Tray'
        TabOrder = 2
      end
      object mmExtention: TMemo
        Left = 5
        Top = 228
        Width = 395
        Height = 74
        Lines.Strings = (
          '.zip .rar .exe')
        TabOrder = 3
      end
      object CheckBox4: TCheckBox
        Left = 5
        Top = 83
        Width = 251
        Height = 17
        Caption = #1053#1072#1095#1080#1085#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1087#1088#1080' '#1089#1090#1072#1088#1090#1077' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
        TabOrder = 4
      end
      object CheckBox5: TCheckBox
        Left = 5
        Top = 102
        Width = 259
        Height = 17
        Caption = #1055#1077#1088#1077#1093#1074#1072#1090#1099#1074#1072#1090#1100' '#1085#1072#1095#1072#1083#1086' '#1079#1072#1075#1088#1091#1079#1082#1080' '#1074' '#1073#1088#1072#1091#1079#1077#1088#1077
        TabOrder = 5
      end
      object cbxAutoCloseLoadingForm: TCheckBox
        Left = 5
        Top = 141
        Width = 242
        Height = 17
        Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' '#1079#1072#1082#1088#1099#1074#1072#1090#1100' '#1086#1082#1085#1086' '#1079#1072#1075#1088#1091#1079#1082#1080
        TabOrder = 6
      end
      object cbxShowLoadingForm: TCheckBox
        Left = 5
        Top = 121
        Width = 179
        Height = 17
        Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1086#1082#1085#1086' '#1079#1072#1075#1088#1091#1079#1082#1080
        TabOrder = 7
      end
      object cbxMinOnRun: TCheckBox
        Left = 5
        Top = 161
        Width = 305
        Height = 17
        Caption = #1057#1074#1086#1088#1072#1095#1080#1074#1072#1090#1100' '#1087#1088#1080' '#1085#1072#1095#1072#1083#1077' '#1079#1072#1075#1088#1091#1079#1082#1080
        TabOrder = 8
      end
      object hkApplication: THotKey
        Left = 104
        Top = 181
        Width = 105
        Height = 19
        HotKey = 0
        Modifiers = []
        TabOrder = 9
      end
      object cbxAlwaysInTray: TCheckBox
        Left = 5
        Top = 45
        Width = 252
        Height = 17
        Caption = #1042#1089#1077#1075#1076#1072' '#1087#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1079#1085#1072#1095#1077#1082' '#1074' System Tray'
        TabOrder = 10
      end
    end
    object TabSheet1: TTabSheet
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072
      object Label1: TLabel
        Left = 5
        Top = 12
        Width = 90
        Height = 13
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1072#1075#1077#1085#1090#1072':'
      end
      object Label15: TLabel
        Left = 5
        Top = 126
        Width = 104
        Height = 13
        Caption = #1055#1088#1080#1086#1088#1080#1090#1077#1090' '#1087#1086#1090#1086#1082#1086#1074':'
      end
      object Label16: TLabel
        Left = 272
        Top = 126
        Width = 37
        Height = 13
        Caption = 'Label16'
      end
      object Label7: TLabel
        Left = 5
        Top = 39
        Width = 67
        Height = 13
        Caption = #1042#1077#1088#1089#1080#1103' HTTP:'
      end
      object cbAgent: TComboBox
        Left = 103
        Top = 9
        Width = 145
        Height = 21
        ItemHeight = 13
        TabOrder = 0
        Text = 'Download'
        Items.Strings = (
          'Download'
          'Internet Explorer 6'
          'Internet Explorer 5'
          'Opera'
          'Mozilla')
      end
      object TrackBar: TTrackBar
        Left = 118
        Top = 122
        Width = 146
        Height = 29
        Max = 6
        Position = 1
        TabOrder = 1
        ThumbLength = 16
        OnChange = TrackBarChange
      end
      object cbxRedirect: TCheckBox
        Left = 5
        Top = 93
        Width = 145
        Height = 17
        Caption = #1056#1072#1079#1088#1077#1096#1080#1090#1100' Redirect'
        TabOrder = 2
      end
      object cbHttpVersion: TComboBox
        Left = 103
        Top = 35
        Width = 144
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 3
        Items.Strings = (
          'HTTP 1.0'
          'HTTP 1.1')
      end
      object cbxResumeLoad: TCheckBox
        Left = 5
        Top = 75
        Width = 364
        Height = 17
        Caption = #1055#1088#1086#1076#1086#1083#1078#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1077#1089#1083#1080' '#1089#1077#1088#1074#1077#1088' '#1085#1077' '#1087#1086#1076#1076#1077#1088#1078#1080#1074#1072#1077#1090' '#1076#1086#1082#1072#1095#1082#1091
        TabOrder = 4
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1055#1088#1086#1082#1089#1080
      ImageIndex = 2
      object cbxUseProxyLocal: TCheckBox
        Left = 5
        Top = 7
        Width = 361
        Height = 17
        Caption = #1053#1077' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1087#1088#1086#1082#1089#1080' '#1089#1077#1088#1074#1077#1088' '#1076#1083#1103' '#1083#1086#1082#1072#1083#1100#1085#1099#1093' '#1072#1076#1088#1077#1089#1086#1074
        TabOrder = 0
      end
      object GroupBox1: TGroupBox
        Left = 5
        Top = 56
        Width = 396
        Height = 83
        Caption = ' HTTP Proxy '
        TabOrder = 1
        object Label2: TLabel
          Left = 8
          Top = 25
          Width = 41
          Height = 13
          Caption = #1057#1077#1088#1074#1077#1088':'
        end
        object Label3: TLabel
          Left = 8
          Top = 52
          Width = 29
          Height = 13
          Caption = #1055#1086#1088#1090':'
        end
        object Label4: TLabel
          Left = 182
          Top = 25
          Width = 76
          Height = 13
          Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100':'
        end
        object Label5: TLabel
          Left = 182
          Top = 52
          Width = 41
          Height = 13
          Caption = #1055#1072#1088#1086#1083#1100':'
        end
        object edHTTPProxyHost: TEdit
          Left = 53
          Top = 22
          Width = 121
          Height = 21
          TabOrder = 0
        end
        object edHTTPProxyPort: TEdit
          Left = 53
          Top = 50
          Width = 121
          Height = 21
          TabOrder = 1
        end
        object edHTTPProxyUser: TEdit
          Left = 265
          Top = 21
          Width = 121
          Height = 21
          TabOrder = 2
        end
        object edHTTPProxyPass: TEdit
          Left = 265
          Top = 50
          Width = 121
          Height = 21
          TabOrder = 3
        end
      end
      object GroupBox2: TGroupBox
        Left = 5
        Top = 170
        Width = 396
        Height = 83
        Caption = ' FTP Proxy '
        TabOrder = 2
        object Label8: TLabel
          Left = 8
          Top = 25
          Width = 41
          Height = 13
          Caption = #1057#1077#1088#1074#1077#1088':'
        end
        object Label9: TLabel
          Left = 8
          Top = 52
          Width = 29
          Height = 13
          Caption = #1055#1086#1088#1090':'
        end
        object Label10: TLabel
          Left = 182
          Top = 25
          Width = 76
          Height = 13
          Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100':'
        end
        object Label11: TLabel
          Left = 182
          Top = 52
          Width = 41
          Height = 13
          Caption = #1055#1072#1088#1086#1083#1100':'
        end
        object edFTPProxyHost: TEdit
          Left = 53
          Top = 22
          Width = 121
          Height = 21
          TabOrder = 0
        end
        object edFTPProxyPort: TEdit
          Left = 53
          Top = 50
          Width = 121
          Height = 21
          TabOrder = 1
        end
        object edFTPProxyUser: TEdit
          Left = 265
          Top = 21
          Width = 121
          Height = 21
          TabOrder = 2
        end
        object edFTPProxyPass: TEdit
          Left = 265
          Top = 50
          Width = 121
          Height = 21
          TabOrder = 3
        end
      end
      object cbUseFTPProxy: TCheckBox
        Left = 5
        Top = 146
        Width = 220
        Height = 17
        Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' FTP '#1087#1088#1086#1082#1089#1080'-'#1089#1077#1088#1074#1077#1088
        TabOrder = 3
      end
      object cbUseHTTPProxy: TCheckBox
        Left = 5
        Top = 34
        Width = 198
        Height = 17
        Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' HTTP '#1087#1088#1086#1082#1089#1080'-'#1089#1077#1088#1074#1077#1088
        TabOrder = 4
      end
    end
  end
end
