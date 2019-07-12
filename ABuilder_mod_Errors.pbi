; 2019/07/12 | PureBasic 5.70 LTS | by Tristano Ajmone | MIT License
; ******************************************************************************
; *                                                                            *
; *                         ALAN Builder Errors Module                         *
; *                                                                            *
; ******************************************************************************
; This module handles all the errors of the builder tools, as well as creating
; the final errors report.

;  ///////////////////////////////
;- /// MODULE PUBLIC INTERFACE ///
;{ ///////////////////////////////
DeclareModule Err
  Structure ErrEntry
    errType.u
    errFile.s
  EndStructure
  NewList ErrL.ErrEntry()
  
  NewMap ErrM.a()
  totErr = 0
  
  Enumeration ErrorTypes
    #BadExtCasing
    #CompileErr
    #ARunErr
    #EmptySolFile
    #MissingSolFile
    #SolFileIsDir
    #CantReadFile
    #CantCreateFile
  EndEnumeration
  #totErrTypes = #PB_Compiler_EnumerationValue -1
  
  Declare   EnlistError(errType, errMsg.s)
  Declare.i ErrorReport()
  Declare   DumpErrFiles(errType)
  Declare   PrintCategoryHeader(errTitle.s)
EndDeclareModule

;} ////////////////////////
;- /// MODULE DEFINITION///
;{ ////////////////////////
Module Err
  ;  ////////////////////////
  ;- /// PUBLIC PROCEDURES///
  ;  ////////////////////////
  Procedure EnlistError(errType, errMsg.s)
    Shared ErrL(), ErrM(), totErr
    With ErrL()
      AddElement(ErrL())
      \errType = errType
      \errFile = errMsg
      AddMapElement(ErrM(), Str(errType))
      totErr +1
    EndWith
  EndProcedure
  
  Procedure DumpErrFiles(errType)
    ; Dump and purge the list of files associated to an error type.
    Shared ErrL()
    PrintN(#Empty$)
    ForEach ErrL()
      With ErrL()
        If \errType = errType
          PrintN(" -- "+ \errFile)
          DeleteElement(ErrL())
        EndIf
      EndWith
    Next
  EndProcedure
  
  Procedure PrintCategoryHeader(errTitle.s)
    errTitleLen = Len(errTitle)
    ConsoleError(#CRLF$+ LSet(#Empty$, errTitleLen, "~"))
    ConsoleError(errTitle)
    ConsoleError(LSet(#Empty$, errTitleLen, "~"))
    
  EndProcedure
  
  Procedure.i ErrorReport()
    Shared totErr
    Protected errType
    Shared ErrL(), ErrM(), totErr
    
    If Not totErr
      PrintN("No errors encountered.")
    Else
      ConsoleError("Errors encountered: "+ Str(totErr))
      For errType = 0 To #totErrTypes
        If FindMapElement(ErrM(), Str(errType))
          Select errType
            Case #BadExtCasing
              PrintCategoryHeader("Malformed File Extensions")
              ConsoleError("ALAN sources and scripts must have lowercase "+
                           "file extensions.")
            Case #CompileErr
              PrintCategoryHeader("Adventure Compile Failure")
              ConsoleError("The following adventures failed to compile.")
            Case #ARunErr
              PrintCategoryHeader("Adventure Execution Failure")
              ConsoleError("ARun failed to execute the following commands scripts.")
            Case #EmptySolFile
              PrintCategoryHeader("Empty Commands Scripts")
              ConsoleError("The following commands scripts are empty files.")
            Case #MissingSolFile
              PrintCategoryHeader("Missing Commands Scripts")
              ConsoleError("Couldn't find some required commands scripts.")
            Case #SolFileIsDir
              PrintCategoryHeader("Commands Scripts Are Directories")
              ConsoleError("Some required commands scripts were found to be "+
                           "folders instead.")
            Case #CantReadFile
              PrintCategoryHeader("File I/O: Read Errors")
              ConsoleError("This tool was unable to read some files.")
            Case #CantCreateFile
              PrintCategoryHeader("File I/O: Write Errors")
              ConsoleError("This tool was unable to create some files.")
          EndSelect
          DumpErrFiles(errType)
        EndIf
      Next
    EndIf
    ProcedureReturn totErr
  EndProcedure
  ;  /////////////////////////
  ;- /// PRIVATE PROCEDURES///
  ;  /////////////////////////
  
EndModule
;}
; /// EOF ///
