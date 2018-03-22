#SingleInstance, force
;pro debug
IfExist, %A_ScriptDir%\Export.txt
{
MsgBox, 4, Attenzione, Rimuovo log precedente?
	IfMsgBox, Yes
		FileDelete, %A_ScriptDir%\Export.txt
}
Opath := %A_ScriptDir%\Export.txt
;seleziona, apri e carica contenuto file in oggetto
FileSelectFile, Ifile
OFile := FileOpen(Ifile, "r")
CntFile := OFile.Read()
;verifica la lunghezza del file 
Loop, parse, CntFile
	fine_ciclo := A_Index
;riporta il puntatore all'origine
OFile.Pos := 0
;setta i flag
onx := inx := 0
;setta il limite mensile (numero di righi nell'output, escludendo il rigo intestazione)
giorni := 31 ;febbraio 28 giorni
;~ setta progress bar
Progress,AB R0-%fine_ciclo% ZY25
Loop, parse, CntFile
{
	Progress, %A_Index%, %A_index% / %fine_ciclo% 
	inx++
	;~ MsgBox % A_Loopfield
	FileAppend, %A_loopfield%, %Opath%
	If (onx = 0 and inx = 95)
	{
		FileAppend, `r`n, %A_ScriptDir%\Export.txt
		onx := 1
		inx := 0
		;~ MsgBox,0, 1, inx = %inx% `r`n onx = %onx% `r`n
	}
	else If (onx = giorni and inx = 52)
	{
		;~ MsgBox,0, 3PRE, inx = %inx% `r`n onx = %onx% `r`n
		FileAppend, `r`n, %A_ScriptDir%\Export.txt
		onx := inx := 0
		;~ MsgBox,0, 3POST, inx = %inx% `r`n onx = %onx% `r`n
	}
	else If (onx >= 1 and inx = 52)
	{
		;~ MsgBox,0, 2PRE, inx = %inx% `r`n onx = %onx% `r`n
		FileAppend, `r`n, %A_ScriptDir%\Export.txt
		inx := 0
		onx++
		;~ MsgBox,0, 2POST, inx = %inx% `r`n onx = %onx% `r`n
	}

}
Progress, OFF
MsgBox,0,Operazione Conclusa,Operazione Conclusa - File di risultato: %A_ScriptDir%\Export.txt
return