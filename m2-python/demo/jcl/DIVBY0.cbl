       IDENTIFICATION DIVISION.                
       PROGRAM-ID. DIVBY0. 

       DATA DIVISION.  
       WORKING-STORAGE SECTION.
       01 RESULT      PIC 9(4).

       PROCEDURE DIVISION.                     
           DIVIDE 1 BY 0 GIVING RESULT.       
           STOP RUN.                           