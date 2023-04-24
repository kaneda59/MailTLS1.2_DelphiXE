unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, SynCommons, SynCrtSock, synautil, synacode, synaip, synamisc,
  ssl_openssl, Forms, ssl_openssl_lib, blcksock, dialogs, variants,
  IdSMTP,
  IdSSLOpenSSL,
  IdMessage,
  IdAttachment,
  IdComponent,
  IdExplicitTLSClientServerBase,
  IdEmailAddress,
  IdSMTPBase,
  TypInfo, StdCtrls, Controls, ExtCtrls, ComCtrls;
type
  TforMain = class(TForm)
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    edTarget: TEdit;
    Label1: TLabel;
    edPort: TEdit;
    Label2: TLabel;
    Panel2: TPanel;
    edUserName: TEdit;
    edPassword: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    edtTo: TEdit;
    edtFrom: TEdit;
    Label7: TLabel;
    edtSubject: TEdit;
    cmbComposant: TComboBox;
    Label8: TLabel;
    btnAddFile: TButton;
    PageControl: TPageControl;
    tbsObject: TTabSheet;
    tbsLogs: TTabSheet;
    edObject: TMemo;
    mmTraces: TMemo;
    StatusBar1: TStatusBar;
    Panel3: TPanel;
    btnSend: TButton;
    gnTLS: TGroupBox;
    Label9: TLabel;
    cbUseTLS: TComboBox;
    Label10: TLabel;
    cbAuthType: TComboBox;
    Label11: TLabel;
    cbSSLVersion: TComboBox;
    cbSSLMode: TComboBox;
    GroupBox2: TGroupBox;
    cbSSLVfrPeer: TCheckBox;
    cbSSLvfrFailIfNoPeer: TCheckBox;
    cbSSLvfrClientOnce: TCheckBox;
    procedure btnSendClick(Sender: TObject);
  private
     ListFile : TStringList;
    function SendEmailUsingTLS12: Boolean;
    function CreateData: TStringList;
    function sendWithSynapse: Boolean;
    function sendWithIndy: Boolean;
    function sendWithICS: Boolean;
    procedure OnStatus(Asender: TObject; const aStatus: TIdStatus;
      const aStatusText: string);
    procedure OnTLSNotAvailable(Asender : TObject; var VContinue : Boolean);
    procedure OnFailedRecipient(Sender: TObject; const AAddress, ACode,
      AText: String; var VContinue: Boolean);
    procedure OnFailedEHLO(Sender: TObject; const ACode, AText: String;
      var VContinue: Boolean);
    procedure OnTLSHandShakeFailed(Asender: TObject; var VContinue: Boolean);
    procedure OnTLSNegCmdFailed(Asender: TObject; var VContinue: Boolean);
    procedure OnWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
    function controlIsOk: Boolean;
    function setFocusError(obj: TwinControl; msg: string): Boolean;
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  forMain: TforMain;

implementation

{$R *.dfm}
  uses OverbyteIcsSmtpProt, OverbyteIcsMimeUtils;//smtpsend;
  { uses smtpSend;  mORMot 2.0 }

function PropertyExists(const AComponent: TComponent; const APropName: string): Boolean;
var
  PropInfo: PPropInfo;
begin
  PropInfo := GetPropInfo(AComponent.ClassInfo, APropName);
  Result := Assigned(PropInfo) and (PropInfo^.GetProc <> nil);
end;


function TforMain.setFocusError(obj: TwinControl; msg: string): Boolean;
var error: boolean;
begin
  result:= False;
  if obj is TMemo then
       error := TMemo(obj).Lines.Text=''
  else error := varToStr(getPropValue(obj, 'text'))='';
  if error then
  begin
    MessageDLG(msg, mtWarning, [mbYes], 0);
    if obj.Visible then
       obj.SetFocus;
    result:= True;
  end;
end;

