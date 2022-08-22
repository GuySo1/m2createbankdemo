//WWCZXLJ4 JOB 'AWSJ4',CLASS=A,MSGCLASS=H,                              00010000
//             REGION=0M,NOTIFY=WWCZXL                                  00020000
//*******************************************************************   00020100
//* THIS JOB HAS 2 STEPS                                                00020200
//* STEP 1 WILL USE IEBDG TO CREATE A SEQUENTIAL DATA SET               00020300
//* STEP 2 WILL PRINT THE DATA SET USING IEBGENER                       00020400
//*******************************************************************   00020600
//STEP1    EXEC PGM=IEBDG                                               00020700
//SYSPRINT DD  SYSOUT=*                                                 00020800
//SEQOUT   DD  DSNAME=WWCZXL.DTSET,UNIT=SYSDA,DISP=(,CATLG),            00020900
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=800),                     00021000
//             SPACE=(TRK,(10,10))                                      00022000
//SYSIN    DD  *                                                        00023000
   DSD OUTPUT=(SEQOUT)                                                  00024000
   FD  NAME=FIELD1,LENGTH=30,STARTLOC=1,FORMAT=AL,ACTION=TL             00025000
   FD  NAME=FIELD2,LENGTH=30,STARTLOC=31,FORMAT=AL,ACTION=TR            00026000
   FD  NAME=FIELD3,LENGTH=10,STARTLOC=71,PICTURE=10,                   X00027000
               P'1234567890',INDEX=1                                    00027100
   CREATE QUANTITY=100,NAME=(FIELD1,FIELD2,FIELD3),FILL=X'FF'           00027200
   END                                                                  00027300
//STEP2    EXEC PGM=IEBGENER                                            00028000
//SYSPRINT DD  SYSOUT=*                                                 00029000
//SYSIN    DD  DUMMY                                                    00030000
//SYSUT1   DD  DSNAME=WWCZXL.DTSET,DISP=SHR                             00040000
//SYSUT2   DD  SYSOUT=*                                                 00050000
