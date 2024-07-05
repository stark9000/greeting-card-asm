.686
.model flat,stdcall
option casemap:none

PNGBTN = 1

include	Includes.inc
include	bmpbutn.asm

;Scroller Text Transparency
TRANSPARENT_VALUE	 equ 210

.data
scr				SCROLLER_STRUCT <>
lf				LOGFONT<>


.code
	start:
	invoke GetModuleHandle,NULL
	mov hInstance, eax
	
	invoke LoadIcon, eax, 200
	mov hIcon, eax
	invoke LoadCursor, hInstance, 300
	mov hCursor, eax
	
	AllowSingleInstance addr szWinTitle			
	
	invoke InitCommonControls
	invoke DialogBoxParam, hInstance, MainDlg, 0, addr MainProc, 0
	invoke ExitProcess, NULL

MainProc proc hWnd:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
local ps:PAINTSTRUCT

	push hWnd
	pop hWND

	.if uMsg == WM_INITDIALOG

		invoke SetWindowText,hWnd,addr szWinTitle
		invoke SetWindowPos,hWnd,HWND_TOPMOST,0,0,0,0,SWP_NOMOVE + SWP_NOSIZE
		invoke LoadPng,500,addr sizeFrame
		
		mov hIMG,eax
		invoke CreatePatternBrush,hIMG
		mov hBrush,eax
		invoke ImageButton,hWnd,430,275,703,701,702,ExitBtn		
		mov hExit,eax
		invoke CreateFontIndirect,addr TxtFont
		mov hFont,eax


	
		
	        m2m scr.scroll_hwnd,hWnd
		
		mov scr.scroll_text,chr$(".:: ~ greetings from stark 9000 ::.  : ¸¸.•*¨*• [H][a][p][p][y] [W][e][s][a][k] [d][a][y] ! •*¨*•.¸¸  | Wishing you peace    [ from Saliya Ruchiranga ]...")
		mov scr.scroll_x,250
		mov scr.scroll_y,200
		
		mov scr.scroll_width,230
		
		invoke lstrcpy,addr lf.lfFaceName,chr$("TAHOMA")	
		mov lf.lfHeight,18
		mov lf.lfCharSet,DEFAULT_CHARSET	
		mov lf.lfQuality,ANTIALIASED_QUALITY
		invoke CreateFontIndirect,addr lf		
		mov scr.scroll_hFont,eax
		
		;mov scr.scroll_alpha,TRANSPARENT_VALUE
		mov scr.scroll_textcolor,00FFFFFFh
		
		invoke CreateScroller,addr scr
		
		
		
		invoke SetLayeredWindowAttributes,hWnd,NULL,204,2
		invoke GetWindowLong,hWnd,GWL_EXSTYLE 
		or eax,WS_EX_LAYERED 
		invoke SetWindowLong,hWnd,GWL_EXSTYLE,eax
		invoke SetLayeredWindowAttributes,hWnd,TransColor,0,2
		invoke ShowWindow,hWnd,SW_SHOW
		invoke SetTimer,hWnd,222,40,addr FadeIn

		
		invoke uFMOD_PlaySong,400,hInstance,XM_RESOURCE
	
		
	.elseif uMsg == WM_CTLCOLORDLG
		mov eax, hBrush
		ret 
		
	.elseif uMsg == WM_PAINT
		invoke BeginPaint,hWnd,addr ps
		mov edi,eax
		lea ebx,rect
		assume ebx:ptr RECT
			
		invoke GetClientRect,hWnd,ebx
		invoke CreateSolidBrush,0
		invoke FrameRect,edi,ebx,eax
		invoke EndPaint,hWnd,addr ps
	
	.elseif uMsg == WM_CTLCOLOREDIT || uMsg == WM_CTLCOLORSTATIC
		invoke GetDlgCtrlID,lParam
	.if eax == EditSerial || eax == EditName || eax == StaticScroller
		invoke SetBkMode,wParam,TRANSPARENT
		invoke SetTextColor,wParam,00FFFFFFh
		invoke SetBkColor,wParam,0h
		invoke SetBrushOrgEx,wParam, -2, 20, 0		;change main image as input background X,Y,Z keep Z value 0
		mov eax,hBrush
		ret
	.endif
	
	.elseif uMsg == WM_COMMAND
		mov eax,wParam
		mov edx,eax
		shr edx,16
		and eax,0ffffh
		.if edx == BN_CLICKED
			.if eax == GenBtn
				;invoke GetDlgItemText,hWnd,EditName,addr NameBuffer,sizeof NameBuffer
				.if eax > 20
					;invoke SetDlgItemText,hWnd,EditSerial,addr TooLong
				.elseif eax < 4
					;invoke SetDlgItemText,hWnd,EditSerial,addr TooShort
				.else
					;mov NameLen,eax
					;invoke DoKey,hWnd
				.endif
			.elseif eax == AboutBtn
				;invoke InitCommonControls
				;invoke DialogBoxParam,hInstance,AboutDlg,hWnd,addr AboutProc,0
			.elseif eax == ExitBtn
				invoke SetTimer,hWnd,333,20,addr FadeOut
			.endif
		.elseif edx == EN_CHANGE
			
		.endif
	
	.elseif uMsg == WM_RBUTTONDOWN
		invoke SetCursor,hCursor
	
	.elseif uMsg==WM_LBUTTONDOWN
		invoke SetCursor,hCursor
		mov MoveDlg,TRUE
		invoke SetCapture,hWnd
		invoke GetCursorPos,addr OldPos
	
	.elseif uMsg==WM_MOUSEMOVE		
		invoke SetCursor,hCursor
		.if MoveDlg==TRUE
			invoke GetWindowRect,hWnd,addr Rect
			invoke GetCursorPos,addr NewPos
			mov eax,NewPos.x
			mov ecx,eax
			sub eax,OldPos.x
			mov OldPos.x,ecx
			add eax,Rect.left
			mov ebx,NewPos.y
			mov ecx,ebx
			sub ebx,OldPos.y
			mov OldPos.y,ecx
			add ebx,Rect.top
			mov ecx,Rect.right
			sub ecx,Rect.left
			mov edx,Rect.bottom
			sub edx,Rect.top
			invoke MoveWindow,hWnd,eax,ebx,ecx,edx,TRUE
		.endif
		
	.elseif uMsg==WM_LBUTTONUP		
		invoke SetCursor,hCursor
		mov MoveDlg,FALSE
		invoke ReleaseCapture
	
	.elseif uMsg == WM_LBUTTONDBLCLK || uMsg == WM_LBUTTONUP || uMsg == WM_RBUTTONDBLCLK ||	uMsg == WM_RBUTTONDOWN || uMsg == WM_RBUTTONUP || uMsg == WM_MOUSEMOVE || uMsg == WM_MBUTTONDBLCLK || uMsg == WM_MBUTTONDOWN || uMsg == WM_MBUTTONUP
		invoke SetCursor, hCursor
	
	.elseif uMsg == WM_CLOSE
		invoke DeleteObject, hIMG
		invoke DeleteObject, hBrush
		invoke uFMOD_PlaySong, 0, 0, 0
		invoke EndDialog, hWnd, 0
	.endif
	
	xor eax,eax
	Ret