function TforMain.controlIsOk: Boolean;
begin
  result:= (not setFocusError(edTarget, 'vous devez spécifier un serveur')) and
           (not setFocusError(edPort, 'vous devez spécifier un port')) and
           (not setFocusError(edUserName, 'vous devez spécifier un nom d''utilisateur')) and
           (not setFocusError(edPassword, 'vous devez spécifier un mot de passe')) and
           (not setFocusError(edtTo, 'vous devez spécifier un expéditeur')) and
           (not setFocusError(edtFrom, 'vous devez spécifier un destinataire')) and
           (not setFocusError(edtSubject, 'vous devez spécifier un sujet')) and
           (not setFocusError(edObject, 'vous devez saisir un objet'));
end;

procedure TforMain.btnSendClick(Sender: TObject);
begin
  PageControl.TabIndex:= 0;
  if controlIsOk then
  begin
    SendEmailUsingTLS12;
    PageControl.TabIndex:= 1;
  end;
end;

function TforMain.CreateData: TStringList;
begin
  result:= TStringList.Create;
  result.Add('From: ' + edtFrom.Text);
  result.Add('To: ' + edtTo.Text);
  result.Add('Subject: ' + edtSubject.Text);
  result.Add('');
  result.Add(edObject.Lines.Text);
end;

procedure TforMain.OnStatus(Asender: TObject; const aStatus: TIdStatus; const aStatusText: string);
begin
  StatusBar1.SimpleText:= 'status : ' + getEnumName(TypeInfo(TIdStatus), Ord(aStatus)) + ' : ' + astatusText;
end;

procedure TforMain.OnTLSNotAvailable(Asender: TObject; var VContinue: Boolean);
begin
  mmTraces.Lines.Add('TLS Not Available');
  VContinue := True;
end;

procedure TforMain.OnFailedRecipient(Sender: TObject; const AAddress, ACode, AText: String;
    var VContinue: Boolean);
begin
  mmTraceS.Lines.Add('Failed Recipient : ' + AAddress + ' : ' + ACode + ' - ' + AText);
  VContinue:= True;
end;

procedure TforMain.OnFailedEHLO(Sender: TObject; const ACode, AText: String;
    var VContinue: Boolean);
begin
  mmTraceS.Lines.Add('Failed EHLO : ' + ACode + ' - ' + AText);
  VContinue:= True;
end;

procedure TforMain.OnTLSHandShakeFailed(Asender : TObject; var VContinue : Boolean);
begin
  mmTraceS.Lines.Add('Failed TLS HandShake');
  VContinue:= True;
end;

procedure TforMain.OnTLSNegCmdFailed(Asender : TObject; var VContinue : Boolean);
begin
  mmTraceS.Lines.Add('Failed TLS Neg Cmd');
  VContinue:= True;
end;

procedure TforMain.OnWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
begin
  mmTraceS.Lines.Add('Mode : ' + getEnumName(TypeInfo(TWorkMode), Ord(AWorkMode)));
  mmTraces.Lines.Add('Count: ' + intToStr(aWorkCount));
end;

procedure SendEmailWithTLS(const AHost: string; APort: Integer; const AFrom, ATo, AUserName, APassword: string; const ASubject, ABody: string; const AFiles: TArray<string>);
var
  IdSMTP: TIdSMTP;
  IdSSL: TIdSSLIOHandlerSocketOpenSSL;
  IdMessage: TIdMessage;
  IdAttachment: TIdAttachment;
  I: Integer;
  SSLModeSet: TIdSSLVerifyModeSet;
