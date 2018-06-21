object frmNastaveni: TfrmNastaveni
  Left = 397
  Height = 322
  Top = 200
  Width = 354
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Nastavení'
  ClientHeight = 322
  ClientWidth = 354
  OnCreate = FormCreate
  OnShow = FormShow
  SessionProperties = 'lblEditIpAdress.Text;lblEditMacAdresa.Text;lblEditNazevGigasetNet.Text;lblEditNazevLan.Text;lblEditPin.Text'
  LCLVersion = '1.5'
  object btnOk: TButton
    AnchorSideRight.Control = Owner
    AnchorSideRight.Side = asrBottom
    AnchorSideBottom.Control = btnCancel
    Left = 233
    Height = 39
    Top = 213
    Width = 101
    Anchors = [akRight, akBottom]
    BorderSpacing.Right = 20
    BorderSpacing.Bottom = 11
    Caption = 'OK'
    ModalResult = 1
    OnClick = btnOkClick
    TabOrder = 0
  end
  object btnCancel: TButton
    AnchorSideRight.Control = Owner
    AnchorSideRight.Side = asrBottom
    AnchorSideBottom.Control = Owner
    AnchorSideBottom.Side = asrBottom
    Left = 233
    Height = 39
    Top = 263
    Width = 101
    Anchors = [akRight, akBottom]
    BorderSpacing.Right = 20
    BorderSpacing.Bottom = 20
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    OnClick = btnCancelClick
    TabOrder = 1
  end
  object lblEditNazevLan: TLabeledEdit
    AnchorSideLeft.Control = Owner
    AnchorSideBottom.Control = lblEditIpAdress
    Left = 17
    Height = 29
    Top = 33
    Width = 177
    Anchors = [akLeft, akBottom]
    BorderSpacing.Left = 17
    BorderSpacing.Bottom = 31
    EditLabel.AnchorSideLeft.Control = lblEditNazevLan
    EditLabel.AnchorSideTop.Side = asrCenter
    EditLabel.AnchorSideRight.Control = lblEditNazevLan
    EditLabel.AnchorSideRight.Side = asrBottom
    EditLabel.AnchorSideBottom.Control = lblEditNazevLan
    EditLabel.Left = 17
    EditLabel.Height = 21
    EditLabel.Top = 9
    EditLabel.Width = 177
    EditLabel.Caption = 'LAN name:'
    EditLabel.ParentColor = False
    ReadOnly = True
    TabOrder = 2
  end
  object lblEditIpAdress: TLabeledEdit
    AnchorSideLeft.Control = Owner
    AnchorSideBottom.Control = lblEditNazevGigasetNet
    Left = 17
    Height = 29
    Top = 93
    Width = 177
    Anchors = [akLeft, akBottom]
    BorderSpacing.Left = 17
    BorderSpacing.Bottom = 31
    EditLabel.AnchorSideLeft.Control = lblEditIpAdress
    EditLabel.AnchorSideTop.Side = asrCenter
    EditLabel.AnchorSideRight.Control = lblEditIpAdress
    EditLabel.AnchorSideRight.Side = asrBottom
    EditLabel.AnchorSideBottom.Control = lblEditIpAdress
    EditLabel.Left = 17
    EditLabel.Height = 21
    EditLabel.Top = 69
    EditLabel.Width = 177
    EditLabel.Caption = 'IP adress:'
    EditLabel.ParentColor = False
    ReadOnly = True
    TabOrder = 3
  end
  object lblEditNazevGigasetNet: TLabeledEdit
    AnchorSideLeft.Control = Owner
    AnchorSideBottom.Control = lblEditMacAdresa
    Left = 17
    Height = 29
    Top = 153
    Width = 177
    Anchors = [akLeft, akBottom]
    BorderSpacing.Left = 17
    BorderSpacing.Bottom = 31
    EditLabel.AnchorSideLeft.Control = lblEditNazevGigasetNet
    EditLabel.AnchorSideTop.Side = asrCenter
    EditLabel.AnchorSideRight.Control = lblEditNazevGigasetNet
    EditLabel.AnchorSideRight.Side = asrBottom
    EditLabel.AnchorSideBottom.Control = lblEditNazevGigasetNet
    EditLabel.Left = 17
    EditLabel.Height = 21
    EditLabel.Top = 129
    EditLabel.Width = 177
    EditLabel.Caption = ' Gigaset.net name:'
    EditLabel.ParentColor = False
    ReadOnly = True
    TabOrder = 4
  end
  object lblEditMacAdresa: TLabeledEdit
    AnchorSideLeft.Control = Owner
    AnchorSideBottom.Control = lblEditPin
    Left = 17
    Height = 29
    Top = 213
    Width = 177
    Anchors = [akLeft, akBottom]
    BorderSpacing.Left = 17
    BorderSpacing.Bottom = 31
    EditLabel.AnchorSideLeft.Control = lblEditMacAdresa
    EditLabel.AnchorSideTop.Side = asrCenter
    EditLabel.AnchorSideRight.Control = lblEditMacAdresa
    EditLabel.AnchorSideRight.Side = asrBottom
    EditLabel.AnchorSideBottom.Control = lblEditMacAdresa
    EditLabel.Left = 17
    EditLabel.Height = 21
    EditLabel.Top = 189
    EditLabel.Width = 177
    EditLabel.Caption = 'MAC adresa:'
    EditLabel.ParentColor = False
    ReadOnly = True
    TabOrder = 5
  end
  object lblEditPin: TLabeledEdit
    AnchorSideLeft.Control = Owner
    AnchorSideRight.Control = btnCancel
    AnchorSideBottom.Control = Owner
    AnchorSideBottom.Side = asrBottom
    Left = 17
    Height = 29
    Top = 273
    Width = 178
    Anchors = [akLeft, akBottom]
    BorderSpacing.Left = 17
    BorderSpacing.Right = 43
    BorderSpacing.Bottom = 20
    EditLabel.AnchorSideLeft.Control = lblEditPin
    EditLabel.AnchorSideTop.Side = asrCenter
    EditLabel.AnchorSideRight.Control = lblEditPin
    EditLabel.AnchorSideRight.Side = asrBottom
    EditLabel.AnchorSideBottom.Control = lblEditPin
    EditLabel.Left = 17
    EditLabel.Height = 21
    EditLabel.Top = 249
    EditLabel.Width = 178
    EditLabel.Caption = 'PIN:'
    EditLabel.ParentColor = False
    TabOrder = 6
  end
  object btnZjistiIP: TKBitBtn
    AnchorSideLeft.Control = lblEditNazevLan
    AnchorSideLeft.Side = asrBottom
    AnchorSideTop.Control = Owner
    AnchorSideRight.Control = Owner
    AnchorSideRight.Side = asrBottom
    AnchorSideBottom.Control = btnOk
    Left = 233
    Height = 89
    Top = 33
    Width = 101
    Anchors = []
    Caption = 'Detect telephone base IP'
    Font.Color = clBtnText
    ParentFont = False
    TabOrder = 7
    OnClick = btnZjistiIPClick
    WordWrap = True
  end
  object ulozeniNastaveniDoIni: TIniPropStorage
    StoredValues = <>
    IniFileName = 'settings.ini'
    left = 232
    top = 128
  end
  object DCP_twofish1: TDCP_twofish
    Id = 6
    Algorithm = 'Twofish'
    MaxKeySize = 256
    BlockSize = 128
    left = 296
    top = 152
  end
end
