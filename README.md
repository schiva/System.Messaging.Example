# System.Messaging Example

# Form Create
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

# 수신분 이벤트 예제
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

# 발송 부분
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
