object forMain: TforMain
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'POC SENDING MAIL TLS 1.2'
  ClientHeight = 645
  ClientWidth = 645
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 645
    Height = 193
    Align = alTop
    TabOrder = 0
    object GroupBox1: TGroupBox
      Left = 1
      Top = 1
      Width = 643
      Height = 191
      Align = alClient
      Caption = ' Server Informations '
      TabOrder = 0
      object Label1: TLabel
        Left = 16
        Top = 32
        Width = 61
        Height = 13
        Caption = 'SMTP Server'
      end
      object Label2: TLabel
        Left = 464
        Top = 33
        Width = 20
        Height = 13
        Caption = 'Port'
      end
      object Label3: TLabel
        Left = 16
        Top = 64
        Width = 52
        Height = 13
        Caption = 'User Name'
      end
      object Label4: TLabel
        Left = 239
        Top = 64
        Width = 46
        Height = 13
        Caption = 'Password'
      end
      object edTarget: TEdit
        Left = 85
        Top = 29
        Width = 361
        Height = 21
        TabOrder = 0
        Text = 'smtp.ionos.fr'
      end
      object edPort: TEdit
        Left = 500
        Top = 30
        Width = 53
        Height = 21
        TabOrder = 1
        Text = '465'
      end
      object edUserName: TEdit
        Left = 88
        Top = 61
        Width = 144
        Height = 21
        TabOrder = 2
        Text = 'autovpc@bsl-log.fr'
      end
      object edPassword: TEdit
        Left = 296
        Top = 61
        Width = 150
        Height = 21
        PasswordChar = '*'
        TabOrder = 3
        Text = '2rUS+nB$G.kD!8sG'
      end
      object gnTLS: TGroupBox
        Left = 15
        Top = 97
        Width = 469
        Height = 87
        Caption = ' TLS '
        TabOrder = 4
        object Label9: TLabel
          Left = 15
          Top = 20
          Width = 18
          Height = 13
          Caption = 'Use'
        end
        object Label10: TLabel
          Left = 224
          Top = 20
          Width = 50
          Height = 13
          Caption = 'Auth Type'
        end
        object Label11: TLabel
          Left = 15
          Top = 51
          Width = 35
          Height = 13
          Caption = 'version'
        end
        object cbUseTLS: TComboBox
          Left = 65
          Top = 17
          Width = 144
          Height = 21
          Cursor = crHandPoint
          Style = csDropDownList
          ItemIndex = 1
          TabOrder = 0
          Text = 'Use Implicit TLS'
          Items.Strings = (
            'No TLS Support'
            'Use Implicit TLS'
            'Use Require TLS'
            'Use Explicit TLS ')
        end
        object cbAuthType: TComboBox
          Left = 281
          Top = 17
          Width = 150
          Height = 21
          Cursor = crHandPoint
          Style = csDropDownList
          ItemIndex = 1
          TabOrder = 1
          Text = 'Default'
          Items.Strings = (
            'None'
            'Default'
            'SASL')
        end
        object cbSSLVersion: TComboBox
          Left = 65
          Top = 47
          Width = 144
          Height = 21
          Cursor = crHandPoint
          Style = csDropDownList
          ItemIndex = 5
          TabOrder = 2
          Text = 'TLS v1.2'
          Items.Strings = (
            'SSL v2'
            'SSL v23'
            'SSL  v3'
            'TLS v1'
            'TLS v1.1'
            'TLS v1.2')
        end
        object cbSSLMode: TComboBox
          Left = 281
          Top = 48
          Width = 150
          Height = 21
          Cursor = crHandPoint
          Style = csDropDownList
          ItemIndex = 0
          TabOrder = 3
          Text = 'Unassigned'
          Items.Strings = (
            'Unassigned'
            'Client'
            'Server'
            'Both')
        end
      end
      object GroupBox2: TGroupBox
        Left = 489
        Top = 96
        Width = 148
        Height = 88
        Caption = 'SSL Mode Set '
        TabOrder = 5
        object cbSSLVfrPeer: TCheckBox
          Left = 19
          Top = 21
          Width = 97
          Height = 17
          Cursor = crHandPoint
          Caption = 'Peer'
          TabOrder = 0
        end
        object cbSSLvfrFailIfNoPeer: TCheckBox
          Left = 19
          Top = 42
          Width = 117
          Height = 17
          Cursor = crHandPoint
          Caption = 'Fail if No Peer cert'
          TabOrder = 1
        end
        object cbSSLvfrClientOnce: TCheckBox
          Left = 19
          Top = 63
          Width = 97
          Height = 17
          Cursor = crHandPoint
          Caption = 'Client Once'
          TabOrder = 2
        end
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 193
    Width = 645
    Height = 136
    Align = alTop
    TabOrder = 1
    object Label5: TLabel
      Left = 16
      Top = 45
      Width = 12
      Height = 13
      Caption = 'To'
    end
    object Label6: TLabel
      Left = 16
      Top = 19
      Width = 24
      Height = 13
      Caption = 'From'
    end
    object Label7: TLabel
      Left = 16
      Top = 104
      Width = 36
      Height = 13
      Caption = 'Subject'
    end
    object Label8: TLabel
      Left = 16
      Top = 75
      Width = 52
      Height = 13
      Caption = 'composant'
    end
    object edtTo: TEdit
      Left = 88
      Top = 45
      Width = 359
      Height = 21
      TabOrder = 1
    end
    object edtFrom: TEdit
      Left = 89
      Top = 16
      Width = 359
      Height = 21
      TabOrder = 0
      Text = 'autovpc@bsl-log.fr'
    end
    object edtSubject: TEdit
      Left = 89
      Top = 101
      Width = 520
      Height = 21
      TabOrder = 4
    end
    object cmbComposant: TComboBox
      Left = 88
      Top = 72
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 2
      Text = 'Indy'
      Items.Strings = (
        'Indy'
        'Synapse'
        'ICS')
    end
    object btnAddFile: TButton
      Left = 504
      Top = 64
      Width = 118
      Height = 25
      Caption = 'add file'
      TabOrder = 3
    end
  end
  object PageControl: TPageControl
    Left = 0
    Top = 329
    Width = 645
    Height = 256
    ActivePage = tbsObject
    Align = alClient
    TabOrder = 2
    object tbsObject: TTabSheet
      Caption = 'Objet'
      object edObject: TMemo
        Left = 0
        Top = 0
        Width = 637
        Height = 228
        Align = alClient
        TabOrder = 0
      end
    end
    object tbsLogs: TTabSheet
      Caption = 'Traces'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 627
      ExplicitHeight = 227
      object mmTraces: TMemo
        Left = 0
        Top = 0
        Width = 637
        Height = 228
        Align = alClient
        ReadOnly = True
        TabOrder = 0
        ExplicitLeft = 32
        ExplicitTop = 24
        ExplicitWidth = 185
        ExplicitHeight = 89
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 626
    Width = 645
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object Panel3: TPanel
    Left = 0
    Top = 585
    Width = 645
    Height = 41
    Align = alBottom
    BevelInner = bvLowered
    TabOrder = 4
    object btnSend: TButton
      Left = 504
      Top = 10
      Width = 118
      Height = 25
      Cursor = crHandPoint
      Caption = 'Send'
      TabOrder = 0
      OnClick = btnSendClick
    end
  end
end
