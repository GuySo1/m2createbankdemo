//BATCHTSO PROC                                                         00000100
//TSO      EXEC PGM=IKJEFT01,DYNAMNBR=40,REGION=2M                      00000200
//STEPLIB  DD DSN=DB2.DSNLOAD,DISP=SHR                                  00000300
//DBRMLIB  DD DUMMY                                                     00000400
//*YSPRINT DD SYSOUT=*                                                  00000500
//SYSTSPRT DD SYSOUT=*                                                  00000600
//SYSUDUMP DD SYSOUT=*                                                  00000700
//SYSOUT   DD SYSOUT=*                                                  00000800
//SYSTSIN  DD DDNAME=SYSIN                                              00000900
//*YSTERM  DD SYSOUT=*                                                  00001000
//SYSOPT   DD SYSOUT=*                                                  00001100
//*                                                                     00001200
//* *** $ Version 5.99c sequenced on Wednesday 3 Mar 2011 at 1:00pm     00001300
