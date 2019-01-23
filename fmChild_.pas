unit fmChild_;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Messaging, Vcl.StdCtrls;

type
  TfmChild = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    procedure onMessage(const Sender: TObject; const M: TMessage);
    procedure onDataMessage(const Sender: TObject; const M: TMessage);
    procedure onPacket(const Sender: TObject; const M: TMessage);
    procedure OnMessageTStringList2(const Sender:TObject; const M:TMessage);
  public
    { Public declarations }
  end;

var
  fmChild: TfmChild;

implementation

{$R *.dfm}

uses DataPacket;

{ TfmChild }

procedure TfmChild.Button1Click(Sender: TObject);
var
  MessageManager: TMessageManager;
  message: TMessage;
begin
  MessageManager := TMessageManager.DefaultManager;
  message := TMessage<String>.Create( 'Message Child data :' + formatDateTime('hh:nn:ss', now) );
  MessageManager.SendMessage(self, message, true);
end;

procedure TfmChild.FormCreate(Sender: TObject);
var
  MessageManager: TMessageManager;
begin
  MessageManager := TMessageManager.DefaultManager;
  MessageManager.SubscribeToMessage(TMessage<String>, onMessage);
  MessageManager.SubscribeToMessage(TMessage<TStringlist>, OnMessageTStringList2);
  MessageManager.SubscribeToMessage(TObjectMessage<TDataPacket>, onDataMessage);
  MessageManager.SubscribeToMessage(TObjectMessage<TStringList>, onPacket);

end;

procedure TfmChild.onDataMessage(const Sender: TObject; const M: TMessage);
var
  data: TDataPacket;
begin

  data := (m as TObjectMessage<TDataPacket>).Value;
  memo1.Lines.Add( data.Data + format(' x:%d, y=%d',[data.x, data.y]) );

end;

procedure TfmChild.onMessage(const Sender: TObject; const M: TMessage);
begin
  Memo1.Lines.Add( (m as TMessage<String>).Value  );
end;

procedure TfmChild.OnMessageTStringList2(const Sender: TObject;
  const M: TMessage);
var
  data: TStringList;
begin
  data := (m as TMessage<TStringList>).Value ;
  memo1.Lines.Add('TStringList Paceket ......');
  memo1.Lines.Add(data.Text);


end;

procedure TfmChild.onPacket(const Sender: TObject; const M: TMessage);
var
  data: TStringList;
begin
  data := (m as TObjectMessage<TStringList>).Value ;
  memo1.Lines.Add('TStringList Paceket ......');
  memo1.Lines.Add(data.Text);

end;

end.
