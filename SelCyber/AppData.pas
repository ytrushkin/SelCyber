unit AppData;

interface

uses SysUtils, IniFiles;

  type
    TAppData = class
    private
      sAddressFTP       : string;
      sAddressServ      : string;
      sLoginFTP         : string;
      sLoginServ        : string;
      sPasswordFTP      : string;
      sPasswordServ     : string;
      sPathFTP          : string;
      iPeriodTime       : integer;

      //Делать ли дополнительную выборку
      bSelectCVS        : boolean;
      //Поля для CVS
      bInitialSessionNumber : boolean;
      bTerminalID           : boolean;
      bParams               : boolean;
      bAmountAll            : boolean;
      bInitDateTime         : boolean;
      bPaymentDateTime      : boolean;

      sOperatorsID      : string;
    public
      property addressFTP : string read sAddressFTP write sAddressFTP;
      property addressServ : string read sAddressServ write sAddressServ;
      property loginFTP : string read sLoginFTP write sLoginFTP;
      property loginServ : string read sLoginServ write sLoginServ;
      property passwordFTP : string read sPasswordFTP write sPasswordFTP;
      property passwordServ : string read sPasswordServ write sPasswordServ;
      property pathFTP : string read sPathFTP write sPathFTP;
      property periodTime : integer read iPeriodTime write iPeriodTime;
      property selectCVS : boolean read bSelectCVS write bSelectCVS;
      property operatorIDs : string read sOperatorsID write sOperatorsID;

      property initialSessionNumber : boolean read bInitialSessionNumber write bInitialSessionNumber;
      property terminalIDField : boolean read bTerminalID write bTerminalID;
      property params : boolean read bParams write bParams;
      property amountAllField : boolean read bAmountAll write bAmountAll;
      property initDateTimeField : boolean read bInitDateTime write bInitDateTime;
      property paymentDateTimeField : boolean read bPaymentDateTime write bPaymentDateTime;

      function LoadFromIni(path : string) : boolean;
      function AllFieldsChecked() : boolean;
      function SelectesFields : string;
      procedure SaveToIni(path : string);
  end;

var ApplicationData : TAppData;

implementation

function TAppData.LoadFromIni(path : string) : boolean;
var appIni : TIniFile;
begin
try
  appIni := TIniFile.Create(path+'app.ini');
  //Загружаем данные
    sAddressFTP       := appIni.ReadString('options', 'adressFTP', '10.0.0.166');
    sAddressServ      := appIni.ReadString('options', 'adressServ', '10.0.254.2');
    sloginFTP         := appIni.ReadString('options', 'loginFTP', 'term1');
    sLoginServ        := appIni.ReadString('options', 'loginServ', 'troll');
    sPasswordFTP      := appIni.ReadString('options', 'passwordFTP', '9996471614');
    sPasswordServ     := appIni.ReadString('options', 'passwordServ', 'BamBIGaY');
    sPathFTP          := appIni.ReadString('options', 'pathFTP', 'plat');
    iPeriodTime       := appIni.ReadInteger('options', 'periodTime', 5);

    bSelectCvs        := appIni.ReadBool('selectforcvs', 'selectbool', FALSE);

    bInitialSessionNumber := appIni.ReadBool('cvsfields', 'InitialSessionNumber', FALSE);
    bTerminalID           := appIni.ReadBool('cvsfields', 'TerminalID', FALSE);
    bParams               := appIni.ReadBool('cvsfields', 'Params', FALSE);
    bAmountAll            := appIni.ReadBool('cvsfields', 'AmountAll', FALSE);
    bInitDateTime         := appIni.ReadBool('cvsfields', 'InitDateTime', FALSE);
    bPaymentDateTime      := appIni.ReadBool('cvsfields', 'PaymentDateTime', FALSE);
    sOperatorsID          := appIni.ReadString('selectforcvs', 'idlist', '');

  appIni.Free;
except
  result := FALSE;
  exit;
end;
  result := TRUE;
end;

procedure TAppData.SaveToIni(path : string);
var appIni : TIniFile;
begin
  appIni := TIniFile.Create(path+'app.ini');
  //Загружаем данные
    appIni.WriteString('options', 'adressFTP', sAddressFTP);
    appIni.WriteString('options', 'adressServ', sAddressServ);
    appIni.WriteString('options', 'loginFTP', sLoginFTP);
    appIni.WriteString('options', 'loginServ', sloginServ);
    appIni.WriteString('options', 'passwordFTP', sPasswordFTP);
    appIni.WriteString('options', 'passwordServ', sPasswordServ);
    appIni.WriteString('options', 'pathFTP', sPathFTP);
    appIni.WriteInteger('options', 'periodTime', iPeriodTime);

    appIni.WriteBool('selectforcvs', 'selectbool', bSelectCvs);
    appIni.WriteString('selectforcvs', 'idlist', sOperatorsID);
    
    appIni.WriteBool('cvsfields', 'InitialSessionNumber', bInitialSessionNumber);
    appIni.WriteBool('cvsfields', 'TerminalID', bTerminalID);
    appIni.WriteBool('cvsfields', 'Params', bParams);
    appIni.WriteBool('cvsfields', 'AmountAll', bAmountAll);
    appIni.WriteBool('cvsfields', 'InitDateTime', bInitDateTime);
    appIni.WriteBool('cvsfields', 'PaymentDateTime', bPaymentDateTime);

  appIni.Free;
end;

function TAppData.SelectesFields() : string;
begin
  result := '';
  if bInitialSessionNumber then result := result + 'InitialSessionNumber,';
  if bTerminalID then result := result + 'TerminalId,';
  if bParams then result := result + 'Params,';
  if bAmountAll then result := result + 'AmountAll,';
  if bInitDateTime then result := result + 'InitializeDateTime,';
  if bPaymentDateTime then result := result + 'PaymentDateTime,';
  if length(result) > 1 then
    delete(result, Length(result), 1);
end;

function TAppData.AllFieldsChecked() : boolean;
begin
  result := TRUE;

  if not bInitialSessionNumber then result := FALSE;
  if not bAmountAll then result := FALSE;
  if not bParams then result := FALSE; 
  if not bInitDateTime then result := FALSE;
  if not bPaymentDateTime then result := FALSE;
  if not bTerminalID then result := FALSE;
end;

end.
