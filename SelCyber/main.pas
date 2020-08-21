unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, ExtCtrls, ShellApi, inifiles, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdFTP, IdFTPCommon, Menus,
  StdCtrls, XPMan, AppData;

type
  TFrm_Main = class(TForm)
    ADOC_BDCon: TADOConnection;
    DS_Payments: TDataSource;
    ADOQ_1: TADOQuery;
    T_Request: TTimer;
    IdFTP1: TIdFTP;
    PM_Tray: TPopupMenu;
    PMN_Enable: TMenuItem;
    PMN_Disable: TMenuItem;
    PMN_Break1: TMenuItem;
    PMN_Options: TMenuItem;
    PMN_Break2: TMenuItem;
    PMN_Exit: TMenuItem;
    M_Log: TMemo;
    XPM: TXPManifest;
    MM_Menu: TMainMenu;
    N_File: TMenuItem;
    N_Enable: TMenuItem;
    N_Disable: TMenuItem;
    N_Break1: TMenuItem;
    N_Exit: TMenuItem;
    N_Options: TMenuItem;
    T_Ctrl: TTimer;
    ADOQ_2: TADOQuery;
    procedure FormActivate(Sender: TObject);
    procedure T_RequestTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PMN_EnableClick(Sender: TObject);
    procedure PMN_DisableClick(Sender: TObject);
    procedure PMN_ExitClick(Sender: TObject);
    procedure PMN_OptionsClick(Sender: TObject);
    procedure T_CtrlTimer(Sender: TObject);
  private
    { Private declarations }
    timeLine : TDateTime;   //Дата и время прочитанное из файла
    timeString : string;    //Дата и время прочитанное из файла
    iconWorked, iconStopped : TIcon;  //Иконки ))
    appStatus : byte; //0 - не работает, 1-работает Статус опроса
    ctrlTimeBeg : TDateTime;

    procedure OnMinimizeProc(Sender:TObject);
    procedure Quest();      //Запрос в базу
    procedure LoadLastTime(); //Загрузка времени из файла
    procedure SaveData();   //Пишем данные в файл
    procedure SaveLastTime(lastTime : TDateTime); //Запись времени в файл
    procedure Ic(n:Integer;Icon:TIcon);
    procedure FTPWork(FileName : String);
    function OpenFTP() : boolean;
    function CheckFiles(fileName : string) : boolean;
    function UploadFile(fileName : string) : boolean;
    procedure SaveLog(text : string);        //Запись в лог файл
    procedure SaveErrorLog(text : string);   //Запись в Лог файл ошибок
  public
    path : string;
    ApplicationData : TAppData;
    { Public declarations }
  protected
    procedure ControlWindow(Var Msg:TMessage); message WM_SYSCOMMAND;
    Procedure IconMouse(var Msg:TMessage); message WM_USER+1;
  end;

var
  Frm_Main: TFrm_Main;

implementation

uses Options;

{$R *.dfm}

//******************************************************************************
//Процедура записи лога
//
procedure TFrm_Main.SaveLog(text : string);
var logFile : TextFile;
begin
  AssignFile(logFile, path + 'working.log');
  try
    Append(logFile);
  except
    ReWrite(logFile);
  end;
WriteLn(logFile, DateToStr(Date) + ' ' + TimeToStr(Time) + ' ' + text);
CloseFile(logFile)
end;

//******************************************************************************
//Процедура записи лога ошибок
//
procedure TFrm_Main.SaveErrorLog(text : string);
var errorFile : TextFile;
begin
  AssignFile(errorFile, path + 'error.log');
  try
    Append(errorFile);
  except
    ReWrite(errorFile);
  end;
  WriteLn(errorFile, DateToStr(Date) + ' ' + TimeToStr(Time) + ' ' + text);
  CloseFile(errorFile);
end;

//******************************************************************************
//Процедура работы с иконкой в трее
//
Procedure TFrm_Main.Ic(n:Integer;Icon:TIcon);
Var Nim:TNotifyIconData;
begin
 With Nim do
  Begin
   cbSize := SizeOf(Nim);
   Wnd := Frm_Main.Handle;
   uID:=1;
   uFlags:=NIF_ICON or NIF_MESSAGE or NIF_TIP;
   hicon:=Icon.Handle;
   uCallbackMessage:=wm_user+1;
   szTip:='Работаем =)';
  End;
 Case n OF
  1: Shell_NotifyIcon(Nim_Add,@Nim);
  2: Shell_NotifyIcon(Nim_Delete,@Nim);
  3: Shell_NotifyIcon(Nim_Modify,@Nim);
 End;
