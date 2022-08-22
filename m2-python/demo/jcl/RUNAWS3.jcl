//WWCZXLJ3 JOB 'AWSJ3',CLASS=A,MSGCLASS=H,                              00010001
//             REGION=0M,NOTIFY=WWCZXL                                  00020000
//*******************************************************************   00020101
//* THIS JOB HAS 3 STEPS                                                00020201
//* STEP 1 WILL DEFINE A VSAM ESDS CLUSTER                              00020301
//* STEP 2 WILL RUN A SORT PROGRAM TO COPY SOME RECORDS TO THE VSAM     00020401
//* STEP 3 WILL RUN A COBOL PROGRAM TO READ AND DISPLAY THE VSAM FILE   00020501
//*******************************************************************   00020601
//STEP1    EXEC PGM=IDCAMS                                              00021000
//SYSPRINT DD  SYSOUT=*                                                 00022000
//SYSOUT   DD  SYSOUT=*                                                 00023000
//SYSIN    DD  *                                                        00024000
  DEFINE CLUSTER(NAME(WWCZXL.ESDS.CLUSTER)   -                          00025000
  RECORDSIZE(60,60)    -                                                00026000
  CYLINDERS(1,1)       -                                                00027000
  CISZ(600)            -                                                00029100
  NONINDEXED)             -                                             00029200
  DATA(NAME(WWCZXL.ESDS.CLUSTER.DATA))                                  00029400
/*                                                                      00029500
//STEP2    EXEC PGM=SORT                                                00060000
//SYSOUT   DD SYSOUT=*                                                  00070000
//SORTIN   DD *                                                         00080000
THIS IS RECORD 1                                                        00081000
THIS IS RECORD 2                                                        00082000
THIS IS RECORD 3                                                        00083000
//SORTOUT  DD DSN=WWCZXL.ESDS.CLUSTER,DISP=SHR                          00090000
//SYSIN    DD *                                                         00100000
 SORT FIELDS=COPY                                                       00110000
/*                                                                      00120000
//STEP3    EXEC PGM=AWS3COBL                                            00130002
//STEPLIB  DD DSN=WWCZXL.LOADLIB,DISP=SHR                               00140002
//SYSOUT DD SYSOUT=*                                                    00150002
//ESDSFILE DD DSN=WWCZXL.ESDS.CLUSTER,DISP=SHR                          00160007
//*                                                                     00190002
