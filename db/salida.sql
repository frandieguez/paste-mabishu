BEGIN TRANSACTION;
CREATE TABLE `schema_migrations` (`version` varchar(255) NOT NULL);
INSERT INTO `schema_migrations` VALUES('20080702095542');
INSERT INTO `schema_migrations` VALUES('20080702095742');
INSERT INTO `schema_migrations` VALUES('20080702095832');
INSERT INTO `schema_migrations` VALUES('20080702095934');
INSERT INTO `schema_migrations` VALUES('20080702135203');
INSERT INTO `schema_migrations` VALUES('20080702194050');
INSERT INTO `schema_migrations` VALUES('20080702205248');
INSERT INTO `schema_migrations` VALUES('20080702232314');
DELETE FROM sqlite_sequence;
INSERT INTO `sqlite_sequence` VALUES('pastes',10);
INSERT INTO `sqlite_sequence` VALUES('paginas',3);
INSERT INTO `sqlite_sequence` VALUES('languages',16);
CREATE TABLE `pastes` (`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `content` text DEFAULT NULL NULL, `language_id` integer DEFAULT NULL NULL, `created_at` datetime DEFAULT NULL NULL, `updated_at` datetime DEFAULT NULL NULL);
INSERT INTO `pastes` VALUES(1,'print_r(`hola mundo`);',1,'2008-07-02 11:47:00','2008-07-02 11:47:00');
INSERT INTO `pastes` VALUES(2,'// isto é outra proba miña das que teño eu',1,'2008-07-02 12:30:39','2008-07-02 12:30:39');
INSERT INTO `pastes` VALUES(3,'#!/bin/bash
# Este script reiniciará el equipo después de 1 minuto al ejecutarlo como root.
if [ `$(whoami)` = ''root'' ] # Si el usuario que ejecuta el script es ''root''.
then
shutdown -r +1 # `-r` indica que la computadora se reiniciará. `+1` significa que la orden se llevará a cabo luego de 1 minuto.
else
echo `El script no se ejecutará porque usted no es usuario ''root''`. # Aparecerá este mensaje cuando se quiera ejecutar el script desde otro usuario que no sea el ''root''.
fi',7,'2008-07-02 12:43:14','2008-07-02 12:43:14');
INSERT INTO `pastes` VALUES(4,'void main(){
if (true){
   print(`hola`);
}else{
  print (`adios`);
}
}',3,'2008-07-02 14:32:02','2008-07-02 14:32:02');
INSERT INTO `pastes` VALUES(5,'W = 640
  H = 480
  Set Movie = CreateObject(`SWFScout.FlashMovie`)
  Movie.InitLibrary `demo`,`demo`
 
'' Movie creating and setting parameters
 
  Movie.BeginMovie 0,0,W,H,1,12,6
  Movie.Compressed = true
  Movie.SetBackgroundColor 255,255,255
 
 Font = Movie.AddFont( `Arial`,12,true,false,false,false,0)
 FontBig = Movie.AddFont(`Arial`,40,true,false,false,false,DEFAULT_CHARSET)
 
''================
'' ACTIONS
''=================
'' Moving ball responds on click
 
 
 Text = Movie.AddText (`Click on moving ball using mouse! Click count: `,0,0,0,255,Font, 0, 70, 600, 160)
 Movie.PlaceText Text,Movie.CurrentMaxDepth '' place text
 
 Text= Movie.AddTextEdit (`EditText`,`0`,255,100,0,255,Font,450,70,500,120)
 Movie.TEXT_ReadOnly= false
 Movie.TEXT_NoSelect= false
 Movie.PlaceText Text,Movie.CurrentMaxDepth
 
 Shape = Movie.AddShape
 Movie.SHAPE_Circle 0, 0, 20
 Movie.SHAPE_BeginRadialGradient
 Movie.SHAPE_AddRadialGradientColor 255,255,255,255
 Movie.SHAPE_AddRadialGradientColor 102,102,102,255
 Movie.SHAPE_EndRadialGradient 35,35
 
 Button = Movie.AddButton (false,true)
 Movie.BUTTON_AddShape Shape,0
 Movie.BUTTON_AddShape Shape,2
 Movie.BUTTON_AddShape Shape,3
 Movie.BUTTON_AddShape2 Shape,1,1,1,0,0,0,0,0,0,100,0,0,255,true
 
 Action= Movie.AddScript
 
 Movie.SCRIPT_Push `EditText`
 Movie.SCRIPT_GetVariable `EditText`
 Movie.SCRIPT_AddAction 75 '' sacttToInteger action ID is 45
 Movie.SCRIPT_Push 1
 Movie.SCRIPT_AddAction 1 '' sacttAdd2 action ID is 1
 Movie.SCRIPT_AddAction 59 '' sacttSetVariable action ID is 59',2,'2008-07-02 21:44:09','2008-07-02 21:44:09');
INSERT INTO `pastes` VALUES(6,'#import `MyDocument.h`

@implementation MyDocument

- (NSString *)windowNibName {
    return @`MyDocument`;
}

- (NSData *)dataRepresentationOfType:(NSString *)type {
    return nil;
}

- (BOOL)loadDataRepresentation:(NSData *)data ofType:(NSString *)type {
    return NO;
}


- (IBAction)chooseParser:(id)sender
{
    int result;
    NSArray *fileTypes = [NSArray arrayWithObject:@`hs`];
    NSOpenPanel *oPanel = [NSOpenPanel openPanel];
    
    result = [oPanel runModalForDirectory:nil file:nil types:fileTypes];
    if (result == NSOKButton)
    {
        NSArray *filesToOpen = [oPanel filenames];
        [parser setStringValue:[filesToOpen objectAtIndex:0]];
    }
}

- (IBAction)evaluateExpression:(id)sender
{
    NSLog(@`evaluateExpression`);
    NSString *filePathNSS = [parser stringValue];
    char *filePath = [filePathNSS cString];
    
    NSString *expressionNSS = [[expressionEntry textStorage] string];
    char *expression = [expressionNSS cString];
    
    NSLog (@`filePath:%s expression:%s`, filePath, expression);
    
    char *result = evalhaskell_CString(filePath, expression);
    NSString *resultNSS = [NSString stringWithCString:result];
    NSAttributedString *resultNSAS = [[NSAttributedString alloc]
	                              initWithString:resultNSS
				          attributes:nil];
    [[evaluation textStorage] setAttributedString:resultNSAS];

}

@end
',12,'2008-07-03 00:16:33','2008-07-03 00:16:33');
INSERT INTO `pastes` VALUES(7,'VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  ''True
  Persistable = 0  ''NotPersistable
  DataBindingBehavior = 0  ''vbNone
  DataSourceBehavior  = 0  ''vbNone
  MTSTransactionMode  = 1  ''NoTransaction
END
Attribute VB_Name = `Session`
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Ext_KEY = `SavedWithClassBuilder6` ,`Yes`
Attribute VB_Ext_KEY = `Top_Level` ,`Yes`
Option Explicit

Private mobjXML As FreeThreadedDOMDocument
Private mobjXMLEle As IXMLDOMElement
Private mobjiXMLDATA As xmlSession.iXMLDATA

Private msBaseXML As String
Private mbStrongType As Boolean
Private mbCase As Boolean
Private mbAutoSave As Boolean
#If FOR_COMPAT = 0 Then

Public Property Let AutoSave(ByVal vData As Boolean)
   ClearError
   mbAutoSave = vData
End Property

Public Property Get AutoSave() As Boolean
   ClearError
   AutoSave = mbAutoSave
End Property

Private Sub CheckInterfaceObject()

   If mobjiXMLDATA Is Nothing Then
      Err.Raise 93, , `Interface Class iXMLDATA has not been initilaized.`
   End If

End Sub

Public Sub Clear(Optional ByVal vName As String)

   Dim lsID As String
   Dim lsTTL As String

   On Error GoTo thiserror
   
   ClearError
   
   If Len(vName) Then
      If Not mbCase Then vName = LCase$(vName)
      Set mobjXMLEle = mobjXML.firstChild.selectSingleNode(vName)
      If Not mobjXMLEle Is Nothing Then mobjXML.removeChild mobjXMLEle
   Else
      With mobjXML.firstChild.Attributes
         lsID = .getNamedItem(`id`).Text
         lsTTL = .getNamedItem(`ttl`).Text
      End With
      mobjXML.loadXML msBaseXML
      Set mobjXMLEle = mobjXML.firstChild
      With mobjXMLEle
         .setAttribute `id`, lsID
         .setAttribute `ttl`, lsTTL
      End With
   End If

   Me.Save

thiserror:
   If Err.Number Then
      mobjXML.firstChild.Attributes.getNamedItem(`error`).Text = _
         `[` & TypeName(Me) & `.Clear] [` & Err.Number & `] ` & Err.Description
   End If
   Set mobjXMLEle = Nothing
   Exit Sub

End Sub
Private Sub ClearError()
   
   On Error GoTo thiserror
   
   mobjXML.firstChild.Attributes.getNamedItem(`error`).Text = ``

thiserror:
   Exit Sub
   
End Sub

Public Function Exists(ByVal vName As String) As Boolean

   On Error GoTo thiserror
   
   ClearError
   
   If Not mbCase Then vName = LCase$(vName)
   
   Select Case vName
      Case `@id`, `@error`, `@ttl`
         Exists = True
      Case Else
         Set mobjXMLEle = mobjXML.firstChild.selectSingleNode(vName)
         Exists = (Not mobjXMLEle Is Nothing)
   End Select
   
thiserror:
   If Err.Number Then
      mobjXML.firstChild.Attributes.getNamedItem(`error`).Text = _
         `[` & TypeName(Me) & `.Exists] [` & Err.Number & `] ` & Err.Description
   End If
   Set mobjXMLEle = Nothing
   Exit Function

End Function
Public Property Get Dirty() As Boolean

   Dim ldST As Double
   Dim ldLT As Double

   On Error GoTo thiserror

   ClearError

   If Not mobjiXMLDATA Is Nothing Then
      With mobjiXMLDATA
         ldLT = .LockTime
         If ldLT Then
            ldST = .SavedLockTime(mobjXML)
            If ldST <> S_FAIL Then Dirty = (ldLT <> ldST)
         End If
      End With
   End If

thiserror:
   If Err.Number Then
      mobjXML.firstChild.Attributes.getNamedItem(`error`).Text = _
         `[` & TypeName(Me) & `.Dirty[GET]] [` & Err.Number & `] ` & Err.Description
   End If
   Exit Property

End Property

Public Property Get StrongType() As Boolean
   ClearError
   StrongType = mbStrongType
End Property
Public Property Let StrongType(ByVal vData As Boolean)
   ClearError
   mbStrongType = vData
End Property
Public Property Get CaseSensative() As Boolean
   ClearError
   CaseSensative = mbCase
End Property
Public Property Get SourcePath() As String

   On Error GoTo thiserror

   ClearError
   SourcePath = mobjiXMLDATA.SourcePath

thiserror:
   If Err.Number Then
      SourcePath = ``
      mobjXML.firstChild.Attributes.getNamedItem(`error`).Text = _
         `[` & TypeName(Me) & `.SourcePath[GET]] [` & Err.Number & `] ` & Err.Description
   End If
   Exit Property

End Property
Public Property Get SourceData() As xmlSession.SessionSourceData

   On Error GoTo thiserror

   ClearError
   SourceData = mobjiXMLDATA.SourceData
   
thiserror:
   If Err.Number Then
      SourceData = 0
      mobjXML.firstChild.Attributes.getNamedItem(`error`).Text = _
         `[` & TypeName(Me) & `.SourceData[GET]] [` & Err.Number & `] ` & Err.Description
   End If
   Exit Property
   
End Property
Public Property Get SourceKey() As String
   
   On Error GoTo thiserror

   ClearError
   SourceKey = mobjXML.firstChild.Attributes.getNamedItem(`id`).Text

thiserror:
   If Err.Number Then
      SourceKey = ``
      mobjXML.firstChild.Attributes.getNamedItem(`error`).Text = _
         `[` & TypeName(Me) & `.SourceKey[GET]] [` & Err.Number & `] ` & Err.Description
   End If
   Exit Property

End Property
Friend Function Create( _
   ByVal SourcePath As String, _
   ByVal SourceKey As String, _
   ByVal SourceData As xmlSession.SessionSourceData, _
   ByVal CaseSensative As Boolean, _
   ByVal AutoSave As Boolean, _
   ByVal ExpireMinutes As Long) As Long
   
   Dim lbInvalidSourceData As Boolean
   Dim lobjXML As FreeThreadedDOMDocument
   
   On Error GoTo thiserror
   
   mbCase = CaseSensative
   mbAutoSave = AutoSave
   
   Select Case True
      Case (SourceData = SessionSourceData.sourceXML)
         If Not FolderExists(SourcePath) Then
            Err.Raise 76, , `SourcePath ''` & SourcePath & `'' is not available.`
         End If
         Set mobjiXMLDATA = New cXML
      Case (SourceData = SessionSourceData.sourceDB)
         Set mobjiXMLDATA = New cData
      Case Else
         lbInvalidSourceData = True
   End Select

   If lbInvalidSourceData Then
      Err.Raise 1, , `Invalid SourceData (` & SourceData & `)`
   Else
      mobjiXMLDATA.ExpireMinutes = Abs(ExpireMinutes)
      Set lobjXML = New FreeThreadedDOMDocument
      With lobjXML
         If Not .loadXML(mobjiXMLDATA.LoadData(SourcePath, SourceKey, msBaseXML)) Then
            Err.Raise .parseError.errorCode, , .parseError.reason
         End If
         mobjXML.loadXML .XML
      End With
   End If

thiserror:
   If Err.Number Then
      Create = Err.Number
      mobjXML.firstChild.Attributes.getNamedItem(`error`).Text = _
         `[` & TypeName(Me) & `.Create] [` & Err.Number & `] ` & Err.Description
   End If
   Set lobjXML = Nothing
   Set mobjXMLEle = Nothing
   Exit Function
   
End Function
Public Function Purge() As Long

   Dim lsSourcePath As String
   Dim leSourceData As xmlSession.SessionSourceData
   Dim llExpMin As Long

   On Error GoTo thiserror

   CheckInterfaceObject
   ClearError
   
   Purge = mobjiXMLDATA.PurgeData(mobjXML.XML)
   If Purge = 0 Then
      Init
      With mobjiXMLDATA
         lsSourcePath = .SourcePath
         leSourceData = .SourceData
         llExpMin = .ExpireMinutes
      End With
      Set mobjiXMLDATA = Nothing
      Purge = Me.Create(lsSourcePath, ``, leSourceData, mbCase, mbAutoSave, llExpMin)
   End If

thiserror:
   If Err.Number Then
      Purge = Err.Number
      mobjXML.firstChild.Attributes.getNamedItem(`error`).Text = _
         `[` & TypeName(Me) & `.Purge] [` & Err.Number & `] ` & Err.Description
   End If
   Exit Function
   
End Function
Public Function Save(Optional ByVal Override As Boolean = False) As Long

   On Error GoTo thiserror

   CheckInterfaceObject
   ClearError
      
   If Me.Dirty Then
      If Override Then
         Save = mobjiXMLDATA.SaveData(mobjXML)
      Else
         Save = S_FAIL
      End If
   Else
      Save = mobjiXMLDATA.SaveData(mobjXML)
   End If
   
thiserror:
   If Err.Number Then
      Save = Err.Number
      mobjXML.firstChild.Attributes.getNamedItem(`error`).Text = _
         `[` & TypeName(Me) & `.Save] [` & Err.Number & `] ` & Err.Description
   End If
   Exit Function

End Function

Public Property Get Value(ByVal vName As String) As Variant

   On Error GoTo thiserror
   
   If Not mbCase Then vName = LCase$(vName)
   If vName <> `@error` Then ClearError
   
   Select Case vName
      Case `@id`
         Value = mobjXML.firstChild.Attributes.getNamedItem(`id`).Text
      Case `@error`
         Value = mobjXML.firstChild.Attributes.getNamedItem(`error`).Text
         ClearError
      Case `@ttl`
         Value = mobjXML.firstChild.Attributes.getNamedItem(`ttl`).Text
      Case `@locktime`
         Value = mobjXML.firstChild.Attributes.getNamedItem(`locktime`).Text
      Case Else
         Set mobjXMLEle = mobjXML.firstChild.selectSingleNode(vName)
         If mobjXMLEle Is Nothing Then
            Value = ``
         Else
            Value = mobjXML.firstChild.selectSingleNode(vName).Text
         End If
   End Select
   
thiserror:
   If Err.Number Then
      mobjXML.firstChild.Attributes.getNamedItem(`error`).Text = _
         `[` & TypeName(Me) & `.Value[GET]] [` & Err.Number & `] ` & Err.Description
   End If
   Set mobjXMLEle = Nothing
   Exit Property
   
End Property
Public Property Let Value(ByVal vName As String, ByVal vData As Variant)
Attribute Value.VB_UserMemId = 0

   Dim llVarType As Long
   Dim lsData As String

   On Error GoTo thiserror
   
   ClearError
   
   If Not mbCase Then vName = LCase$(vName)
   
   Select Case vName
      Case `@id`, `@error`, `@ttl`, `@locktime`
      Case Else
         Set mobjXMLEle = mobjXML.firstChild.selectSingleNode(vName)
         If mobjXMLEle Is Nothing Then
            lsData = VarToStr(vData, llVarType)
            Set mobjXMLEle = mobjXML.createElement(vName)
            mobjXML.firstChild.appendChild mobjXMLEle
         Else
            lsData = VarToStr(vData, llVarType)
            If mbStrongType Then
               If llVarType <> Val(mobjXMLEle.Attributes.getNamedItem(`vt`).Text) Then
                  Err.Raise 13, , `Type Mismatch for value ''` & vName & `''`
               End If
            End If
         End If
         With mobjXMLEle
            .setAttribute `vt`, llVarType
            .Text = lsData
         End With
   End Select
   
thiserror:
   If Err.Number Then
      mobjXML.firstChild.Attributes.getNamedItem(`error`).Text = _
         `[` & TypeName(Me) & `.Value[LET]] [` & Err.Number & `] ` & Err.Description
   End If
   Set mobjXMLEle = Nothing
   Exit Property

End Property
Public Property Get XML() As String

   On Error GoTo thiserror

   ClearError
   XML = mobjXML.XML

thiserror:
   If Err.Number Then
      XML = ``
      mobjXML.firstChild.Attributes.getNamedItem(`error`).Text = _
         `[` & TypeName(Me) & `.XML[GET]] [` & Err.Number & `] ` & Err.Description
   End If
   Exit Property

End Property
Public Function VType(ByVal vName As String) As Long

   On Error GoTo thiserror

   ClearError
   
   If Not mbCase Then vName = LCase$(vName)
   
   Select Case vName
      Case `@id`, `@error`, `@ttl`
      Case Else
         Set mobjXMLEle = mobjXML.firstChild.selectSingleNode(vName)
         If Not mobjXMLEle Is Nothing Then
            VType = CLng(mobjXMLEle.Attributes.getNamedItem(`vt`).Text)
         End If
   End Select
   
thiserror:
   If Err.Number Then
      mobjXML.firstChild.Attributes.getNamedItem(`error`).Text = _
         `[` & TypeName(Me) & `.VType] [` & Err.Number & `] ` & Err.Description
   End If
   Set mobjXMLEle = Nothing
   Exit Function

End Function

#End If
Private Sub Init()

   Set mobjXML = New FreeThreadedDOMDocument
   Set mobjXMLEle = mobjXML.createElement(`xmlsession`)
   With mobjXMLEle
      .setAttribute `id`, ``
      .setAttribute `error`, ``
      .setAttribute `ttl`, ``
      .setAttribute `locktime`, `0`
   End With
   mobjXML.appendChild mobjXMLEle
   Set mobjXMLEle = Nothing
   
   msBaseXML = mobjXML.XML

End Sub

Private Sub Class_Initialize()

   Init

End Sub
Private Sub Class_Terminate()

   #If FOR_COMPAT = 0 Then
      If mbAutoSave Then Call Me.Save(True)
   #End If
   
   Set mobjXML = Nothing
   Set mobjXMLEle = Nothing
   Set mobjiXMLDATA = Nothing

End Sub

',16,'2008-07-03 01:12:58','2008-07-03 01:12:58');
CREATE TABLE `paginas` (`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `title` varchar(255) DEFAULT NULL NULL, `content` text DEFAULT NULL NULL, `created_at` datetime DEFAULT NULL NULL, `updated_at` datetime DEFAULT NULL NULL, `link` varchar(255));
INSERT INTO `paginas` VALUES(2,'Why','asñdofiajsdñofjasdñoifjas
dfjasdfj
asdjf
asdjf
asdjf
ahbnajba
ef
psdjfasdjfasjdf','2008-07-02 13:36:55','2008-07-02 19:45:03','why');
INSERT INTO `paginas` VALUES(3,'Ayuda','ASDfjasñdfjASDFNAPDSVNASDNVaFASNDOFINAVA
famsDFÑANSVNABAAÑGNANSDFINAONFFNASDNFASLIDNFAIN

asd
fasd
fabtaer
fsd
vae ae
gs
gas
dfg','2008-07-02 13:39:14','2008-07-02 19:48:53','help');
CREATE TABLE `languages` (`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `name` varchar(255) DEFAULT NULL NULL, `created_at` datetime DEFAULT NULL NULL, `updated_at` datetime DEFAULT NULL NULL, `mimetype` varchar(255) DEFAULT 'text/plain', `extension` varchar(255), `uv_name` varchar(255));
INSERT INTO `languages` VALUES(1,'PHP','2008-07-02 10:11:20','2008-07-02 23:28:34','text/plain','php','php');
INSERT INTO `languages` VALUES(2,'ActionScript','2008-07-02 10:11:41','2008-07-02 23:26:07','text/plain','as','actionscript');
INSERT INTO `languages` VALUES(3,'C/C++','2008-07-02 10:11:53','2008-07-02 23:27:04','text/plain','c','c');
INSERT INTO `languages` VALUES(4,'Ruby','2008-07-02 10:12:28','2008-07-02 23:29:27','text/plain','rb','ruby');
INSERT INTO `languages` VALUES(5,'Ruby on Rails','2008-07-02 10:12:38','2008-07-02 23:29:45','text/plain','rb','ruby_on_rails');
INSERT INTO `languages` VALUES(6,'SQL','2008-07-02 10:12:46','2008-07-02 23:29:57','text/plain','sql','sql');
INSERT INTO `languages` VALUES(7,'Shell Script (Bash)','2008-07-02 10:12:51','2008-07-02 23:30:24','text/plain','sh','shell-unix-generic');
INSERT INTO `languages` VALUES(8,'Plain Text','2008-07-02 10:13:20','2008-07-02 23:29:06','text/plain','txt','plain');
INSERT INTO `languages` VALUES(9,'Python','2008-07-02 10:13:24','2008-07-02 23:29:18','text/plain','py','python');
INSERT INTO `languages` VALUES(10,'CSS','2008-07-02 10:13:36','2008-07-02 23:27:22','text/plain','css','css');
INSERT INTO `languages` VALUES(11,'HTML (Rails)','2008-07-02 10:13:42','2008-07-02 23:27:46','text/plain','html','xhtml_1.0');
INSERT INTO `languages` VALUES(12,'Objective C/C++','2008-07-02 10:14:16','2008-07-02 23:28:27','text/plain','m','objective-c');
INSERT INTO `languages` VALUES(13,'Diff','2008-07-02 12:34:32','2008-07-02 23:27:36','text/plain','diff','diff');
INSERT INTO `languages` VALUES(14,'JavaScript','2008-07-02 12:35:05','2008-07-02 23:28:06','text/plain','js','javascript');
INSERT INTO `languages` VALUES(15,'HTML / XML','2008-07-02 12:35:20','2008-07-02 23:27:53','text/plain','html','xml');
INSERT INTO `languages` VALUES(16,'Asp','2008-07-03 01:10:34','2008-07-03 01:11:01','text/plain','asp','asp');
CREATE UNIQUE INDEX `unique_schema_migrations` ON `schema_migrations` (`version`);
COMMIT;
