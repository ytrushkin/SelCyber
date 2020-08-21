unit Options;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, inifiles, AppData;

type
  TFrm_Options = class(TForm)
    PC_OptionsGroup: TPageControl;
    B_Use: TButton;
    B_Cancel: TButton;
    B_Ok: TButton;
    GB_BDConn: TGroupBox;
    GB_FTPConn: TGroupBox;
    L_Adress: TLabel;
    L_LoginBD: TLabel;
    L_PasswordBD: TLabel;
    E_AdressIp: TEdit;
    E_LoginBd: TEdit;
    E_PasswordBD: TEdit;
    L_AdressFTP: TLabel;
    L_LoginFTP: TLabel;
    E_AdressFTP: TEdit;
    L_PasswordFTP: TLabel;
    L_Path: TLabel;
    E_LoginFTP: TEdit;
    E_PasswordFTP: TEdit;
    E_PathFTP: TEdit;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    E_PeriodTime: TEdit;
    TabSheet3: TTabSheet;
    CB_SelectCVS: TCheckBox;
    GB_IDOperators: TGroupBox;
    GB_Fields: TGroupBox;
    CB_TerminalID: TCheckBox;
    CB_AmountAll: TCheckBox;
    CB_InitDateTime: TCheckBox;
    CB_PaymentDateTime: TCheckBox;
    LB_OperatorIDList: TListBox;
    B_Add: TButton;
    B_Edit: TButton;
    B_Delete: TButton;
    CB_All: TCheckBox;
    CB_InitialSession: TCheckBox;
    CB_Params: TCheckBox;
    procedure FormActivate(Sender: TObject);
    procedure B_OkClick(Sender: TObject);
    procedure E_AdressIpKeyPress(Sender: TObject; var Key: Char);
    procedure E_LoginBdKeyPress(Sender: TObject; var Key: Char);
    procedure E_PasswordBDKeyPress(Sender: TObject; var Key: Char);
    procedure E_AdressFTPKeyPress(Sender: TObject; var Key: Char);
    procedure E_LoginFTPKeyPress(Sender: TObject; var Key: Char);
    procedure E_PasswordFTPKeyPress(Sender: TObject; var Key: Char);
    procedure E_PathFTPKeyPress(Sender: TObject; var Key: Char);
    procedure E_PeriodTimeKeyPress(Sender: TObject; var Key: Char);
    procedure B_UseClick(Sender: TObject);
    procedure B_AddClick(Sender: TObject);
    procedure B_EditClick(Sender: TObject);
    procedure B_DeleteClick(Sender: TObject);
    procedure CB_SelectCVSClick(Sender: TObject);
    procedure CB_AllClick(Sender: TObject);    
    procedure CB_Click(Sender: TObject);
  private
    bActive : boolean;
    { Private declarations }
    procedure SaveOptions();
  public
    { Public declarations }
  end;

var
  Frm_Options: TFrm_Options;

implementation

uses main;

{$R *.dfm}

//При активации формы, закружаем параметры из ini 
procedure TFrm_Options.FormActivate(Sender: TObject);
var tmpStr1 : string;
    tmpStr2 : string;
begin
 //Изначально клавиша "применить" заблокирована
 B_Use.Enabled := false;

 LB_OperatorIDList.Items.Clear;

 //Заполняем значениями поля
 E_AdressFTP.Text := Frm_Main.ApplicationData.addressFTP;
 E_LoginFTP.Text := Frm_Main.ApplicationData.loginFTP;
 E_PasswordFTP.Text := Frm_Main.ApplicationData.passwordFTP;
 E_PathFTP.Text := Frm_Main.ApplicationData.pathFTP;
 E_AdressIp.Text := Frm_Main.ApplicationData.addressServ;
 E_LoginBD.Text := Frm_Main.ApplicationData.loginServ;
 E_PasswordBD.Text := Frm_Main.ApplicationData.passwordServ;
 E_PeriodTime.Text := IntToStr(Frm_Main.ApplicationData.periodTime);

 CB_SelectCVS.Checked := Frm_Main.ApplicationData.selectCVS;
 CB_AmountAll.Checked := Frm_Main.ApplicationData.amountAllField;
 CB_InitDateTime.Checked := Frm_main.ApplicationData.initDateTimeField;
 CB_PaymentDateTime.Checked := Frm_Main.ApplicationData.paymentDateTimeField;
 CB_TerminalID.Checked := Frm_main.ApplicationData.terminalIDField;

 tmpStr1 := Frm_Main.ApplicationData.operatorIDs;
 if Length(tmpStr1)> 0 then
  begin
   while length(tmpStr1) <> 0 do
    begin
      if Pos(',',tmpStr1) <> 0 then
        tmpStr2 := trim(copy(tmpStr1, 1, Pos(',', tmpStr1)-1))
      else
        tmpStr2 := tmpStr1;
      LB_OperatorIDList.Items.Add(tmpStr2);
      if Pos(',',tmpStr1) <> 0 then
        delete(tmpStr1, 1, Pos(',', tmpStr1))
      else
        tmpStr1 := '';
    end;
  end;

 bActive := TRUE;
 CB_All.Checked := Frm_main.ApplicationData.AllFieldsChecked;
 bActive := FALSE;
