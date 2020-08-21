object Frm_Options: TFrm_Options
  Left = 401
  Top = 234
  BorderStyle = bsDialog
  Caption = #1054#1087#1094#1080#1080
  ClientHeight = 417
  ClientWidth = 483
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object PC_OptionsGroup: TPageControl
    Left = 0
    Top = 0
    Width = 483
    Height = 369
    ActivePage = TabSheet3
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #1057#1086#1077#1076#1080#1085#1077#1085#1080#1077
      object GB_BDConn: TGroupBox
        Left = 8
        Top = 8
        Width = 465
        Height = 121
        Caption = #1057#1086#1077#1076#1080#1085#1077#1085#1080#1077' '#1089' '#1041#1044
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object L_Adress: TLabel
          Left = 8
          Top = 24
          Width = 56
          Height = 20
          Caption = #1040#1076#1088#1077#1089' :'
        end
        object L_LoginBD: TLabel
          Left = 8
          Top = 56
          Width = 54
          Height = 20
          Caption = #1051#1086#1075#1080#1085' :'
        end
        object L_PasswordBD: TLabel
          Left = 8
          Top = 88
          Width = 66
          Height = 20
          Caption = #1055#1072#1088#1086#1083#1100' :'
        end
        object E_AdressIp: TEdit
          Left = 200
          Top = 24
          Width = 249
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnKeyPress = E_AdressIpKeyPress
        end
        object E_LoginBd: TEdit
          Left = 200
          Top = 56
          Width = 249
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnKeyPress = E_LoginBdKeyPress
        end
        object E_PasswordBD: TEdit
          Left = 200
          Top = 88
          Width = 249
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          PasswordChar = '*'
          TabOrder = 2
          OnKeyPress = E_PasswordBDKeyPress
        end
      end
      object GB_FTPConn: TGroupBox
        Left = 8
        Top = 149
        Width = 465
        Height = 161
        Caption = #1057#1086#1077#1076#1080#1085#1077#1085#1080#1077' '#1089' '#1060#1058#1055
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        object L_AdressFTP: TLabel
          Left = 8
          Top = 32
          Width = 56
          Height = 20
          Caption = #1040#1076#1088#1077#1089' :'
        end
        object L_LoginFTP: TLabel
          Left = 8
          Top = 64
          Width = 54
          Height = 20
          Caption = #1051#1086#1075#1080#1085' :'
        end
        object L_PasswordFTP: TLabel
          Left = 8
          Top = 96
          Width = 66
          Height = 20
          Caption = #1055#1072#1088#1086#1083#1100' :'
        end
        object L_Path: TLabel
          Left = 8
          Top = 128
          Width = 45
          Height = 20
          Caption = #1055#1091#1090#1100' :'
        end
        object E_AdressFTP: TEdit
          Left = 200
          Top = 24
          Width = 249
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnKeyPress = E_AdressFTPKeyPress
        end
        object E_LoginFTP: TEdit
          Left = 200
          Top = 56
          Width = 249
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnKeyPress = E_LoginFTPKeyPress
        end
        object E_PasswordFTP: TEdit
          Left = 200
          Top = 88
          Width = 249
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          PasswordChar = '*'
          TabOrder = 2
          OnKeyPress = E_PasswordFTPKeyPress
        end
        object E_PathFTP: TEdit
          Left = 200
          Top = 120
          Width = 249
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnKeyPress = E_PathFTPKeyPress
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1054#1073#1097#1080#1077
      ImageIndex = 1
      object Label1: TLabel
        Left = 8
        Top = 16
        Width = 182
        Height = 20
        Caption = #1063#1072#1089#1090#1086#1090#1072' '#1086#1087#1088#1086#1089#1072' ('#1074' '#1089#1077#1082'): '
      end
      object E_PeriodTime: TEdit
        Left = 216
        Top = 16
        Width = 257
        Height = 24
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnKeyPress = E_PeriodTimeKeyPress
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'CVSFile'
      ImageIndex = 2
      object CB_SelectCVS: TCheckBox
        Left = 8
        Top = 8
        Width = 209
        Height = 17
        Caption = #1042#1099#1073#1080#1088#1072#1090#1100' '#1074' CVS '#1092#1072#1081#1083'?'
        TabOrder = 0
        OnClick = CB_SelectCVSClick
      end
      object GB_IDOperators: TGroupBox
        Left = 0
        Top = 40
        Width = 473
        Height = 137
        Caption = #1048#1044' '#1086#1087#1077#1088#1072#1090#1086#1088#1086#1074' '#1076#1083#1103' '#1074#1099#1073#1086#1082#1080
        Enabled = False
        TabOrder = 1
        object LB_OperatorIDList: TListBox
          Left = 8
          Top = 24
          Width = 321
          Height = 97
          Enabled = False
          ItemHeight = 20
          TabOrder = 0
        end
        object B_Add: TButton
          Left = 344
          Top = 24
          Width = 121
          Height = 25
          Caption = #1044#1086#1073#1072#1074#1080#1090#1100
          Enabled = False
          TabOrder = 1
          OnClick = B_AddClick
        end
        object B_Edit: TButton
          Left = 344
          Top = 56
          Width = 121
          Height = 25
          Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100
          Enabled = False
          TabOrder = 2
          OnClick = B_EditClick
        end
        object B_Delete: TButton
          Left = 344
          Top = 88
          Width = 121
          Height = 25
          Caption = #1059#1076#1072#1083#1080#1090#1100
          Enabled = False
          TabOrder = 3
          OnClick = B_DeleteClick
        end
      end
      object GB_Fields: TGroupBox
        Left = 0
        Top = 184
        Width = 473
        Height = 145
        Caption = #1055#1086#1083#1103' '#1076#1083#1103' '#1074#1099#1073#1086#1082#1080
        Enabled = False
        TabOrder = 2
        object CB_TerminalID: TCheckBox
          Left = 8
          Top = 80
          Width = 97
          Height = 17
          Caption = 'TerminalID'
          Enabled = False
          TabOrder = 0
          OnClick = CB_Click
        end
        object CB_AmountAll: TCheckBox
          Left = 248
          Top = 56
          Width = 97
          Height = 17
          Caption = 'AmountAll'
          Enabled = False
          TabOrder = 1
          OnClick = CB_Click
        end
        object CB_InitDateTime: TCheckBox
          Left = 248
          Top = 104
          Width = 113
          Height = 17
          Caption = 'InitDateTime'
          Enabled = False
          TabOrder = 2
          OnClick = CB_Click
        end
        object CB_PaymentDateTime: TCheckBox
          Left = 248
          Top = 80
          Width = 153
          Height = 17
          Caption = 'PaymentDateTime'
          Enabled = False
          TabOrder = 3
          OnClick = CB_Click
        end
        object CB_All: TCheckBox
          Left = 8
          Top = 32
          Width = 169
          Height = 17
          Caption = #1042#1099#1073#1086#1088'/'#1086#1090#1084#1077#1085#1072' '#1074#1089#1077#1093
          Enabled = False
          TabOrder = 4
          OnClick = CB_AllClick
        end
        object CB_InitialSession: TCheckBox
          Left = 8
          Top = 56
          Width = 177
          Height = 17
          Caption = 'InitialSessionNumber'
          TabOrder = 5
          OnClick = CB_Click
        end
        object CB_Params: TCheckBox
          Left = 8
          Top = 104
          Width = 97
          Height = 17
          Caption = 'Params'
          TabOrder = 6
          OnClick = CB_Click
        end
      end
    end
  end
  object B_Use: TButton
    Left = 400
    Top = 384
    Width = 75
    Height = 25
    Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100
    TabOrder = 1
    OnClick = B_UseClick
  end
  object B_Cancel: TButton
    Left = 312
    Top = 384
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 2
  end
  object B_Ok: TButton
    Left = 224
    Top = 384
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 3
    OnClick = B_OkClick
  end
end
