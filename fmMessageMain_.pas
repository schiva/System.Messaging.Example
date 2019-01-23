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
    Button6: TButton;
    Button7: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
  private
    procedure OnMessageTStringList(const Sender:TObject; const M:TMessage);
    procedure OnMessageTStringList2(const Sender:TObject; const M:TMessage);
    procedure onMessageString(const Sender: TObject; const M: TMessage);
    procedure onMessageTCustomClass(const Sender: TObject; const M: TMessage);

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

procedure TfmMessageMain.Button6Click(Sender: TObject);
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

    TThread.Synchronize(nil, procedure
    begin
      data := TDataPacket.Create;
      data.Data := format('From Thread [%d]:', [GetcurrentThreadid]) + formatDateTime('hh:nn:ss',now);
      data.x    := 1;
      data.y    := 1;

      message := TObjectMessage<TDataPacket>.Create(Data);

      MessageManager.SendMessage(self, message, true);
    end);
  end);
  th.Start;

end;

procedure TfmMessageMain.Button7Click(Sender: TObject);
var
  MessageManager: TMessageManager;
  message: TMessage;
  AList: TStringList;
begin
  AList := TStringList.Create;
  AList.Values['Code'] := 'Test Code';
  AList.Values['Param'] := 'Test Param';

  MessageManager := TMessageManager.DefaultManager;
  message := TMessage<TStringList>.Create( AList );
  MessageManager.SendMessage(self, message, true);
  // TMessage<T> 형태는 수동으로 메모리 관리.
  AList.Free;

end;

procedure TfmMessageMain.FormCreate(Sender: TObject);
var
  MessageManager: TMessageManager;
begin
  ReportMemoryLeaksOnShutdown := True;
  // ---------------------------------------------------------------------------
  MessageManager := TMessageManager.DefaultManager;
  // ---------------------------------------------------------------------------
  // TMessge<T> : 객체의 자동 메모리 Free가 되지 않음. ( 수동으로 해야 함 )
  MessageManager.SubscribeToMessage(TMessage<String>, onMessageString);
  MessageManager.SubscribeToMessage(TMessage<TStringList>, OnMessageTStringList2);
  // TObjectMessage<T> : 객체의 자동 메모리 Free가 지원 됨.
  MessageManager.SubscribeToMessage(TObjectMessage<TDataPacket>, onMessageTCustomClass);

  // 익명 메소드 포인터 사용예.
  MessageManager.SubscribeToMessage(TObjectMessage<TStringList>, OnMessageTStringList);

  // 익명 메소드 포인터 없이 사용예.
  MessageManager.SubscribeToMessage(TObjectMessage<TStringList>,
    procedure (const Sender: TObject; const M: TMessage)
    var
      data: TStringList;
    begin
      data := (m as TObjectMessage<TStringList>).Value ;
      memo1.Lines.Add('TStringList Paceket ......');
      memo1.Lines.Add(data.Text);
    end);

end;

procedure TfmMessageMain.onMessageTCustomClass(const Sender: TObject; const M: TMessage);
var
  data: TDataPacket;
begin

  data := (m as TObjectMessage<TDataPacket>).Value;
  memo1.Lines.Add( 'main:' + GetCurrentThreadID.ToString + ' ' + data.Data + format(' x:%d, y=%d',[data.x, data.y]) );

end;

procedure TfmMessageMain.onMessageString(const Sender: TObject; const M: TMessage);
begin
  Memo1.Lines.Add( (m as TMessage<String>).Value  );
end;

procedure TfmMessageMain.OnMessageTStringList(const Sender: TObject; const M: TMessage);
var
  data: TStringList;
begin
  data := (m as TObjectMessage<TStringList>).Value ;
  memo1.Lines.Add('TStringList Paceket ......');
  memo1.Lines.Add(data.Text);


end;

procedure TfmMessageMain.OnMessageTStringList2(const Sender: TObject;
  const M: TMessage);
var
  data: TStringList;
begin
  data := (m as TMessage<TStringList>).Value;
  memo1.Lines.Add('TStringList Paceket ......');
  memo1.Lines.Add(data.Text);

end;

end.
