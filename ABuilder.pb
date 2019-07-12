#VER$ = "0.0.1-Alpha"
; 2019/07/12 | PureBasic 5.70 LTS | by Tristano Ajmone | MIT License
; ******************************************************************************
; *                                                                            *
; *                           ALAN Projects Builder                            *
; *                                                                            *
; ******************************************************************************
; TODO: Check for differently cased same-named adventures in same folder!
;       this is allowd under Linux but not Windows!

; TODO: Retrive Alan SDK version numbers and use them in report.
; TODO: Check for Travis CI env var

; TODO: Fix totAdv to include adventures discarded due to bad extension.
; TODO: Add counter for number of compiled adventure.
; TODO: Add counter for number of total commands scripts (must also check for sol file even when adventure did not compile?).
; TODO: Add counter for number of executed commands scripts.
; TODO: Look for orphan Sol files.
; TODO: Compare filename casing of adventure & solution file.

;  /////////////////////////
;- /// COMPILER SETTINGS ///
;{ /////////////////////////
CompilerIf #PB_Compiler_OS <> #PB_OS_Windows
  CompilerError "Only Windows OS currently supported!"
CompilerEndIf

CompilerIf #PB_Compiler_ExecutableFormat <> #PB_Compiler_Console Or
           #PB_Compiler_Processor <> #PB_Processor_x86
  CompilerError "Compile as 32-bit console executable!"
CompilerEndIf
;} ////////////////
;- /// SETTINGS ///
;{ ////////////////
#AlanSDK = "_dev"+ #PS$ + "AlanSDK" + #PS$
#Alan = #AlanSDK + "alan.exe"
#ARun = #AlanSDK + "arun.exe"

;- External Modules:
XIncludeFile "ABuilder_mod_Errors.pbi"

Declare ScanFolder(Folder.s = #Empty$)
Declare ProcessAdventure(advPath.s)
Declare Abort(errMsg.s)
Declare ValidateExtension(entryPath.s)
Declare ValidateCommandsScript(scriptFile.s)
;} //////////////////
;- /// INITIALIZE ///
;{ //////////////////
OpenConsole("ALAN Projects Builder")
;- Print App Banner
PrintN(#Empty$)
PrintN(LSet(#Empty$, 80, "="))
PrintN("ALAN Projects Builder v"+ #VER$ +" | by Tristano Ajmone, 2019 (MIT License)")
PrintN(LSet(#Empty$, 80, "="))

ProjRoot.s = GetPathPart(ProgramFilename())
SetCurrentDirectory(ProjRoot)
NewList AdvL.s()
;} /////////////////
;- /// MAIN CODE ///
;{ /////////////////
ScanFolder()

totAdv = ListSize(AdvL())
PrintN("Total adventures found: "+ Str(totAdv))
ForEach AdvL()
  ProcessAdventure(AdvL())
Next
; TODO: Create Stats Report
ExCode = Err::ErrorReport()

;} ///////////////
;- /// WRAP-UP ///
;{ ///////////////
CloseConsole()
End ExCode

;} //////////////////
;- /// PROCEDURES ///
;{ //////////////////
Procedure ScanFolder(Folder.s = #Empty$)
  Shared AdvL()
  Protected currDir, entryName.s
  
  currDir = ExamineDirectory(#PB_Any, Folder, #Empty$)
  If currDir
    While NextDirectoryEntry(currDir)
      entryName.s = DirectoryEntryName(currDir)
      entryPath.s = Folder + entryName
      If DirectoryEntryType(currDir) = #PB_DirectoryEntry_File
        ;  =================
        ;- EntryType is File
        ;  =================
        fExt.s = GetExtensionPart(entryName)
        ; Skip if filename beings with underscore
        ; ---------------------------------------
        If Left(entryName, 1) = "_"
          Continue
        EndIf
        If LCase(fExt) = "alan"
          ValidateExtension(entryPath)
          AddElement(AdvL())
          AdvL() = entryPath
        ElseIf LCase(fExt) = "a3sol"
          ValidateExtension(entryPath)
          ; TODO: Add to List of Sol files?
        EndIf
      Else
        ;  ======================
        ;- EntryType is Directory
        ;  ======================
        ;  Folder-Ignore patterns
        ;  ----------------------
        If entryName = "." Or entryName = ".." Or
           entryName = ".git" Or
           Left(entryName, 1) = "_"
          Continue
        EndIf
        ; Recurse into Sub-Category
        ; -------------------------
        entryPath.s = entryPath + #PS$
        ScanFolder(entryPath)
      EndIf
    Wend
  Else
    Abort("Unable to process folder: "+ Folder)
  EndIf
EndProcedure ; ScanFolder()

Procedure ProcessAdventure(advPath.s)
  advDir.s = GetPathPart(advPath)
  advSrc.s = GetFilePart(advPath)
  advBin.s = GetFilePart(advPath, #PB_FileSystem_NoExtension) +".a3c"
  advSol.s = GetFilePart(advPath, #PB_FileSystem_NoExtension) +".a3sol"
  advLog.s = GetFilePart(advPath, #PB_FileSystem_NoExtension) +".a3log"
  ;  =================
  ;- Compile Adventure
  ;  =================
  #AlanFlags = #PB_Program_Open | #PB_Program_Wait | #PB_Program_Hide
  Alan = RunProgram(#Alan, advSrc, advDir, #AlanFlags)
  If Not Alan
    Abort("Unable to invoke Alan compiler!")
  EndIf
  AlanExCode = ProgramExitCode(Alan)
  CloseProgram(Alan)
  ;  ===========================
  ;- Commands Script -> Validate
  ;  ===========================
  ;  Check if the adventure has a valid ".a3sol" script before checking if Alan
  ;  compiler exited with error, othewrise we'd skip the check due to procedure
  ;  abortion.
  HasValidSol = ValidateCommandsScript(advDir + advSol)
  ; Abort procedure if Alan compiler exited with error:
  If AlanExCode
    Err::EnlistError(Err::#CompileErr, advPath)
    ProcedureReturn
  EndIf
  ; If the adventure has no .a3sol file (or a malformed one) no need to carry on:
  If Not HasValidSol
    ProcedureReturn
  EndIf
  ;  ==========================
  ;- Commands Script -> Execute
  ;  ==========================
  #ARunFlags = #PB_Program_Open | #PB_Program_Write | #PB_Program_Read |
               #PB_Program_Hide | #PB_Program_Ascii
  ARun = RunProgram(#ARun, "-r "+ advBin, advDir, #ARunFlags)
  If Not ARun
    Abort("Unable to invoke ARun!")
  EndIf
  
  solFile = OpenFile(#PB_Any, advDir + advSol, #PB_Ascii)
  If Not solFile
    Err::EnlistError(Err::#CantReadFile, advDir + advSol)
    Goto ARunWrapUp:
  EndIf
  
  While Not Eof(solFile)
    WriteProgramStringN(ARun, ReadString(solFile))
  Wend
  WriteProgramData(ARun, #PB_Program_Eof, 0)
  
  logFile = OpenFile(#PB_Any, advDir + advLog, #PB_Ascii)
  If Not logFile
    Err::EnlistError(Err::#CantCreateFile, advDir + advLog)
    Goto ARunWrapUp:
  EndIf
  
  While ProgramRunning(ARun)
    While AvailableProgramOutput(ARun)
      WriteStringN(logFile, ReadProgramString(ARun))
    Wend
  Wend
  ARunExCode = ProgramExitCode(ARun)
  If ARunExCode
    Err::EnlistError(Err::#ARunErr, advDir + advSol)
  Else
  EndIf
  
  ARunWrapUp:
  CloseProgram(ARun)
  CloseFile(logFile)
  CloseFile(solFile)
EndProcedure ; ProcessAdventure

Procedure ValidateExtension(entryPath.s)
  Protected fExt.s = GetExtensionPart(entryPath)
  If fExt <> LCase(fExt)
    Err::EnlistError(Err::#BadExtCasing, entryPath)
  EndIf
EndProcedure

Procedure ValidateCommandsScript(scriptFile.s)
  Select FileSize(scriptFile)
    Case 0
      Err::EnlistError(Err::#EmptySolFile, scriptFile)
      ProcedureReturn
    Case -1
      Err::EnlistError(Err::#MissingSolFile, scriptFile)
      ProcedureReturn
    Case -2
      Err::EnlistError(Err::#SolFileIsDir, scriptFile + #PS$)
      ProcedureReturn
  EndSelect
  ; TODO: Increase sol counter here???
  ProcedureReturn #True
EndProcedure

Procedure Abort(errMsg.s)
  ConsoleError(~"\n*** FATAL ERROR ***\n\n" + errMsg)
  ConsoleError(~"\n/// Aborting build execution ///")
  End 1
EndProcedure
;}
; /// EOF ///
