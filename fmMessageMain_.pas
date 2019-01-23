unit fmMessageMain_;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Messaging, Vcl.StdCtrls;


type
  TfmMessageMain = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    procedure OnPacket(const Sender:TObject; const M:TMessage);
    procedure onMessage(const Sender: TObject; const M: TMessage);
    procedure onDataMessage(const Sender: TObject; const M: TMessage);

  public
    { Public declarations }
  end;

var
  fmMessageMain: TfmMessageMain;

implementation

{$R *.dfm}

uses fmChild_, DataPacket;

procedure TfmMessageMain.Button1Click(Sender: TObject);
begin
  fmChild.Show;
end;

procedure TfmMessageMain.Button2Click(Sender: TObject);
var
  MessageManager: TMessageManager;
  message: TMessage;
begin
  MessageManager := TMessageManager.DefaultManager;
  message := TMessage<String>.Create( 'Message data :' + formatDateTime('hh:nn:ss', now) );
  MessageManager.SendMessage(self, message, true);

end;

procedure TfmMessageMain.Button3Click(Sender: TObject);
var
  MessageManager: TMessageManager;
  message: TMessage;
  data: TDataPacket;
begin
  MessageManager := TMessageManager.DefaultManager;

  data := TDataPacket.Create;
  data.Data := formatDateTime('hh:nn:ss',now);
  data.x    := 101;
  data.y    := 301;

  message := TObjectMessage<TDataPacket>.Create(Data);

  MessageManager.SendMessage(self, message, true);
end;

procedure TfmMessageMain.Button4Click(Sender: TObject);
var
  th: TThread;
begin
  th := TThread.CreateAnonymousThread(procedure
  var
    MessageManager: TMessageManager;
    message: TMessage;
    data: TDataPacket;
  begin
    MessageManager := TMessageManager.DefaultManager;

    data := TDataPacket.Create;

    data.Data := format('From Thread [%d]:', [GetcurrentThreadid]) + formatDateTime('hh:nn:ss',now);
    data.x    := 1;
    data.y    := 1;

    message := TObjectMessage<TDataPacket>.Create(Data);

    MessageManager.SendMessage(self, message, true);

  end);
  th.Start;
end;

procedure TfmMessageMain.Button5Click(Sender: TObject);
var
  MessageManager: TMessageManager;
  message: TMessage;
  data: TStringList;
begin
  MessageManager := TMessageManager.DefaultManager;

  data := TStringList.Create;
  data.Values['Code'] := 'testcode';
  data.Values['Param1'] := 'test param1';
  data.Values['Param2'] := 'test param2';


  message := TObjectMessage<TStringList>.Create(Data);

  MessageManager.SendMessage(self, message, true);

end;

procedure TfmMessageMain.FormCreate(Sender: TObject);
var
  MessageManager: TMessageManager;
begin
  ReportMemoryLeaksOnShutdown := True;
  // ---------------------------------------------------------------------------
  MessageManager := TMessageManager.DefaultManager;
  MessageManager.SubscribeToMessage(TMessage<String>, onMessage);
  MessageManager.SubscribeToMessage(TObjectMessage<TDataPacket>, onDataMessage);
  MessageManager.SubscribeToMessage(TObjectMessage<TStringList>, onPacket);
end;

procedure TfmMessageMain.onDataMessage(const Sender: TObject; const M: TMessage);
var
  data: TDataPacket;
begin

  data := (m as TObjectMessage<TDataPacket>).Value;
  memo1.Lines.Add( 'main:' + GetCurrentThreadID.ToString + ' ' + data.Data + format(' x:%d, y=%d',[data.x, data.y]) );

end;

procedure TfmMessageMain.onMessage(const Sender: TObject; const M: TMessage);
begin
  Memo1.Lines.Add( (m as TMessage<String>).Value  );
end;

procedure TfmMessageMain.OnPacket(const Sender: TObject; const M: TMessage);
var
  data: TStringList;
begin
  data := (m as TObjectMessage<TStringList>).Value ;
  memo1.Lines.Add('TStringList Paceket ......');
  memo1.Lines.Add(data.Text);


end;

end.