end;

//Сохраняем измененные значения
procedure TFrm_Options.B_OkClick(Sender: TObject);
begin
  SaveOptions();
  //Завершаем работы окна настроек
  Frm_Options.Close;
end;

//Применить изменения
procedure TFrm_Options.B_UseClick(Sender: TObject);
begin
  SaveOptions();
  //Отключаем активность кнопки применить
  B_Use.Enabled := false;
end;

procedure TFrm_Options.SaveOptions();
var i : integer;
    tmpStr : string;
begin
  //Сохраняем изменения
  Frm_Main.ApplicationData.addressFTP := E_AdressFTP.Text;
  Frm_Main.ApplicationData.loginFTP := E_LoginFTP.Text;
  Frm_Main.ApplicationData.passwordFTP := E_PasswordFTP.Text;
  Frm_Main.ApplicationData.pathFTP := E_PathFTP.Text;
  Frm_Main.ApplicationData.addressServ := E_AdressIp.Text;
  Frm_Main.ApplicationData.loginServ := E_LoginBD.Text;
  Frm_Main.ApplicationData.passwordServ := E_PasswordBD.Text;
  Frm_Main.ApplicationData.periodTime := StrToInt(E_PeriodTime.Text);

  Frm_Main.ApplicationData.selectCVS := CB_SelectCVS.Checked;
  Frm_Main.ApplicationData.amountAllField := CB_AmountAll.Checked;
  Frm_Main.ApplicationData.initDateTimeField := CB_InitDateTime.Checked;
  Frm_Main.ApplicationData.paymentDateTimeField := CB_PaymentDateTime.Checked;
  Frm_Main.ApplicationData.terminalIDField := CB_TerminalID.Checked;

  tmpStr := '';
  for i := 0 to LB_OperatorIDList.Items.Count-1 do
       tmpStr := tmpStr + LB_OperatorIDList.Items.Strings[i] + ',';
  //Убираем последнию запятую
  delete(tmpStr, Length(tmpStr), 1);

  Frm_Main.ApplicationData.operatorIDs := tmpStr;


  Frm_Main.ApplicationData.SaveToIni(Frm_Main.path);
end;

//Поле ввода адреса сервера БД
procedure TFrm_Options.E_AdressIpKeyPress(Sender: TObject; var Key: Char);
begin
  //Нажатие клавиши/ разблокируем клавишу применить
  B_Use.Enabled := true;
end;

//Поле ввода логина доступа к БД
procedure TFrm_Options.E_LoginBdKeyPress(Sender: TObject; var Key: Char);
begin
  //Нажатие клавиши/ разблокируем клавишу применить
  B_Use.Enabled := true;
end;

//Поле ввода пароля доступа к БД
procedure TFrm_Options.E_PasswordBDKeyPress(Sender: TObject; var Key: Char);
begin
  //Нажатие клавиши/ разблокируем клавишу применить
  B_Use.Enabled := true;
end;

//Поле ввода адреса ФТП сервера для заливки данных
procedure TFrm_Options.E_AdressFTPKeyPress(Sender: TObject; var Key: Char);
begin
  //Нажатие клавиши/ разблокируем клавишу применить
  B_Use.Enabled := true;
end;

//Поле ввода логина для доступа к FTP серверу
procedure TFrm_Options.E_LoginFTPKeyPress(Sender: TObject; var Key: Char);
begin
  //Нажатие клавиши/ разблокируем клавишу применить
  B_Use.Enabled := true;
end;

//Поле ввода пароля для доступа к FTP серверу
procedure TFrm_Options.E_PasswordFTPKeyPress(Sender: TObject; var Key: Char);
begin
  //Нажатие клавиши/ разблокируем клваишу применить
  B_Use.Enabled := true;
end;

//Поле ввода пути к файлам на FTP сервере
procedure TFrm_Options.E_PathFTPKeyPress(Sender: TObject; var Key: Char);
begin
  //Нажатие клавиши/ разблокируем клавишу применить
  B_Use.Enabled := true;
end;

//Время частоты опроса сервера БД
procedure TFrm_Options.E_PeriodTimeKeyPress(Sender: TObject; var Key: Char);
begin
  //Нажатие клавиши/ разблокируем клавишу применить
  B_Use.Enabled := true;
end;

