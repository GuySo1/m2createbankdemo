       IDENTIFICATION DIVISION.                                         00010000
       PROGRAM-ID. READVSAM.                                            00020003
                                                                        00020100
       ENVIRONMENT DIVISION.                                            00020200
       INPUT-OUTPUT SECTION.                                            00020300
                                                                        00020400
       FILE-CONTROL.                                                    00020500
           SELECT ML-INFILE ASSIGN TO AS-ESDSFILE                       00020605
           ORGANIZATION IS SEQUENTIAL                                   00020700
           ACCESS MODE IS SEQUENTIAL                                    00020800
           FILE STATUS IS ML-STAT.                                      00021000
                                                                        00022000
       DATA DIVISION.                                                   00023000
       FILE SECTION.                                                    00024000
       FD ML-INFILE.                                                    00025000
       01 IN-EMPREC       PIC X(60).                                    00026000
       WORKING-STORAGE SECTION.                                         00029100
       77 ML-STAT         PIC X(02) VALUE SPACE.                        00029200
       77 OPTION          PIC X(03) VALUE 'YES'.                        00029300
       PROCEDURE DIVISION.                                              00029900
       MAIN-PARA.                                                       00030000
           PERFORM OPEN-PARA.                                           00031000
           PERFORM READ-PARA    UNTIL OPTION = 'NO'.                    00032000
           PERFORM CLOSE-PARA.                                          00034000
           STOP RUN.                                                    00035000
                                                                        00036200
       OPEN-PARA.                                                       00036300
           OPEN INPUT ML-INFILE.                                        00036501
                                                                        00038300
       READ-PARA.                                                       00038400
           READ ML-INFILE                                               00038500
                AT END                                                  00038600
                   MOVE 'NO' TO OPTION                                  00038700
                NOT AT END                                              00038800
                   PERFORM DISPLAY-PARA                                 00038900
           END-READ.                                                    00039000
       DISPLAY-PARA.                                                    00074000
           DISPLAY IN-EMPREC.                                           00075000
       CLOSE-PARA.                                                      00080000
           CLOSE ML-INFILE.                                             00090000
       CLOSE-EXIT.                                                      00100000
           EXIT.                                                        00110000
