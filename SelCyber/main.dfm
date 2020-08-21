object Frm_Main: TFrm_Main
  Left = 257
  Top = 121
  Width = 942
  Height = 686
  Caption = #1042#1099#1073#1086#1088#1082#1072' '#1076#1072#1085#1085#1099#1093' '#1080#1079' CyberPlat'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MM_Menu
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object M_Log: TMemo
    Left = 0
    Top = 0
    Width = 934
    Height = 632
    Align = alClient
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object ADOC_BDCon: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=1;Persist Security Info=True' +
      ';User ID=1;Initial Catalog=Terminals;Data Source=1.1.1.1;' +
      'Use Procedure for Prepare=1;Auto Translate=True;Packet Size=4096' +
      ';Workstation ID=MIC;Use Encryption for Data=False;Ta' +
      'g with column collation when possible=False'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 8
    Top = 120
  end
  object DS_Payments: TDataSource
    DataSet = ADOQ_1
    Left = 8
    Top = 88
  end
  object ADOQ_1: TADOQuery
    Connection = ADOC_BDCon
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'SELECT p.InitialSessionNumber, t.Name, p.InitializeDateTime, p.P' +
        'arams, p.AmountAll, p.OperatorId'
      'FROM NewPayments p, terminals t'
      'where p.TerminalId = t.TerminalId'
      'AND p.OperatorID in ( 315, 500, 1024 )')
    Left = 8
    Top = 48
  end
  object T_Request: TTimer
    Enabled = False
    Interval = 300000
    OnTimer = T_RequestTimer
    Left = 8
    Top = 152
  end
  object IdFTP1: TIdFTP
    MaxLineAction = maException
    ReadTimeout = 0
    TransferType = ftASCII
    ProxySettings.ProxyType = fpcmNone
    ProxySettings.Port = 0
    Left = 48
    Top = 48
  end
  object PM_Tray: TPopupMenu
    Left = 48
    Top = 88
    object PMN_Enable: TMenuItem
      Caption = #1042#1082#1083#1102#1095#1080#1090#1100
      Enabled = False
      OnClick = PMN_EnableClick
    end
    object PMN_Disable: TMenuItem
      Caption = #1042#1099#1082#1083#1102#1095#1080#1090#1100
      OnClick = PMN_DisableClick
    end
    object PMN_Break1: TMenuItem
      Caption = '-'
    end
    object PMN_Options: TMenuItem
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
      OnClick = PMN_OptionsClick
    end
    object PMN_Break2: TMenuItem
      Caption = '-'
    end
    object PMN_Exit: TMenuItem
      Caption = #1042#1099#1093#1086#1076
      OnClick = PMN_ExitClick
    end
  end
  object XPM: TXPManifest
    Left = 8
    Top = 8
  end
  object MM_Menu: TMainMenu
    Left = 48
    Top = 16
    object N_File: TMenuItem
      Caption = #1060#1072#1081#1083
      object N_Enable: TMenuItem
        Caption = #1042#1082#1083#1102#1095#1080#1090#1100
        Enabled = False
        OnClick = PMN_EnableClick
      end
      object N_Disable: TMenuItem
        Caption = #1042#1099#1082#1083#1102#1095#1080#1090#1100
        OnClick = PMN_DisableClick
      end
      object N_Break1: TMenuItem
        Caption = '-'
      end
      object N_Exit: TMenuItem
        Caption = #1042#1099#1093#1086#1076
        OnClick = PMN_ExitClick
      end
    end
    object N_Options: TMenuItem
      Caption = #1054#1087#1094#1080#1080
      OnClick = PMN_OptionsClick
    end
  end
  object T_Ctrl: TTimer
    Enabled = False
    OnTimer = T_CtrlTimer
    Left = 48
    Top = 120
  end
  object ADOQ_2: TADOQuery
    Connection = ADOC_BDCon
    Parameters = <>
    Left = 88
    Top = 48
  end
end