//Производить ли дополнительную выборку?
procedure TFrm_Options.CB_SelectCVSClick(Sender: TObject);
begin
  //Нажатие клавиши/ разблокируем клавишу применить
  B_Use.Enabled := true;
  if CB_SelectCVS.Checked then
    begin
      GB_IDOperators.Enabled      := TRUE;
      B_Add.Enabled               := TRUE;
      B_Delete.Enabled            := TRUE;
      B_Edit.Enabled              := TRUE;
      LB_OperatorIDList.Enabled   := TRUE;

      GB_Fields.Enabled           := TRUE;
      CB_All.Enabled              := TRUE;
      CB_InitialSession.Enabled   := TRUE;
      CB_TerminalID.Enabled       := TRUE;
      CB_Params.Enabled           := TRUE;
      CB_AmountAll.Enabled        := TRUE;
      CB_InitDateTime.Enabled     := TRUE;
      CB_PaymentDateTime.Enabled  := TRUE;
    end
  else
    begin
      GB_IDOperators.Enabled      := FALSE;
      B_Add.Enabled               := FALSE;
      B_Delete.Enabled            := FALSE;
      B_Edit.Enabled              := FALSE;
      LB_OperatorIDList.Enabled   := FALSE;

      GB_Fields.Enabled           := FALSE;
      CB_All.Enabled              := FALSE;
      CB_InitialSession.Enabled   := FALSE;
      CB_TerminalID.Enabled       := FALSE;
      CB_Params.Enabled           := FALSE;
      CB_AmountAll.Enabled        := FALSE;
      CB_InitDateTime.Enabled     := FALSE;
      CB_PaymentDateTime.Enabled  := FALSE;
    end;
end;

//Выбор/отмена выбора всех полей
procedure TFrm_Options.CB_AllClick(Sender: TObject);
begin
  //Нажатие клавиши/ разблокируем клавишу применить
  if bActive then exit;
  B_Use.Enabled := true;
  if (not CB_AmountAll.Checked) or (not CB_InitDateTime.Checked) or
      (not CB_InitialSession.Checked) or (not CB_Params.Checked) or
      (not CB_PaymentDateTime.Checked) or (not CB_TerminalID.Checked) then
    begin
      CB_InitialSession.Checked   := TRUE;
      CB_TerminalID.Checked       := TRUE;
      Cb_Params.Checked           := TRUE;
      CB_AmountAll.Checked        := TRUE;
      CB_InitDateTime.Checked     := TRUE;
      CB_PaymentDatetime.Checked  := TRUE;
    end
  else
    begin
      CB_InitialSession.Checked   := FALSE;
      CB_TerminalID.Checked       := FALSE;
      CB_Params.Checked           := FALSE;
      CB_AmountAll.Checked        := FALSE;
      CB_InitDateTime.Checked     := FALSE;
      CB_PaymentDatetime.Checked  := FALSE;
    end;
end;

procedure TFrm_Options.CB_Click(Sender: TObject);
begin
  B_Use.Enabled := TRUE;
end;

//Добавление OperatorID
procedure TFrm_Options.B_AddClick(Sender: TObject);
var tmpString   : string;
    tmpInteger  : integer;
    i           : integer;
begin
  tmpString := trim(InputBox('Добавление OperatorID', 'OperatorID', ''));
  if tmpString = '' then exit;
  //Проверка на нормальность )))
  try
    tmpInteger := StrToInt(tmpString);

    //Проверка на повтор
    if LB_OperatorIDList.Items.Count > 0 then
    begin
     for i := 0 to LB_OperatorIDList.Items.Count-1 do
      begin
        if LB_OperatorIDList.Items.Strings[i] = tmpString then
          begin
            Application.MessageBox('Такой OperatorID уже присутствует', 'Ошибка', MB_OK + MB_ICONERROR);
            exit;
          end;
      end;
     end;

    //Заносим в список
    LB_OperatorIDList.Items.Add(IntToStr(tmpInteger));
  except
    Application.MessageBox('Неправильный OperatorID', 'Ошибка', MB_OK + MB_ICONERROR);
  end;
end;

//Редактировать OperatorID
procedure TFrm_Options.B_EditClick(Sender: TObject);
var OldValue : string;
    NewValue : string;
    tmpInteger : integer;
    index : integer;
    i : integer;
begin
  index := LB_OperatorIDList.ItemIndex;
  if index < 0 then
    begin
      Application.MessageBox('Не выбран OperatorID для редактирования', 'Ошибка', MB_OK + MB_ICONERROR);
      exit;
    end; 

  OldValue := LB_OperatorIDList.Items.Strings[index];

  newValue := trim(InputBox('Редактирование OperatorID', 'OperatorID', OldValue));
  
  if NewValue = OldValue then exit;
 
  //Проверка на нормальность )))
  try
    tmpInteger := StrToInt(NewValue);

    //Проверка на повтор
      for i := 0 to LB_OperatorIDList.Items.Count-1 do
      begin
        if LB_OperatorIDList.Items.Strings[i] = newValue then
          begin
            Application.MessageBox('Такой OperatorID уже присутствует', 'Ошибка', MB_OK + MB_ICONERROR);
            exit;
          end;
      end;
    //Заносим в список
    LB_OperatorIDList.Items.Delete(index);
    if index > 0 then
      LB_OperatorIDList.Items.Insert(index, IntToStr(tmpInteger))
    else
      LB_OperatorIDList.Items.Insert(0, NewValue);
  except
    Application.MessageBox('Неправильный OperatorID', 'Ошибка', MB_OK + MB_ICONERROR);
  end;
end;

//Удаление выбранного OperatorID
procedure TFrm_Options.B_DeleteClick(Sender: TObject);
begin
  LB_OperatorIDList.Items.Delete(LB_OperatorIDList.ItemIndex);
end;

end.