MainProc EndP

EditCustomCursor proc hWnd:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD

	.if uMsg==WM_SETCURSOR
		invoke SetCursor,hCursor
	.else
		invoke CallWindowProc,OldWndProc,hWnd,uMsg,wParam,lParam
		ret
	.endif
	
	xor eax,eax
	Ret
EditCustomCursor EndP

EditCustomCursor2 proc hWnd:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD

	.if uMsg==WM_SETCURSOR
		invoke SetCursor,hCursor
	.else
		invoke CallWindowProc,OldWndProc2,hWnd,uMsg,wParam,lParam
		ret
	.endif
	
	xor eax,eax
	ret
EditCustomCursor2 EndP

LoadPng proc ID:DWORD,pSize:DWORD
local pngInfo:PNGINFO

	invoke PNG_Init, addr pngInfo
	invoke PNG_LoadResource, addr pngInfo, hInstance, ID
	
	.if !eax
		xor eax, eax
		jmp @cleanup
	.endif
	
	invoke PNG_Decode, addr pngInfo
	
	.if !eax
		xor eax, eax
		jmp @cleanup
	.endif
	
	invoke PNG_CreateBitmap, addr pngInfo, hWND, PNG_OUTF_AUTO, FALSE
	
	.if	!eax
		xor eax, eax
		jmp @cleanup
	.endif
	
	mov edi,pSize
	
	.if edi!=0
		lea esi,pngInfo
		movsd
		movsd
	.endif
	
	@cleanup:
	push eax	
	invoke PNG_Cleanup, addr pngInfo
	
	pop eax
	ret
LoadPng endp

SetClipboard proc txtSerial:DWORD

SetClipboard endp

FadeOut proc

	sub Transparency,10
	invoke SetLayeredWindowAttributes,hWND,TransColor,Transparency,2
	cmp Transparency,0
	jne @f
		invoke SendMessage,hWND,WM_CLOSE,0,0
	@@:
	Ret
FadeOut EndP

FadeIn proc

	add Transparency,10
	invoke SetLayeredWindowAttributes,hWND,TransColor,Transparency,2
	cmp Transparency,230
	jne @f
		invoke KillTimer,hWND,222
	@@:
	Ret
FadeIn EndP

End start