begin
  IdSMTP         := TIdSMTP.Create(nil);
  IdSSL          := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  IdMessage      := TIdMessage.Create(nil);
  try
    IdSMTP.IOHandler := IdSSL;
    IdSMTP.UseTLS    := TIdUseTLS(ForMain.cbUseTLS.ItemIndex); //utUseExplicitTLS;
    IdSMTP.AuthType  := TIdSMTPAuthenticationType(ForMain.cbAuthType.ItemIndex); // satDefault;
    IdSMTP.Host      := AHost;
    IdSMTP.Port      := APort;
    IdSMTP.Username  := AUserName;
    IdSMTP.Password  := APassword;

    // affectation de quelques events pour déterminer le bon cheminement de la trame d'envoie
    IdSMTP.OnStatus := ForMain.OnStatus;
    IdSMTP.OnTLSNotAvailable   := ForMain.OnTLSNotAvailable;
    IdSMTP.OnFailedRecipient   := ForMain.OnFailedRecipient;
    IdSMTP.OnFailedEHLO        := ForMain.OnFailedEHLO;
    IdSMTP.OnTLSHandShakeFailed:= ForMain.OnTLSHandShakeFailed;
    IdSMTP.OnTLSNegCmdFailed   := ForMain.OnTLSNegCmdFailed;
    IdSMTP.OnWork              := ForMain.OnWork;

    IdSSL.SSLOptions.Method     := TIdSSLVersion(ForMain.cbSSLVersion.ItemIndex); //sslvTLSv1_2;
    IdSSL.SSLOptions.Mode       := TidSSLMode(ForMain.cbSSLMode.ItemIndex); // sslmUnassigned;

    SSLModeSet:= [];

    if ForMain.cbSSLvfrPeer.checked         then SSLModeSet := SSLModeSet + [sslvrfPeer];
    if ForMain.cbSSLvfrFailIfNoPeer.Checked then SSLModeSet := SSLModeSet + [sslvrfFailIfNoPeerCert];
    if ForMain.cbSSLvfrClientOnce.Checked   then SSLModeSet := SSLModeSet + [sslvrfClientOnce];

    IdSSL.SSLOptions.VerifyMode := SSLModeSet;
    IdSSL.SSLOptions.VerifyDepth:= 0;
    IdSSL.Host                  := '';

    IdMessage.From.Text := AFrom;
    IdMessage.Recipients.EMailAddresses:= ATo;
    IdMessage.Subject   := ASubject;
    IdMessage.Body.Text := ABody;
    IdMessage.Date      := Now;
    IdMessage.priority  := mpNormal;
    IdMessage.ContentType:= 'multipart/mixed';

//    for I := Low(AFiles) to High(AFiles) do
//    begin
//      IdAttachment := TIdAttachment.Create(IdMessage.MessageParts, AFiles[I]);
//    end;

    if Length(AFiles)>0 then
    begin
      IdAttachment := TIdAttachment.Create(IdMessage.MessageParts);
      // Ajouter chaque fichier à la collection
      for I := Low(AFiles) to High(AFiles) do
      begin
        IdAttachment.LoadFromFile(AFiles[I]);
      end;
    end;

    try
      IdSMTP.Connect;
      try
        IdSMTP.Authenticate;
        try
          IdSMTP.Send(IdMessage);
        except
          on e: Exception do
            ForMain.mmTraces.Lines.Add('erreur lors de l''envoie : ' + e.Message);
        end;
      finally
        IdSMTP.Disconnect;
      end;
    except
      on e: Exception do
        forMain.mmTraces.Lines.Add('erreur de connexion : ' + e.Message);
    end;
  finally
    IdSMTP.Free;
    IdSSL.Free;
    IdMessage.Free;
  end;
end;

//function TForm1.sendWithSynapse : Boolean;
//var
//  SSL: PSSL;
//  email: TSMTPSend;
//  data: TStringList;
//begin
//  result:= False;
//  email:= TSMTPSend.Create;
//  try
//    // Remplir les paramètres du serveur SMTP
//    try
//    email.TargetHost := edTarget.Text; // 'smtp.ionos.fr';
//    email.TargetPort := edPort.Text; //'465';
//    email.UserName   := edUserName.Text; //'autovpc@bsl-log.fr';
//    email.Password   := edPassword.Text; //'autovpcbsl';
//
//    // Envoyer l'e-mail
//
//    begin
//      email.AutoTLS  := True;
//      email.Sock.SSL.SSLType := LT_all;
//      data:= CreateData;
//      try
//        email.MailData(data);
//        if email.Login then
//              email.Logout
//        else  ShowMessage(Format('erreur %d : %s', [email.ResultCode, email.ResultString]));
//        result:= True;
//      finally
//        FreeAndNil(data);
//      end;
//    end
//    except
//      on e: Exception do
//        ShowMessage(Format('erreur %d : %s - %s', [email.ResultCode, email.ResultString, e.Message]));
//    end;
//
//  finally
//    // Libérer l'objet TSMTPSend
//    email.Free;
//  end;
//end;

