object frmVyberHandsets: TfrmVyberHandsets
  Left = 817
  Height = 300
  Top = 148
  Width = 250
  HorzScrollBar.Page = 167
  VertScrollBar.Page = 141
  Anchors = []
  AutoScroll = True
  AutoSize = True
  Caption = 'Choose Handset'
  ChildSizing.EnlargeHorizontal = crsHomogenousSpaceResize
  ChildSizing.EnlargeVertical = crsHomogenousSpaceResize
  ChildSizing.ShrinkHorizontal = crsHomogenousSpaceResize
  ChildSizing.ShrinkVertical = crsHomogenousSpaceResize
  ClientHeight = 300
  ClientWidth = 250
  Constraints.MinHeight = 300
  Constraints.MinWidth = 250
  OnShow = FormShow
  LCLVersion = '1.5'
  object RadioGroup1: TRadioGroup
    Left = 64
    Height = 173
    Top = 55
    Width = 100
    Anchors = [akTop, akBottom]
    AutoFill = True
    AutoSize = True
    Caption = 'Handsets'
    ChildSizing.LeftRightSpacing = 6
    ChildSizing.EnlargeHorizontal = crsHomogenousChildResize
    ChildSizing.EnlargeVertical = crsHomogenousChildResize
    ChildSizing.ShrinkHorizontal = crsScaleChilds
    ChildSizing.ShrinkVertical = crsScaleChilds
    ChildSizing.Layout = cclLeftToRightThenTopToBottom
    ChildSizing.ControlsPerLine = 1
    Constraints.MinHeight = 100
    Constraints.MinWidth = 100
    TabOrder = 0
  end
  object OK: TButton
    AnchorSideTop.Control = RadioGroup1
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Side = asrBottom
    AnchorSideBottom.Side = asrBottom
    Left = 44
    Height = 46
    Top = 238
    Width = 82
    Anchors = [akTop, akBottom]
    BorderSpacing.Top = 10
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
  end
  object Cancel: TButton
    AnchorSideLeft.Control = OK
    AnchorSideTop.Control = RadioGroup1
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Side = asrBottom
    Left = 133
    Height = 46
    Top = 238
    Width = 78
    Anchors = [akTop, akLeft, akBottom]
    BorderSpacing.Left = 89
    BorderSpacing.Top = 10
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
