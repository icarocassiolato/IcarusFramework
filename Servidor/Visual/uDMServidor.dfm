object DMServidor: TDMServidor
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Encoding = esASCII
  Height = 150
  Width = 215
  object RESTDWPoolerDB: TRESTDWPoolerDB
    RESTDriver = RESTDWDriverFD
    Compression = True
    Encoding = esUtf8
    StrsTrim = False
    StrsEmpty2Null = False
    StrsTrim2Len = True
    Active = True
    PoolerOffMessage = 'RESTPooler not active.'
    ParamCreate = True
    Left = 128
    Top = 40
  end
  object RESTDWDriverFD: TRESTDWDriverFD
    CommitRecords = 100
    Connection = FDConnection
    Left = 56
    Top = 80
  end
  object FDConnection: TFDConnection
    Params.Strings = (
      'DriverID=FB'
      'User_Name=sysdba'
      'Password=masterkey')
    LoginPrompt = False
    Left = 40
    Top = 16
  end
end