//function Tform1.sendWithIndy: Boolean;
//var
//  IdSMTP: TIdSMTP;
//  IdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
//  IdMessage: TIdMessage;
//begin
//  Result := False;
//
//  IdSMTP := TIdSMTP.Create(nil);
//  IdSSLIOHandlerSocketOpenSSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
//  IdMessage := TIdMessage.Create(nil);
//
//  try
//    // Set SMTP properties
//    IdSMTP.Host     := edTarget.Text;
//    IdSMTP.Port     := strToInt(edPort.Text);
//    IdSMTP.Username := edUserName.Text;
//    IdSMTP.Password := edPassword.Text;
//    IdSMTP.UseTLS   := utUseExplicitTLS;
//
//    // Set SSL properties
//    IdSSLIOHandlerSocketOpenSSL.SSLOptions.Method := sslvTLSv1_2;
//    IdSMTP.IOHandler := IdSSLIOHandlerSocketOpenSSL;
//
//    // Set message properties
//    IdMessage.From.Address           := AFrom;
//    IdMessage.Recipients.Add.Address := ATo;
//    IdMessage.Subject                := ASubject;
//    IdMessage.Body.Text              := ABody;
//
//    // Connect and send message
//    IdSMTP.Connect;
//    try
//      IdSMTP.Authenticate;
//      IdSMTP.Send(IdMessage);
//    finally
//      IdSMTP.Disconnect;
//    end;
//
//    Result := True;
//  finally
//    IdSMTP.Free;
//    IdSSLIOHandlerSocketOpenSSL.Free;
//    IdMessage.Free;
//  end;
//end;

function TforMain.sendWithICS: Boolean;
//var
//  SMTP: TSMTPCli;
//  Msg: TStringList;
begin
//  SMTP := TSMTPCli.Create(nil);
//  try
//    SMTP.Host:= 'smtp.example.com';
//    SMTP.Port := '587';
//    SMTP.UserName := 'yourusername';
//    SMTP.Password := 'yourpassword';
//    SMTP.RequestType.  := stUseExplicitTLS;
//
//    Msg := TStringList.Create;
//    try
//      // Set email headers
//      Msg.Add('From: youremail@example.com');
//      Msg.Add('To: recipient@example.com');
//      Msg.Add('Subject: Test email with attachment');
//      Msg.Add('MIME-Version: 1.0');
//      Msg.Add('Content-Type: multipart/mixed; boundary="boundary1"');
//      Msg.Add('');
//      // Set message body
//      Msg.Add('--boundary1');
//      Msg.Add('Content-Type: text/plain; charset=ISO-8859-1');
//      Msg.Add('');
//      Msg.Add('This is a test email with attachment.');
//      Msg.Add('');
//      // Set attachment
//      Msg.Add('--boundary1');
//      Msg.Add('Content-Type: application/octet-stream');
//      Msg.Add('Content-Disposition: attachment; filename="test.txt"');
//      Msg.Add('');
//      Msg.Add('Hello, world!');
//      Msg.Add('');
//      Msg.Add('--boundary1--');
//
//      SMTP.Connect;
//      try
//        SMTP.MailFrom('youremail@example.com');
//        SMTP.RcptTo('recipient@example.com');
//        SMTP.MailData(Msg);
//      finally
//        SMTP.Disconnect;
//      end;
//    finally
//      Msg.Free;
//    end;
//  finally
//    SMTP.Free;
//  end;
end;

function TforMain.sendWithIndy: Boolean;
var files: TArray<string>;
begin
  SendEmailWithTLS(edTarget.Text, strToInt(edPort.Text), edtFrom.Text, edtTo.Text, edUserName.Text, edPassword.Text, edtSubject.Text,
  edObject.Lines.Text, files);
end;

function TforMain.sendWithSynapse: Boolean;
begin

end;

function TforMain.SendEmailUsingTLS12: Boolean;
begin
  case cmbComposant.ItemIndex of
       2 : result:= sendWithICS;
       0 : result:= sendWithIndy;
       1 : result:= sendWithSynapse;
  end;
end;


end.
