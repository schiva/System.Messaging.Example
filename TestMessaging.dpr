program TestMessaging;

uses
  Vcl.Forms,
  fmMessageMain_ in 'fmMessageMain_.pas' {fmMessageMain},
  fmChild_ in 'fmChild_.pas' {fmChild},
  DataPacket in 'DataPacket.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMessageMain, fmMessageMain);
  Application.CreateForm(TfmChild, fmChild);
  Application.Run;
end.