end;

//******************************************************************************
//Активация формы. Производим соединение с бд
//
procedure TFrm_Main.FormActivate(Sender: TObject);
begin
  path := extractfilepath(Application.ExeName);
  //Производим загрузку данных из ини файла
  ApplicationData := TAppData.Create;
  if not ApplicationData.LoadFromIni(path) then
    begin
      //Ошибка загрузки данных приложения
      Application.MessageBox('Ошибка загрузки параметров приложения', 'Ошибка', MB_OK + MB_ICONERROR);
      SaveErrorLog('Ошибка загрузки параметров приложения');
      Application.Terminate;
    end;
  //Соединяемся с БД
  ADOC_BDCon.Close;
  ADOC_BDCon.ConnectionString := 'Provider=SQLOLEDB.1;' + 'Password=' +
                                  ApplicationData.passwordServ + ';' +
                                 'Persist Security Info=True;User ID=' +
                                  ApplicationData.loginServ + ';' +
                                 'Initial Catalog=Terminals;' +
                                 'Data Source=' + ApplicationData.addressServ + ';' +
                                 'Use Procedure for Prepare=1;' +
                                 'Auto Translate=True;Packet Size=4096;' +
                                 'Workstation ID=MICROSOF-CF3CC5;' +
                                 'Use Encryption for Data=False;' +
                                 'Tag with column collation when possible=False';
  //пытаемся соединится с БД
  try
    ADOC_BDCon.Open;
  except
    //В случае ошибки пишем в лог
    Application.MessageBox('Ошибка соединения с БД', 'Ошибка', MB_OK + MB_ICONERROR);
    SaveErrorLog('Ошибка соединения с базой данных');
    Application.Terminate;
  end;
  ADOC_BDCon.DataSets[0].Active := true;
  //Пишем в ЛОГ, что соединение с БД успешно
  SaveLog('Успешное соединение с БД');
  //Заменяем стандартный обработчик минимизации на свой
  Application.onMinimize:=OnMinimizeProc;

  LongTimeFormat := 'hh:mm:ss:zzz';
  //Грузим иконки
  iconWorked := TIcon.Create;
  iconWorked.LoadFromFile('working.ico');
  iconStopped := TIcon.Create;
  iconStopped.LoadFromFile('stopped.ico');
  //Запускаем таймер ежечасной проверки
  //И получаем текущее время для последующего составления запрос
  ctrlTimeBeg := now();
  T_Ctrl.Enabled := true;
  //Загружаем последнее опрошенное время
  LoadLastTime();
  //Делаем запрос к базе
  Quest();
  //Сохраняем полученные данные
  SaveData();
  //Программа постоянно опрашивает
  appStatus := 1;
  //Устанавливаем время и включаем таймер
  T_Request.Interval := ApplicationData.periodTime*60*1000;
  T_Request.Enabled := true;
end;

//******************************************************************************
//Загрузка времени последнего опроса из файла
//
procedure TFrm_Main.LoadLastTime();
var time : TextFile;
    tmpTimeLine : string;
begin

//Открываем файл
try
  AssignFile(time, path + 'time.txt');
  Reset(time);
except
  //При ошибке чтения выходим из процедуры
  timeLine := 0;
  exit;
end;

//читаем из файла дату и время последнего опроса
try
  ReadLn(time, tmpTimeLine);
except
  CloseFile(time);
  timeLine := 0;
  exit;
end;

//проверяем строчку на совместимость!!!!
try
 timeLine := StrToDateTime(tmpTimeLine);
 timeString := tmpTimeLine;
except
 timeLine := 0;
end;
CloseFile(time);
end;

//******************************************************************************
//      Запись последнего времени опроса
//
procedure TFrm_Main.SaveLastTime(lastTime : TDateTime);
var saveFile : TextFile;
    tmpStr : string;
