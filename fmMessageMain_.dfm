object fmMessageMain: TfmMessageMain
  Left = 0
  Top = 0
  Caption = 'fmMessageMain'
  ClientHeight = 299
  ClientWidth = 480
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
    Left = 8
    Top = 16
    Width = 120
    Height = 25
    Caption = 'Show Child'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 8
    Top = 47
    Width = 120
    Height = 25
    Caption = 'Send Message'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Memo1: TMemo
    Left = 136
    Top = 18
    Width = 333
    Height = 273
    Lines.Strings = (
      'Memo1')
    TabOrder = 2
  end
  object Button3: TButton
    Left = 8
    Top = 78
    Width = 120
    Height = 25
    Caption = 'Send Message #2'
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 10
    Top = 146
    Width = 120
    Height = 25
    Caption = 'Send Message'#13#10'(Thread)'
    TabOrder = 4
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 8
    Top = 109
    Width = 120
    Height = 25
    Caption = 'Send Message #3'
    TabOrder = 5
    OnClick = Button5Click
  end
end
