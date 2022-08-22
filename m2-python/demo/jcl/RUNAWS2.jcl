//WWCZXLJ2 JOB 'AWSJ2',CLASS=A,MSGCLASS=H,                              00010003
//             REGION=0M,NOTIFY=WWCZXL                                  00020000
//******************************************************************    00020102
//* THIS JOB HAS 3 STEPS                                                00020202
//* STEP 1 WILL DEFINE A VSAM KSDS CLUSTER                              00020302
//* STEP 2 WILL RUN A COBOL PROGRAM TO WRITE A RECORD INTO THE VSAM     00020402
//* STEP 3 WILL RUN SORT TO DISPLAY THE VSAM FILE TO SYSOUT             00020502
//******************************************************************    00020602
//STEP1    EXEC PGM=IDCAMS                                              00021001
//SYSPRINT DD  SYSOUT=*                                                 00022000
//SYSOUT   DD  SYSOUT=*                                                 00023000
//SYSIN    DD  *                                                        00024000
  DEFINE CLUSTER(NAME(WWCZXL.EMP.CLUSTER)   -                           00025000
  RECORDSIZE(30,30)    -                                                00026000
  CYLINDERS(1,1)       -                                                00027000
  FREESPACE(10,20)     -                                                00028000
  KEYS(6,0)            -                                                00029000
  CISZ(300)            -                                                00029100
  INDEXED)             -                                                00029200
  INDEX(NAME(WWCZXL.EMP.CLUSTER.INDEX)) -                               00029300
  DATA(NAME(WWCZXL.EMP.CLUSTER.DATA))                                   00029400
/*                                                                      00029500
//STEP2    EXEC PGM=AWS2COBL                                            00030001
//STEPLIB  DD DSN=WWCZXL.LOADLIB,DISP=SHR                               00040000
//SYSOUT DD SYSOUT=*                                                    00050000
//INFILE DD DSN=WWCZXL.EMP.CLUSTER,DISP=SHR                             00060000
//SYSIN  DD *                                                           00070000
000001 MY1STNAME   MYLASTNAME                                           00080000
//*                                                                     00081001
//STEP3    EXEC PGM=SORT                                                00090001
//SYSOUT   DD SYSOUT=*                                                  00100001
//SORTIN   DD DSN=WWCZXL.EMP.CLUSTER,DISP=SHR                           00110001
//SORTOUT  DD SYSOUT=*                                                  00120001
//SYSIN    DD *                                                         00130001
  SORT FIELDS=COPY                                                      00140001
/*                                                                      00150001