begin
  //преобразовываем время в формат строки
  DateTimetoString(tmpStr, 'dd.mm.yyyy hh:mm:ss:zzz', lastTime);
  //Открываем файлик
  AssignFile(saveFile, path+'time.txt');
  try
    Erase(saveFile);
  except
  end;
  ReWrite(saveFile);
  Write(saveFile, tmpStr);
  CloseFile(saveFile);
end;

//******************************************************************************/
//Выполняем запрос к базе
//
procedure TFrm_Main.Quest();
var sqlText : string;
    tmpStr : string;
begin
  //Если время не правильное то выдаем ошибку и выодим из функции
  if timeLine = 0 then
  begin
    Application.MessageBox('Ошибка определения времени!!', 'Критическая ошибка', MB_OK + MB_ICONERROR);
    appStatus := 0;
  end;

 DateTimeToString(tmpStr, 'dd.mm.yyyy hh:mm:ss:zzz', timeLine);

  sqlText := '';
  //Определение времени до которого опрашивать и - время
  //nowTimeMin := now();
  //nowTimeMin := nowTimeMin - 0.0007;
  if timeLine <> 0 then
  begin
    sqlText := 'SELECT p.InitialSessionNumber, P.TerminalId, p.InitializeDateTime, ';
    sqlText := sqlText + ' p.Params, p.AmountAll, p.OperatorId, p.ServerDateTime ';
    sqlText := sqlText + 'FROM NewPayments p ';
    sqlText := sqlText + 'WHERE  p.OperatorID = 500 ';
    sqlText := sqlText + ' AND p.ServerDateTime > ''' + timeString + ''' ';
    sqlText := sqlText + ' AND p.StatusID = 0 ';
    sqlText := sqlText + 'ORDER BY p.ServerDateTime';
  end;
  ADOQ_1.Close;
  ADOQ_1.SQL.Clear();
  ADOQ_1.SQL.Add(sqlText);
  try
    ADOQ_1.Open;
    ADOQ_1.ExecSQL();
  except
    //Ошибка при запросе к БД
    //Пишем в ЛОГ
    SaveErrorLog('Ошибка запроса к БД');
  end;

  //Выполнение запроса для CVS
  if ApplicationData.selectCVS = TRUE then
  begin
    if (ApplicationData.operatorIDs <> '') AND
      (ApplicationData.SelectesFields <> '') then
    begin
        sqlText := '';

        sqlText := 'SELECT ' + ApplicationData.SelectesFields + #13;
        sqlText := sqlText + 'FROM NewPayments ';
        sqlText := sqlText + 'WHERE OperatorID in (' + ApplicationData.operatorIDs + ')';
        sqlText := sqlText + ' AND ServerDateTime > ''' + timeString + ''' ';
        sqlText := sqlText + ' AND StatusID = 0 ';
        sqlText := sqlText + 'ORDER BY ServerDateTime';

        ADOQ_2.Close;
        ADOQ_2.SQL.Clear;
        ADOQ_2.SQL.Add(sqlText);
        try
          ADOQ_2.Open;
          ADOQ_2.ExecSQL();
        except
          SaveErrorLog('Ошибка запроса к БД. Второй запрос.');
        end;
    end;
  end;
end;

//******************************************************************************
//                Создаем файлик данными
//
procedure TFrm_Main.SaveData();
  //парсинг строки со счетом
  function ParseSchet(tmpString : String) : string;
  var pos1, pos2 : byte;
    begin
      pos1 := Pos('field', tmpString);
      pos2 := Pos('&', tmpString);
      if pos1 < pos2 then
        result := copy(tmpString, 10, pos2 - 8)
      else
        result := copy(tmpString, pos1 + 9, length(tmpString) -
          pos1 + 9);
    end;
var saveFile  : TextFile;
    tmpString : string;
    dateNow   : string;
    timeNow   : string;
    fileName  : string;
    initMax   : TDateTime;
    index     : integer;
begin
if ADOQ_1.IsEmpty then
begin
 M_Log.Lines.Add('Прошлое последнее время опроса : ' + timeString);
 M_Log.Lines.Add('Выбрано 0 записей');
 SaveLog('Выбрано 0 записей');
 //Вызываем Функцию работы с фтп, но передаем в качестве
 //имени файла null
 FTPWork('null');
 //
 M_Log.Lines.Add('Текущее последнее время опроса : ' + timeString);
 SaveLog('Текущее последнее время опроса : ' + timeString);
 //и выходим из функции для того что бы не формировать пустые
 //строки и пустой файл
 exit;
end;

//Парсим данные для CVS
if not ADOQ_2.IsEmpty then
begin
  fileName := 'csv_data.csv';
  AssignFile(saveFile, 'csv\' + fileName);
  try
    Append(saveFile);
  except
    ReWrite(saveFile);
  end;

  ADOQ_2.First;
  while not ADOQ_2.Eof do
  begin
    tmpString := '';
    for index := 0 to ADOQ_2.FieldCount - 1 do
      begin
        if ADOQ_2.Fields[index].FieldName <> 'Params' then
          tmpString := tmpString + ADOQ_2.Fields[index].AsString + ';'
        else
          tmpString := tmpString + ParseSchet(ADOQ_2.Fields[index].AsString) + ';';
      end;
    delete(tmpString, Length(tmpString), 1);
    WriteLn(saveFile, tmpString);
    ADOQ_2.Next;
  end;
  closeFile(saveFile);
end;

//Если лог больше 10000 строчек. очищаем
if M_Log.Lines.Count > 10000 then M_Log.Lines.Clear;

//преобразовываем время в текстовую строку для создания имени файла
dateNow := DateToStr(Date);
timeNow := TimeToStr(Time);
//Преобразовываем строки для допустимого формата в имени файла
while Pos('.', dateNow) <> 0 do Delete(dateNow, Pos('.', dateNow), 1);
while Pos(':', timeNow) <> 0 do Delete(timeNow, Pos(':', timeNow), 1);

fileName := 'data_' + dateNow + '_' + timeNow + '.txt';
//Открываем файлик
  ReWrite(saveFile, path + fileName);

tmpString := '';
//Устанавливаем минимальное время
initMax := timeLine;
ADOQ_1.First;
while not ADOQ_1.Eof do
begin
//Формируем строку для записи
  tmpString := string(ADOQ_1.FieldByName('InitialSessionNumber').Value) + chr(9);
  tmpString := tmpString + string(ADOQ_1.FieldByName('TerminalId').Value);
  while length(tmpString) < 45 do tmpString := tmpString + ' ';
  tmpString := tmpString + ParseSchet(ADOQ_1.FieldByName('Params').Value) + chr(9);
  tmpString := tmpString + string(ADOQ_1.FieldByName('AmountAll').Value) + chr(9);
  tmpString := tmpString + string(ADOQ_1.FieldByName('InitializeDateTime').Value);
  //Проверяем, если время в строчке больше текущего максимального то устанавливаем его
  if ADOQ_1.FieldByName('ServerDateTime').Value > initMax then
    initMax := ADOQ_1.FieldByName('ServerDateTime').Value;
  Writeln(saveFile, tmpString);
  //WriteLn(ControlFile, string(ADOQ_1.FieldByName('InitialSessionNumber').Value));
  ADOQ_1.Next;
end;

CloseFile(saveFile);

//Сохраняем время опроса
SaveLastTime(initMax);
//Преобразуем время в текстовой формат
DateTimetoString(tmpString, 'dd.mm.yyyy hh:mm:ss:zzz', initMax);
//Сохраняем данные об опросе в экранном логе
M_Log.Lines.Add('Прошлое последнее время опроса : ' + timeString);
M_Log.Lines.Add('Выбрано записей - ' + IntToStr(ADOQ_1.RecordCount));
M_Log.Lines.Add('Текущее последнее время опроса : ' + tmpString);
SaveLog('Прошлое последнее время опроса : ' + timeString);
SaveLog('Выбрано записей - ' + IntToStr(ADOQ_1.RecordCount));
SaveLog('Текущее последнее время опроса : ' + tmpString);
//Вызываем процедуру работы с ФТП
FTPWork(fileName);
end;

//******************************************************************************
//    Процедура основной работы с ФТП
//
procedure TFrm_Main.FTPWork(FileName : String);
var fileList : TStringList;
    indexDelete : TStringList;
    fileFile : TextFile;
    loadList : boolean;
    i        : integer;
begin
//Инициализируем список имен
fileList:= TStringList.Create;
//Инициализируем список идексов для удаления
indexDelete := TStringList.Create;
//Загружаем список файлов
try
  AssignFile(fileFile, path + 'FileList.txt');
  Reset(fileFile);
  loadList := true;
except
  //При ошибке открытия файла - создаем его
  ReWrite(fileFile);
  loadList := false;
end;
closeFile(fileFile);
if loadList = true then
begin
  try
    //Собственно загрузка
    fileList.LoadFromFile(path+'FileList.txt');
  except
    //ошибка чтения из файла
    fileList.Clear;
  end;
end;

if fileName <> 'null' then fileList.Add(fileName);
if fileList.Count > 0 then
begin
  M_Log.Lines.Add('Отправка на ФТП файлов : ');
  for i := 0 to fileList.Count - 1 do M_Log.Lines.Add(fileList[i]);
end;

//открываем соеденение с ftp сервером
if OpenFTP() = true then
begin
  //Цикл по списку файлов
  for i:= 0 to fileList.Count - 1 do
  begin
    //Передача файла на фтп
    if FileExists(path + fileList[i]) then
    begin
    UploadFile(fileList[i]);
    //Проверка на наличие файла
    if CheckFiles(fileList[i]) then
    begin
      //если найден то удаляем локальный
      if FileExists(path + fileList[i]) then
      begin
        RenameFile(path + fileList[i], path + '/sended/' + '_' + fileList[i]);
        M_Log.Lines.Add('Файл : ' + fileList[i] + ' отправлен успешно!');
        SaveLog('Файл : ' + fileList[i] + ' отправлен успешно!');
        //Записываем индекс для удаления записи из Листа
        indexDelete.Add(IntToStr(i));
      end;
    end;
    end;
  end;
end;
//Закрываем соединение фтп
IdFTP1.Quit;
//Удаляем записи из листа
  for i := indexDelete.Count - 1 downto 0 do
    fileList.Delete(StrToInt(indexDelete[i]));
//Сохраняем обновлённый список файлов
//Сначала удаляем файл списка
  DeleteFile(Path + 'FileList.txt');
  fileList.SaveToFile(Path + 'FileList.txt');
 //Освобождаем ресурсы
 fileList.Free;
 indexDelete.Free;
end;

//******************************************************************************
//      Открываем FTP соединение
//
function TFrm_Main.OpenFTP() : boolean;
begin
  if IdFTP1.Connected
    then
      try
        IdFTP1.Quit;
      finally
        
      end
  else
    with IdFTP1 do
      try
       Username := ApplicationData.loginFTP;
       Password := ApplicationData.passwordFTP;
       Host := ApplicationData.addressFTP; 
       Connect;
       IdFTP1.ChangeDir(ApplicationData.pathFTP);
       except
       //Ошибка соединения с FTP, пишем в лог
       SaveErrorLog('Ошибка соединения с FTP сервером');
      end;
  result := IdFTP1.Connected;
end;

//******************************************************************************
//  Проверка наличия файлов на ФТП, проверяются также неотправленные ранее
//
function TFrm_Main.CheckFiles(fileName : string) : boolean;
var LS : TStringList;
    i  : integer;
    FTPFileName : String;
begin
  if IdFTP1.Connected = false then //Если подключены к фтп
    begin
      result := false;
      exit;
    end;
  LS := TStringList.Create;
  try
    IdFTP1.TransferType := ftASCII;
    IdFTP1.List(LS);
    //Просматриваем фтп на предмет наличия файла
    if LS.Count <> 0 then
    begin
      for i := 0 to LS.Count - 1 do
      begin
        FTPFileName := copy(LS[i], pos('data', LS[i]), length(LS[i])-pos('data', LS[i])+1);
        if FTPFileName = fileName then
        begin
          result := true;
          exit;
        end;
      end;
    end;
  finally
    LS.Free;
  end;
  result := false;
end;

//******************************************************************************
//                  Заливка файла на ФТП
//
function TFrm_Main.UploadFile(fileName : string) : boolean;
begin
 if IdFTP1.Connected then
  begin
    try
      IdFTP1.TransferType := ftBinary;
      IdFTP1.Put(fileName, fileName);
      result := true;
      exit;
    except
      //Ошибка заливки файла
      SaveErrorLog('Ошибка записи файла на фтп');
      result := false;
    end;
  end
 else result := false;
end;

//******************************************************************************
//          Сработал таймер, производим опрос ))
//
procedure TFrm_Main.T_RequestTimer(Sender: TObject);
begin
  //Запишем в лог начало опроса
  SaveLog('Начало очередного опроса ----------------------------');
  LoadLastTime();
  Quest();
  SaveData();
  SaveLog('Звершение опроса ------------------------------------');
end;

//******************************************************************************
//           Перехватываем сообщение о минимизации и "прячем окно"
//
procedure TFrm_Main.ControlWindow(Var Msg:TMessage);
begin
IF Msg.WParam=SC_MINIMIZE then //Если минимизация
  Begin
    if T_Request.Enabled = true then Ic(1, iconWorked)
      else ic(1, iconStopped);
    ShowWindow(Handle,SW_HIDE);  // Скрываем программу
    ShowWindow(Application.Handle,SW_HIDE);  // Скрываем кнопку с TaskBar'а
  end else inherited;
end;

//******************************************************************************
//      перехватываем Minimize из системного меню
//
Procedure TFrm_Main.OnMinimizeProc(Sender:TObject);
Begin
 PostMessage(Handle,WM_SYSCOMMAND,SC_MINIMIZE,0);
End;

//******************************************************************************
// Обработка мышки в трее
//
procedure TFrm_Main.IconMouse(var Msg:TMessage);
Var p:tpoint;
begin
 GetCursorPos(p); // Запоминаем координаты курсора мыши
 Case Msg.LParam OF  // Проверяем какая кнопка была нажата
  WM_LBUTTONUP, WM_LBUTTONDBLCLK: {Действия, выполняемый по одинарному или двойному щелчку левой кнопки мыши на значке. В нашем случае это просто активация приложения}
     Begin
         Ic(2,Application.Icon);  // Удаляем значок из трея
         ShowWindow(Application.Handle,SW_SHOW); // Восстанавливаем кнопку программы
         ShowWindow(Handle,SW_SHOW); // Восстанавливаем окно программы
     End;
  WM_RBUTTONUP:
    begin
      SetForegroundWindow(Handle);  // Восстанавливаем программу в качестве переднего окна
      PM_Tray.Popup(p.X,p.Y);  // Заставляем всплыть тот самый TPopUp
      PostMessage(Handle,WM_NULL,0,0);
    end;
 end;
end;

//******************************************************************************
//      Режим опроса - включен
//
procedure TFrm_Main.PMN_EnableClick(Sender: TObject);
begin
  //Сначала меняем пункты меню
  PMN_Disable.Enabled := true; //Пункт меню - включить, включен
  PMN_Enable.Enabled := false; //Пункт меню - выключить, выключен =)
  N_Disable.Enabled := true;
  N_Enable.Enabled := false;
  //Меняем статус приложения
  appStatus := 1;
  //Меняем иконку в трее
  Ic(3, iconWorked);
end;

//******************************************************************************
//      Режим опроса - выключен
//
procedure TFrm_Main.PMN_DisableClick(Sender: TObject);
begin
  //Изначально меняем пункты меню
  PMN_Disable.Enabled := false; //Пункт меню - включить, включен
  PMN_Enable.Enabled := true; //Пункт меню - выключить, выключен =)
  N_Disable.Enabled := false;
  N_Enable.Enabled := true;
  //Меняем статус приложения
  appStatus := 0;
  //Меняем иконку в трее
  Ic(3, iconStopped);
end;

//******************************************************************************
//  Срабатывание таймера ежечасной проверки
//  проводим сравнение количества отправленныйх записей с тестовой выборкой
//
procedure TFrm_Main.T_CtrlTimer(Sender: TObject);
begin
//
end;

//******************************************************************************
//        Вызываем окно опций
//
procedure TFrm_Main.PMN_OptionsClick(Sender: TObject);
begin
 Frm_Options.ShowModal;
end;

//******************************************************************************
//      Закрытие основной формы, приложения
procedure TFrm_Main.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  IdFTP1.Quit;
  T_Request.Enabled := false;
  ADOQ_1.Close;
  ADOQ_2.Close;
  ADOQ_1.Free;
  ADOQ_2.Free;
  ADOC_BDCon.Free;
end;

//******************************************************************************
//        Выход из приложения
//
procedure TFrm_Main.PMN_ExitClick(Sender: TObject);
begin
//пока опустим
 Frm_Main.Close;
end;

end.
