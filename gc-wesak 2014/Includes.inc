include	windows.inc
include	kernel32.inc
include	user32.inc
include	gdi32.inc
include	comctl32.inc
include	winmm.inc
include	masm32.inc
include     E:\masm32\macros\macros.asm
include	ole32.inc
include oleaut32.inc

includelib	kernel32.lib
includelib	user32.lib
includelib	gdi32.lib
includelib	comctl32.lib
includelib	winmm.lib
includelib	ole32.lib
includelib  oleaut32.lib
includelib	masm32.lib

include	lib\ufmod.inc
includelib	lib\uFMOD.lib

include lib\image.inc
includelib lib\image.lib

include	lib\pnglib.inc
includelib	lib\pnglib.lib

include lib\crtdll.inc
includelib lib\crtdll.lib

include lib\TextScroller.inc
includelib lib\TextScroller.lib

MainProc			proto:DWORD,:DWORD,:DWORD,:DWORD
AboutProc			proto:DWORD,:DWORD,:DWORD,:DWORD
LoadPng				proto:DWORD,:DWORD
SetClipboard		proto:DWORD
FadeIn				proto
FadeOut				proto
EditCustomCursor	proto:DWORD,:DWORD,:DWORD,:DWORD
EditCustomCursor2	proto:DWORD,:DWORD,:DWORD,:DWORD


scrolling			proto


AllowSingleInstance MACRO lpTitle

	invoke FindWindow,NULL,lpTitle
	cmp eax, 0
	je @F
	  push eax
	  invoke ShowWindow,eax,SW_RESTORE
	  pop eax
	  invoke SetForegroundWindow,eax
	  mov eax, 0
	  ret
	@@:
ENDM
      
.const
	MainDlg			= 100
	AboutDlg		= 111
	EditName		= 101
	EditSerial		= 102
	GenBtn			= 301
	AboutBtn		= 302
	ExitBtn			= 303
	AboutText		= 222
	StaticScroller	= 1001

.data
	Transparency	dd 			0
	TransColor		COLORREF	0FFFFFFFh
	sizeFrame		dd			?,?
	sizeFrame2		dd			?,?
	MoveDlg			BOOL		?
	OldPos			POINT		<>
	NewPos			POINT		<>
	Rect			RECT		<>
	rect			RECT		<>
	rect2			RECT		<>
	handle			dd			?
	
	TxtFont		LOGFONT <-12,0,0,0,FW_NORMAL,FALSE,FALSE,FALSE,0,3,2,1,34,"Verdana">
	AboutFont	LOGFONT <-9,0,0,0,FW_NORMAL,FALSE,FALSE,FALSE,0,3,2,1,34,"Tahoma">
	
	szWinTitle	db	"stark9000~wishes!",0

.data?
	hInstance	dd	?
	hIcon		dd	?
	hCursor		dd	?
	hSerial		dd	?
	hName		dd	?
	hGen		dd	?
	hExit		dd	?
	hAbout		dd	?
	hWND		dd	?
	hIMG		dd	?
	hBrush		dd	?
	hAboutBg	dd	?
	hAboutBrush	dd	?
	hFont		dd	?
	OldWndProc	dd	?
	OldWndProc2	dd	?
	ModHandle	dd	?
	
	scrolltext		dd	200 dup(?)
	scrolltextSwap	dd	200 dup(?)