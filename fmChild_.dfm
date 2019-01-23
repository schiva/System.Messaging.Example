object fmChild: TfmChild
  Left = 0
  Top = 0
  Caption = 'fmChild'
  ClientHeight = 299
  ClientWidth = 484
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 16
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Send Message'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 16
    Top = 60
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 1
  end
  object Memo1: TMemo
    Left = 104
    Top = 18
    Width = 365
    Height = 273
    Lines.Strings = (
      'Memo1')
    TabOrder = 2
  end
end
