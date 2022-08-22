       IDENTIFICATION DIVISION.                                         00010000
       PROGRAM-ID. WRITVSAM.                                            00020000
                                                                        00020100
       ENVIRONMENT DIVISION.                                            00021000
       INPUT-OUTPUT SECTION.                                            00022000
                                                                        00022100
       FILE-CONTROL.                                                    00023000
           SELECT ML-INFILE ASSIGN TO INFILE                            00024000
           ORGANIZATION IS INDEXED                                      00025000
           ACCESS MODE IS RANDOM                                        00026000
           RECORD KEY IS IN-EMPID                                       00027000
           FILE STATUS IS ML-STAT.                                      00028000
                                                                        00029000
       DATA DIVISION.                                                   00029100
       FILE SECTION.                                                    00029200
       FD ML-INFILE.                                                    00029300
       01 IN-EMPREC.                                                    00029400
          05 IN-EMPID     PIC X(06).                                    00029500
          05 IN-FIRSTNAME PIC X(12).                                    00029600
          05 IN-LASTNAME  PIC X(12).                                    00029700
       WORKING-STORAGE SECTION.                                         00029800
       01 ML-STAT          PIC X(02) VALUE SPACE.                       00029900
          88 ML-SUCCESS    VALUE X'00'.                                 00030000
          88 ML-EOF        VALUE X'10'.                                 00030100
       01 ML-REC           PIC X(30).                                   00030200
       01 ML-EOFSTAT       PIC X(01) VALUE 'N'.                         00030300
          88 ML-EOFNO      VALUE 'N'.                                   00030400
          88 ML-EOFYES     VALUE 'Y'.                                   00030500
       PROCEDURE DIVISION.                                              00031000
       MAIN-PARA.                                                       00032000
           PERFORM OPEN-PARA    THROUGH OPEN-EXIT.                      00033000
           PERFORM READ-PARA    THROUGH READ-EXIT.                      00034000
           PERFORM INSERT-PARA  THROUGH INS-EXIT.                       00034100
           PERFORM CLOSE-PARA   THROUGH CLOSE-EXIT.                     00035000
           STOP RUN.                                                    00036001
       ERROR-EXIT.                                                      00036103
           EXIT.                                                        00036203
                                                                        00036303
       OPEN-PARA.                                                       00037000
           INITIALIZE ML-STAT ML-REC ML-EOFSTAT.                        00037100
           OPEN OUTPUT ML-INFILE.                                       00038000
           IF ML-STAT = '00'                                            00038105
              DISPLAY "FILE OPEN SUCCESSFUL"                            00038206
           ELSE                                                         00038300
              DISPLAY "FILE OPEN ERROR"                                 00038406
              GO TO ERROR-EXIT                                          00038503
           END-IF.                                                      00038600
       OPEN-EXIT.                                                       00038700
           EXIT.                                                        00038800
                                                                        00038900
       READ-PARA.                                                       00039000
           ACCEPT ML-REC.                                               00050000
           DISPLAY ML-REC.                                              00060000
       READ-EXIT.                                                       00061000
           EXIT.                                                        00062000
                                                                        00063000
       INSERT-PARA.                                                     00064000
           WRITE IN-EMPREC FROM ML-REC.                                 00070000
       INS-EXIT.                                                        00080000
           EXIT.                                                        00090000
                                                                        00100000
       CLOSE-PARA.                                                      00101000
           CLOSE ML-INFILE.                                             00102000
       CLOSE-EXIT.                                                      00110000
           EXIT.                                                        00120000
