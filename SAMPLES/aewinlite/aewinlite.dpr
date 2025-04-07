Library aeWinLite;
{отключаем выравнивание в рекордах}
{$A1}
{устанавливаем расширение файла}
{$E d32}
{включаем оптимизацию}
{$O+}
uses
  Messages,
  Windows,
  rsltype in 'rsltype.pas',
  rsldll in 'rsldll.pas',
  rslwin in 'rslwin.pas',
  winplus in 'winplus.pas',
  aeconst in 'aeconst.pas';

Procedure RSLMessageBox(); cdecl;
Var v1, v2, v3:PVALUE;
    res:LongInt;
Begin
  RSLGetParm(0, v1);   RSLGetParm(1, v2);   RSLGetParm(2, v3);
  If (v1.v_type <> V_STRING) then RSLError('MsgBox(Text, Caption:String; Type:Integer)', []);
  If (v2.v_type <> V_STRING) then RSLError('MsgBox(Text, Caption:String; Type:Integer)', []);
  If (v3.v_type <> V_INTEGER) then RSLError('MsgBox(Text, Caption:String; Type:Integer)', []);
  res:=MessageBox(MainWin, v1.RSLString, v2.RSLString, v3.intval);
  RSLReturnVal(res);
End;

////////////////////////////////////////////////////////////////
//Точка инициализации бибилиотеки для RSL
////////////////////////////////////////////////////////////////
Procedure InitExec; stdcall;
Begin
  MainWin:=GetForegroundWindow();
End;
////////////////////////////////////////////////////////////////
//Точка деинициализации бибилиотеки для RSL
////////////////////////////////////////////////////////////////
Procedure  DoneExec; stdcall;
Begin 
End;

procedure RslAttach (activate:Integer); stdcall;
begin
end;

Function DlmMain(isLoad:Integer; anyL:Pointer):Integer;  stdcall;
Begin
  result:=0;
End;

Procedure  AddModuleObjects(); stdcall;
  Var sym:PISYMBOL;
Begin
////////////////////////////////////////////////////////////////////////////////
//  Window Messages
////////////////////////////////////////////////////////////////////////////////
  sym := RSLAddSymGlobal(V_INTEGER, 'WM_COMMAND');           
  RSLSymGlobalSet(sym, WM_COMMAND);	        
    //The WM_COMMAND message is sent when the user selects a command item from a menu, when a control sends a notification message to its parent window, or when an accelerator keystroke is translated. 
    //wNotifyCode = HIWORD(wParam); // notification code 
    //wID = LOWORD(wParam);         // item, control, or accelerator identifier 
    //hwndCtl = (HWND) lParam;      // handle of control 

  sym := RSLAddSymGlobal(V_INTEGER, 'WM_SYSCOMMAND');           
  RSLSymGlobalSet(sym, WM_SYSCOMMAND);
    //A window receives this message when the user chooses a command from the window menu (also known as the System menu or Control menu) or when the user chooses the Maximize button or Minimize button.
    //uCmdType = wParam;        // type of system command requested 
    //xPos = LOWORD(lParam);    // horizontal postion, in screen coordinates 
    //yPos = HIWORD(lParam);    // vertical postion, in screen coordinates 

////////////////////////////////////////////////////////////////////////////////
//  Window Style constants
////////////////////////////////////////////////////////////////////////////////
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_BORDER');
  RSLSymGlobalSet(sym, WS_BORDER);	        //Creates a window that has a thin-line border.
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_CAPTION');          
  RSLSymGlobalSet(sym, WS_CAPTION);	        //Creates a window that has a title bar (includes the WS_BORDER style).
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_CHILD');            
  RSLSymGlobalSet(sym, WS_CHILD);	          //Creates a child window. This style cannot be used with the WS_POPUP style.
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_CHILDWINDOW');      
  RSLSymGlobalSet(sym, WS_CHILDWINDOW);     //Same as the WS_CHILD style.
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_CLIPCHILDREN');     
  RSLSymGlobalSet(sym, WS_CLIPCHILDREN);    //Excludes the area occupied by child windows when drawing occurs within the parent window. This style is used when creating the parent window.
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_CLIPSIBLINGS');     
  RSLSymGlobalSet(sym, WS_CLIPSIBLINGS);    //Clips child windows relative to each other; that is, when a particular child window receives a WM_PAINT message, the WS_CLIPSIBLINGS style clips all other overlapping child windows out of the region of the child window to be updated. If WS_CLIPSIBLINGS is not specified and child windows overlap, it is possible, when drawing within the client area of a child window, to draw within the client area of a neighboring child window.
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_DISABLED');         
  RSLSymGlobalSet(sym, WS_DISABLED);        //Creates a window that is initially disabled. A disabled window cannot receive input from the user.
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_DLGFRAME');         
  RSLSymGlobalSet(sym, WS_DLGFRAME);        //Creates a window that has a border of a style typically used with dialog boxes. A window with this style cannot have a title bar.
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_GROUP');            
  RSLSymGlobalSet(sym, WS_GROUP);           //Specifies the first control of a group of controls. The group consists of this first control and all  controls defined after it, up to the next control with the WS_GROUP style. The first control in each group usually has the WS_TABSTOP style so that the user can move from group to group. The user can subsequently change the keyboard focus from one control in the group to the next control in the group by using the direction keys.
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_HSCROLL');          
  RSLSymGlobalSet(sym, WS_HSCROLL);         //Creates a window that has a horizontal scroll bar.
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_ICONIC');           
  RSLSymGlobalSet(sym, WS_ICONIC);          //Creates a window that is initially minimized. Same as the WS_MINIMIZE style.
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_MAXIMIZE');         
  RSLSymGlobalSet(sym, WS_MAXIMIZE);        //Creates a window that is initially maximized.
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_MAXIMIZEBOX');      
  RSLSymGlobalSet(sym, WS_MAXIMIZEBOX);     //Creates a window that has a Maximize button. Cannot be combined with the WS_EX_CONTEXTHELP style. The WS_SYSMENU style must also be specified. 
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_MINIMIZE');         
  RSLSymGlobalSet(sym, WS_MINIMIZE);        //Creates a window that is initially minimized. Same as the WS_ICONIC style.
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_MINIMIZEBOX');      
  RSLSymGlobalSet(sym, WS_MINIMIZEBOX);     //Creates a window that has a Minimize button. Cannot be combined with the WS_EX_CONTEXTHELP style. The WS_SYSMENU style must also be specified. 
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_OVERLAPPED');       
  RSLSymGlobalSet(sym, WS_OVERLAPPED);      //Creates an overlapped window. An overlapped window has a title bar and a border. Same as the WS_TILED style.
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_OVERLAPPEDWINDOW'); 
  RSLSymGlobalSet(sym, WS_OVERLAPPEDWINDOW);//Creates an overlapped window with the WS_OVERLAPPED, WS_CAPTION, WS_SYSMENU, WS_THICKFRAME, WS_MINIMIZEBOX, and WS_MAXIMIZEBOX styles. Same as the WS_TILEDWINDOW style. 
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_POPUP');            
  RSLSymGlobalSet(sym, WS_POPUP);           //Creates a pop-up window. This style cannot be used with the WS_CHILD style.
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_POPUPWINDOW');      
  RSLSymGlobalSet(sym, WS_POPUPWINDOW);     //Creates a pop-up window with WS_BORDER, WS_POPUP, and WS_SYSMENU styles. The WS_CAPTION and WS_POPUPWINDOW styles must be combined to make the window menu visible.
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_SIZEBOX');          
  RSLSymGlobalSet(sym, WS_SIZEBOX);         //Creates a window that has a sizing border. Same as the WS_THICKFRAME style.
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_SYSMENU');          
  RSLSymGlobalSet(sym, WS_SYSMENU);         //Creates a window that has a window-menu on its title bar. The WS_CAPTION style must also be specified.
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_TABSTOP');          
  RSLSymGlobalSet(sym, WS_TABSTOP);         //Specifies a control that can receive the keyboard focus when the user presses the TAB key. Pressing the TAB key changes the keyboard focus to the next control with the WS_TABSTOP style.
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_THICKFRAME');       
  RSLSymGlobalSet(sym, WS_THICKFRAME);      //Creates a window that has a sizing border. Same as the WS_SIZEBOX style.
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_TILED');            
  RSLSymGlobalSet(sym, WS_TILED);           //Creates an overlapped window. An overlapped window has a title bar and a border. Same as the WS_OVERLAPPED style. 
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_TILEDWINDOW');      
  RSLSymGlobalSet(sym, WS_TILEDWINDOW);     //Creates an overlapped window with the WS_OVERLAPPED, WS_CAPTION, WS_SYSMENU, WS_THICKFRAME, WS_MINIMIZEBOX, and WS_MAXIMIZEBOX styles. Same as the WS_OVERLAPPEDWINDOW style. 
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_VISIBLE');          
  RSLSymGlobalSet(sym, WS_VISIBLE);         //Creates a window that is initially visible.
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_VSCROLL');          
  RSLSymGlobalSet(sym, WS_VSCROLL);         //Creates a window that has a vertical scroll bar.
////////////////////////////////////////////////////////////////////////////////
//  Window Extended Style constants
////////////////////////////////////////////////////////////////////////////////
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_EX_ACCEPTFILES');
  RSLSymGlobalSet(sym, WS_EX_ACCEPTFILES);         //	Specifies that a window created with this style accepts drag-drop files.
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_EX_APPWINDOW');
  RSLSymGlobalSet(sym, WS_EX_APPWINDOW);         //	Forces a top-level window onto the taskbar when the window is minimized.
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_EX_CLIENTEDGE');
  RSLSymGlobalSet(sym, WS_EX_CLIENTEDGE);         //	Specifies that a window has a border with a sunken edge.
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_EX_CONTEXTHELP');
  RSLSymGlobalSet(sym, WS_EX_CONTEXTHELP);         //	Includes a question mark in the title bar of the window. When the user clicks the question mark, the cursor changes to a question mark with a pointer. If the user then clicks a child window, the child receives a WM_HELP message. The child window should pass the message to the parent window procedure, which should call the WinHelp function using the HELP_WM_HELP command. The Help application displays a pop-up window that typically contains help for the child window.WS_EX_CONTEXTHELP cannot be used with the WS_MAXIMIZEBOX or WS_MINIMIZEBOX styles.
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_EX_CONTROLPARENT');
  RSLSymGlobalSet(sym, WS_EX_CONTROLPARENT);         //	Allows the user to navigate among the child windows of the window by using the TAB key.
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_EX_DLGMODALFRAME');
  RSLSymGlobalSet(sym, WS_EX_DLGMODALFRAME);         //	Creates a window that has a double border; the window can, optionally, be created with a title bar by specifying the WS_CAPTION style in the dwStyle parameter.
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_EX_LEFT');
  RSLSymGlobalSet(sym, WS_EX_LEFT);         //	Window has generic "left-aligned" properties. This is the default.
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_EX_LEFTSCROLLBAR');
  RSLSymGlobalSet(sym, WS_EX_LEFTSCROLLBAR);         //	If the shell language is Hebrew, Arabic, or another language that supports reading order alignment, the vertical scroll bar (if present) is to the left of the client area. For other languages, the style is ignored and not treated as an error.
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_EX_LTRREADING');
  RSLSymGlobalSet(sym, WS_EX_LTRREADING);         //	The window text is displayed using Left to Right reading-order properties. This is the default.
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_EX_MDICHILD');
  RSLSymGlobalSet(sym, WS_EX_MDICHILD);         //	Creates an MDI child window.
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_EX_NOPARENTNOTIFY');
  RSLSymGlobalSet(sym, WS_EX_NOPARENTNOTIFY);         //	Specifies that a child window created with this style does not send the WM_PARENTNOTIFY message to its parent window when it is created or destroyed.
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_EX_OVERLAPPEDWINDOW');
  RSLSymGlobalSet(sym, WS_EX_OVERLAPPEDWINDOW);         //	Combines the WS_EX_CLIENTEDGE and WS_EX_WINDOWEDGE styles.
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_EX_PALETTEWINDOW');
  RSLSymGlobalSet(sym, WS_EX_PALETTEWINDOW);         //	Combines the WS_EX_WINDOWEDGE, WS_EX_TOOLWINDOW, and WS_EX_TOPMOST styles.
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_EX_RIGHT');
  RSLSymGlobalSet(sym, WS_EX_RIGHT);         //	Window has generic "right-aligned" properties. This depends on the window class. This style has an effect only if the shell language is Hebrew, Arabic, or another language that supports reading order alignment; otherwise, the style is ignored and not treated as an error.
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_EX_RIGHTSCROLLBAR');
  RSLSymGlobalSet(sym, WS_EX_RIGHTSCROLLBAR);         //	Vertical scroll bar (if present) is to the right of the client area. This is the default.
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_EX_RTLREADING');
  RSLSymGlobalSet(sym, WS_EX_RTLREADING);         //	If the shell language is Hebrew, Arabic, or another language that supports reading order alignment, the window text is displayed using Right to Left reading-order properties. For other languages, the style is ignored and not treated as an error.
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_EX_STATICEDGE');
  RSLSymGlobalSet(sym, WS_EX_STATICEDGE);         //	Creates a window with a three-dimensional border style intended to be used for items that do not accept user input.
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_EX_TOOLWINDOW');
  RSLSymGlobalSet(sym, WS_EX_TOOLWINDOW);         //	Creates a tool window; that is, a window intended to be used as a floating toolbar. A tool window has a title bar that is shorter than a normal title bar, and the window title is drawn using a smaller font. A tool window does not appear in the taskbar or in the dialog that appears when the user presses ALT+TAB.
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_EX_TOPMOST');
  RSLSymGlobalSet(sym, WS_EX_TOPMOST);         //	Specifies that a window created with this style should be placed above all non-topmost windows and should stay above them, even when the window is deactivated. To add or remove this style, use the SetWindowPos function.
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_EX_TRANSPARENT');
  RSLSymGlobalSet(sym, WS_EX_TRANSPARENT);         //	Specifies that a window created with this style is to be transparent. That is, any windows that are beneath the window are not obscured by the window. A window created with this style receives WM_PAINT messages only after all sibling windows beneath it have been updated.
  sym := RSLAddSymGlobal(V_INTEGER, 'WS_EX_WINDOWEDGE');
  RSLSymGlobalSet(sym, WS_EX_WINDOWEDGE);         //	Specifies that a window has a border with a raised edge.
///////////////////////////////////////////////////////////////////////////
// Button Styles
///////////////////////////////////////////////////////////////////////////
  sym := RSLAddSymGlobal(V_INTEGER, 'BS_3STATE');
  RSLSymGlobalSet(sym, BS_3STATE);     //	Creates a button that is the same as a check box, except that the box can be grayed as well as checked or unchecked. Use the grayed state to show that the state of the check box is not determined.
  sym := RSLAddSymGlobal(V_INTEGER, 'BS_AUTO3STATE');
  RSLSymGlobalSet(sym, BS_AUTO3STATE);     //	Creates a button that is the same as a three-state check box, except that the box changes its state when the user selects it. The state cycles through checked, grayed, and unchecked.
  sym := RSLAddSymGlobal(V_INTEGER, 'BS_AUTOCHECKBOX');
  RSLSymGlobalSet(sym, BS_AUTOCHECKBOX);     //	Creates a button that is the same as a check box, except that the check state automatically toggles between checked and unchecked each time the user selects the check box.
  sym := RSLAddSymGlobal(V_INTEGER, 'BS_AUTORADIOBUTTON');
  RSLSymGlobalSet(sym, BS_AUTORADIOBUTTON);     //	Creates a button that is the same as a radio button, except that when the user selects it, Windows automatically sets the button's check state to checked and automatically sets the check state for all other buttons in the same group to unchecked.
  sym := RSLAddSymGlobal(V_INTEGER, 'BS_CHECKBOX');
  RSLSymGlobalSet(sym, BS_CHECKBOX);     //	Creates a small, empty check box with text. By default, the text is displayed to the right of the check box. To display the text to the left of the check box, combine this flag with the BS_LEFTTEXT style (or with the equivalent BS_RIGHTBUTTON style).
  sym := RSLAddSymGlobal(V_INTEGER, 'BS_DEFPUSHBUTTON');
  RSLSymGlobalSet(sym, BS_DEFPUSHBUTTON);     //	Creates a push button that behaves like a BS_PUSHBUTTON style button, but also has a heavy black border. If the button is in a dialog box, the user can select the button by pressing the ENTER key, even when the button does not have the input focus. This style is useful for enabling the user to quickly select the most likely (default) option.
  sym := RSLAddSymGlobal(V_INTEGER, 'BS_GROUPBOX');          
  RSLSymGlobalSet(sym, BS_GROUPBOX);     //	Creates a rectangle in which other controls can be grouped. Any text associated with this style is displayed in the rectangle's upper left corner.
  sym := RSLAddSymGlobal(V_INTEGER, 'BS_LEFTTEXT');          
  RSLSymGlobalSet(sym, BS_LEFTTEXT);     //	Places text on the left side of the radio button or check box when combined with a radio button or check box style. Same as the BS_RIGHTBUTTON style.
  sym := RSLAddSymGlobal(V_INTEGER, 'BS_OWNERDRAW');          
  RSLSymGlobalSet(sym, BS_OWNERDRAW);     //	Creates an owner-drawn button. The owner window receives a WM_MEASUREITEM message when the button is created and a WM_DRAWITEM message when a visual aspect of the button has changed. Do not combine the BS_OWNERDRAW style with any other button styles.
  sym := RSLAddSymGlobal(V_INTEGER, 'BS_PUSHBUTTON');          
  RSLSymGlobalSet(sym, BS_PUSHBUTTON);     //	Creates a push button that posts a WM_COMMAND message to the owner window when the user selects the button.
  sym := RSLAddSymGlobal(V_INTEGER, 'BS_RADIOBUTTON');          
  RSLSymGlobalSet(sym, BS_RADIOBUTTON);     //	Creates a small circle with text. By default, the text is displayed to the right of the circle. To display the text to the left of the circle, combine this flag with the BS_LEFTTEXT style (or with the equivalent BS_RIGHTBUTTON style). Use radio buttons for groups of related, but mutually exclusive choices.
  sym := RSLAddSymGlobal(V_INTEGER, 'BS_USERBUTTON');          
  RSLSymGlobalSet(sym, BS_USERBUTTON);     //	Obsolete, but provided for compatibility with 16-bit versions of Windows. Win32-based applications should use BS_OWNERDRAW instead.
  sym := RSLAddSymGlobal(V_INTEGER, 'BS_BITMAP');          
  RSLSymGlobalSet(sym, BS_BITMAP);     //	Specifies that the button displays a bitmap.
  sym := RSLAddSymGlobal(V_INTEGER, 'BS_BOTTOM');          
  RSLSymGlobalSet(sym, BS_BOTTOM);     //	Places text at the bottom of the button rectangle.
  sym := RSLAddSymGlobal(V_INTEGER, 'BS_CENTER');          
  RSLSymGlobalSet(sym, BS_CENTER);     //	Centers text horizontally in the button rectangle.
  sym := RSLAddSymGlobal(V_INTEGER, 'BS_ICON');          
  RSLSymGlobalSet(sym, BS_ICON);     //	Specifies that the button displays an icon.
  sym := RSLAddSymGlobal(V_INTEGER, 'BS_LEFT');          
  RSLSymGlobalSet(sym, BS_LEFT);     //	Left-justifies the text in the button rectangle. However, if the button is a check box or radio button that does not have the BS_RIGHTBUTTON style, the text is left justified on the right side of the check box or radio button.
  sym := RSLAddSymGlobal(V_INTEGER, 'BS_MULTILINE');          
  RSLSymGlobalSet(sym, BS_MULTILINE);     //	Wraps the button text to multiple lines if the text string is too long to fit on a single line in the button rectangle.
  sym := RSLAddSymGlobal(V_INTEGER, 'BS_NOTIFY');
  RSLSymGlobalSet(sym, BS_NOTIFY);     //	Enables a button to send BN_DBLCLK, BN_KILLFOCUS, and BN_SETFOCUS notification messages to its parent window. Note that buttons send the BN_CLICKED notification message regardless of whether it has this style.
  sym := RSLAddSymGlobal(V_INTEGER, 'BS_PUSHLIKE');
  RSLSymGlobalSet(sym, BS_PUSHLIKE);     //	Makes a button (such as a check box, three-state check box, or radio button) look and act like a push button. The button looks raised when it isn't pushed or checked, and sunken when it is pushed or checked.
  sym := RSLAddSymGlobal(V_INTEGER, 'BS_RIGHT');
  RSLSymGlobalSet(sym, BS_RIGHT);     //	Right-justifies text in the button rectangle. However, if the button is a check box or radio button that does not have the BS_RIGHTBUTTON style, the text is right justified on the right side of the check box or radio button.
  sym := RSLAddSymGlobal(V_INTEGER, 'BS_RIGHTBUTTON');
  RSLSymGlobalSet(sym, BS_RIGHTBUTTON);     //	Positions a radio button's circle or a check box's square on the right side of the button rectangle. Same as the BS_LEFTTEXT style.
  sym := RSLAddSymGlobal(V_INTEGER, 'BS_TEXT');
  RSLSymGlobalSet(sym, BS_TEXT);     //	Specifies that the button displays text.
  sym := RSLAddSymGlobal(V_INTEGER, 'BS_TOP');
  RSLSymGlobalSet(sym,BS_TOP );     //	Places text at the top of the button rectangle.
  sym := RSLAddSymGlobal(V_INTEGER, 'BS_VCENTER');
  RSLSymGlobalSet(sym, BS_VCENTER);     //	Places text in the middle (vertically) of the button rectangle.
///////////////////////////////////////////////////////////////////////////
// ComboBox Styles
///////////////////////////////////////////////////////////////////////////
  sym := RSLAddSymGlobal(V_INTEGER, 'CBS_AUTOHSCROLL');
  RSLSymGlobalSet(sym, CBS_AUTOHSCROLL);     //	Automatically scrolls the text in an edit control to the right when the user types a character at the end of the line. If this style is not set, only text that fits within the rectangular boundary is allowed.
  sym := RSLAddSymGlobal(V_INTEGER, 'CBS_DISABLENOSCROLL');
  RSLSymGlobalSet(sym, CBS_DISABLENOSCROLL);     //	Shows a disabled vertical scroll bar in the list box when the box does not contain enough items to scroll. Without this style, the scroll bar is hidden when the list box does not contain enough items.
  sym := RSLAddSymGlobal(V_INTEGER, 'CBS_DROPDOWN');
  RSLSymGlobalSet(sym, CBS_DROPDOWN);     //	Similar to CBS_SIMPLE, except that the list box is not displayed unless the user selects an icon next to the edit control.
  sym := RSLAddSymGlobal(V_INTEGER, 'CBS_DROPDOWNLIST');
  RSLSymGlobalSet(sym, CBS_DROPDOWNLIST);     //	Similar to CBS_DROPDOWN, except that the edit control is replaced by a static text item that displays the current selection in the list box.
  sym := RSLAddSymGlobal(V_INTEGER, 'CBS_HASSTRINGS');
  RSLSymGlobalSet(sym, CBS_HASSTRINGS);     //	Specifies that an owner-drawn combo box contains items consisting of strings. The combo box maintains the memory and address for the strings, so the application can use the CB_GETLBTEXT message to retrieve the text for a particular item.
  sym := RSLAddSymGlobal(V_INTEGER, 'CBS_LOWERCASE');
  RSLSymGlobalSet(sym, CBS_LOWERCASE);     //	Converts to lowercase any uppercase characters entered into the edit control of a combo box.
  sym := RSLAddSymGlobal(V_INTEGER, 'CBS_NOINTEGRALHEIGHT');
  RSLSymGlobalSet(sym, CBS_NOINTEGRALHEIGHT);     //	Specifies that the size of the combo box is exactly the size specified by the application when it created the combo box. Normally, Windows sizes a combo box so that it does not display partial items.
  sym := RSLAddSymGlobal(V_INTEGER, 'CBS_OEMCONVERT');
  RSLSymGlobalSet(sym, CBS_OEMCONVERT);     //	Converts text entered in the combo box edit control. The text is converted from the Windows character set to the OEM character set and then back to the Windows set. This ensures proper character conversion when the application calls the CharToOem function to convert a Windows string in the combo box to OEM characters. This style is most useful for combo boxes that contain filenames and applies only to combo boxes created with the CBS_SIMPLE or CBS_DROPDOWN style.
  sym := RSLAddSymGlobal(V_INTEGER, 'CBS_OWNERDRAWFIXED');
  RSLSymGlobalSet(sym, CBS_OWNERDRAWFIXED);     //	Specifies that the owner of the list box is responsible for drawing its contents and that the items in the list box are all the same height. The owner window receives a WM_MEASUREITEM message when the combo box is created and a WM_DRAWITEM message when a visual aspect of the combo box has changed.
  sym := RSLAddSymGlobal(V_INTEGER, 'CBS_OWNERDRAWVARIABLE');
  RSLSymGlobalSet(sym, CBS_OWNERDRAWVARIABLE);     //	Specifies that the owner of the list box is responsible for drawing its contents and that the items in the list box are variable in height. The owner window receives a WM_MEASUREITEM message for each item in the combo box when you create the combo box; the owner window receives a WM_DRAWITEM message when a visual aspect of the combo box has changed.
  sym := RSLAddSymGlobal(V_INTEGER, 'CBS_SIMPLE');
  RSLSymGlobalSet(sym, CBS_SIMPLE);     //	Displays the list box at all times. The current selection in the list box is displayed in the edit control.
  sym := RSLAddSymGlobal(V_INTEGER, 'CBS_SORT');
  RSLSymGlobalSet(sym, CBS_SORT);     //	Automatically sorts strings entered into the list box.
  sym := RSLAddSymGlobal(V_INTEGER, 'CBS_UPPERCASE');
  RSLSymGlobalSet(sym, CBS_UPPERCASE);     //	Converts to uppercase any lowercase characters entered into the edit control of a combo box.
///////////////////////////////////////////////////////////////////////////
// Edit Styles
///////////////////////////////////////////////////////////////////////////
  sym := RSLAddSymGlobal(V_INTEGER, 'ES_AUTOHSCROLL');
  RSLSymGlobalSet(sym, ES_AUTOHSCROLL);     //	Automatically scrolls text to the right by 10 characters when the user types a character at the end of the line. When the user presses the ENTER key, the control scrolls all text back to position zero.
  sym := RSLAddSymGlobal(V_INTEGER, 'ES_AUTOVSCROLL');
  RSLSymGlobalSet(sym, ES_AUTOVSCROLL);     //	Automatically scrolls text up one page when the user presses the ENTER key on the last line.
  sym := RSLAddSymGlobal(V_INTEGER, 'ES_CENTER');
  RSLSymGlobalSet(sym, ES_CENTER);     //	Centers text in a multiline edit control.
  sym := RSLAddSymGlobal(V_INTEGER, 'ES_LEFT');
  RSLSymGlobalSet(sym, ES_LEFT);     //	Left-aligns text.
  sym := RSLAddSymGlobal(V_INTEGER, 'ES_LOWERCASE');
  RSLSymGlobalSet(sym, ES_LOWERCASE);     //	Converts all characters to lowercase as they are typed into the edit control.
  sym := RSLAddSymGlobal(V_INTEGER, 'ES_MULTILINE');
  RSLSymGlobalSet(sym, ES_MULTILINE);     //	Designates a multiline edit control. The default is single-line edit control.
//When the multiline edit control is in a dialog box, the default response to pressing the ENTER key is to activate the default button. To use the ENTER key as a carriage return, use the ES_WANTRETURN style.
//When the multiline edit control is not in a dialog box and the ES_AUTOVSCROLL style is specified, the edit control shows as many lines as possible and scrolls vertically when the user presses the ENTER key. If you do not specify ES_AUTOVSCROLL, the edit control shows as many lines as possible and beeps if the user presses the ENTER key when no more lines can be displayed.
//If you specify the ES_AUTOHSCROLL style, the multiline edit control automatically scrolls horizontally when the caret goes past the right edge of the control. To start a new line, the user must press the ENTER key. If you do not specify ES_AUTOHSCROLL, the control automatically wraps words to the beginning of the next line when necessary. A new line is also started if the user presses the ENTER key. The window size determines the position of the word wrap. If the window size changes, the word wrapping position changes and the text is redisplayed.
//Multiline edit controls can have scroll bars. An edit control with scroll bars processes its own scroll bar messages. Note that edit controls without scroll bars scroll as described in the previous paragraphs and process any scroll messages sent by the parent window.
  sym := RSLAddSymGlobal(V_INTEGER, 'ES_NOHIDESEL');
  RSLSymGlobalSet(sym, ES_NOHIDESEL);     //	Negates the default behavior for an edit control. The default behavior hides the selection when the control loses the input focus and inverts the selection when the control receives the input focus. If you specify ES_NOHIDESEL, the selected text is inverted, even if the control does not have the focus.
  sym := RSLAddSymGlobal(V_INTEGER, 'ES_NUMBER');
  RSLSymGlobalSet(sym, ES_NUMBER);     //	Allows only digits to be entered into the edit control.
  sym := RSLAddSymGlobal(V_INTEGER, 'ES_OEMCONVERT');
  RSLSymGlobalSet(sym, ES_OEMCONVERT);     //	Converts text entered in the edit control. The text is converted from the Windows character set to the OEM character set and then back to the Windows set. This ensures proper character conversion when the application calls the CharToOem function to convert a Windows string in the edit control to OEM characters. This style is most useful for edit controls that contain filenames.
  sym := RSLAddSymGlobal(V_INTEGER, 'ES_PASSWORD');
  RSLSymGlobalSet(sym, ES_PASSWORD);     //	Displays an asterisk (*) for each character typed into the edit control. You can use the EM_SETPASSWORDCHAR message to change the character that is displayed.
  sym := RSLAddSymGlobal(V_INTEGER, 'ES_READONLY');
  RSLSymGlobalSet(sym, ES_READONLY);     //	Prevents the user from typing or editing text in the edit control.
  sym := RSLAddSymGlobal(V_INTEGER, 'ES_RIGHT');
  RSLSymGlobalSet(sym, ES_RIGHT);     //	Right-aligns text in a multiline edit control.
  sym := RSLAddSymGlobal(V_INTEGER, 'ES_UPPERCASE');
  RSLSymGlobalSet(sym, ES_UPPERCASE);     //	Converts all characters to uppercase as they are typed into the edit control.
  sym := RSLAddSymGlobal(V_INTEGER, 'ES_WANTRETURN');
  RSLSymGlobalSet(sym, ES_WANTRETURN);     //	Specifies that a carriage return be inserted when the user presses the ENTER key while entering text into a multiline edit control in a dialog box. If you do not specify this style, pressing the ENTER key has the same effect as pressing the dialog box's default push button. This style has no effect on a single-line edit control.
///////////////////////////////////////////////////////////////////////////
// ListBox Styles
///////////////////////////////////////////////////////////////////////////
  sym := RSLAddSymGlobal(V_INTEGER, 'LBS_DISABLENOSCROLL');
  RSLSymGlobalSet(sym, LBS_DISABLENOSCROLL);     //	Shows a disabled vertical scroll bar for the list box when the box does not contain enough items to scroll. If you do not specify this style, the scroll bar is hidden when the list box does not contain enough items.
  sym := RSLAddSymGlobal(V_INTEGER, 'LBS_EXTENDEDSEL');
  RSLSymGlobalSet(sym, LBS_EXTENDEDSEL);     //	Allows multiple items to be selected by using the SHIFT key and the mouse or special key combinations.
  sym := RSLAddSymGlobal(V_INTEGER, 'LBS_HASSTRINGS');
  RSLSymGlobalSet(sym, LBS_HASSTRINGS);     //	Specifies that a list box contains items consisting of strings. The list box maintains the memory and addresses for the strings so the application can use the LB_GETTEXT message to retrieve the text for a particular item. By default, all list boxes except owner-drawn list boxes have this style. You can create an owner-drawn list box either with or without this style.
  sym := RSLAddSymGlobal(V_INTEGER, 'LBS_MULTICOLUMN');
  RSLSymGlobalSet(sym, LBS_MULTICOLUMN);     //	Specifies a multicolumn list box that is scrolled horizontally. The LB_SETCOLUMNWIDTH message sets the width of the columns.
  sym := RSLAddSymGlobal(V_INTEGER, 'LBS_MULTIPLESEL');
  RSLSymGlobalSet(sym, LBS_MULTIPLESEL);     //	Turns string selection on or off each time the user clicks or double-clicks a string in the list box. The user can select any number of strings.
  sym := RSLAddSymGlobal(V_INTEGER, 'LBS_NODATA');
  RSLSymGlobalSet(sym, LBS_NODATA);     //	Specifies a no-data list box. Specify this style when the count of items in the list box will exceed one thousand. A no-data list box must also have the LBS_OWNERDRAWFIXED style, but must not have the LBS_SORT or LBS_HASSTRINGS style.
//A no-data list box resembles an owner-drawn list box except that it contains no string or bitmap data for an item. Commands to add, insert, or delete an item always ignore any given item data; requests to find a string within the list box always fail. Windows sends the WM_DRAWITEM message to the owner window when an item must be drawn. The itemID member of the DRAWITEMSTRUCT structure passed with the WM_DRAWITEM message specifies the line number of the item to be drawn. A no-data list box does not send a WM_DELETEITEM message.
  sym := RSLAddSymGlobal(V_INTEGER, 'LBS_NOINTEGRALHEIGHT');
  RSLSymGlobalSet(sym, LBS_NOINTEGRALHEIGHT);     //	Specifies that the size of the list box is exactly the size specified by the application when it created the list box. Normally, Windows sizes a list box so that the list box does not display partial items.
  sym := RSLAddSymGlobal(V_INTEGER, 'LBS_NOREDRAW');
  RSLSymGlobalSet(sym, LBS_NOREDRAW);     //	Specifies that the list box's appearance is not updated when changes are made. You can change this style at any time by sending a WM_SETREDRAW message.
  sym := RSLAddSymGlobal(V_INTEGER, 'LBS_NOSEL');
  RSLSymGlobalSet(sym, LBS_NOSEL);     //	Specifies that the list box contains items that can be viewed but not selected.
  sym := RSLAddSymGlobal(V_INTEGER, 'LBS_NOTIFY');
  RSLSymGlobalSet(sym, LBS_NOTIFY);     //	Notifies the parent window with an input message whenever the user clicks or double-clicks a string in the list box.
  sym := RSLAddSymGlobal(V_INTEGER, 'LBS_OWNERDRAWFIXED');
  RSLSymGlobalSet(sym, LBS_OWNERDRAWFIXED);     //	Specifies that the owner of the list box is responsible for drawing its contents and that the items in the list box are the same height. The owner window receives a WM_MEASUREITEM message when the list box is created and a WM_DRAWITEM message when a visual aspect of the list box has changed.
  sym := RSLAddSymGlobal(V_INTEGER, 'LBS_OWNERDRAWVARIABLE');
  RSLSymGlobalSet(sym, LBS_OWNERDRAWVARIABLE);     //	Specifies that the owner of the list box is responsible for drawing its contents and that the items in the list box are variable in height. The owner window receives a WM_MEASUREITEM message for each item in the combo box when the combo box is created and a WM_DRAWITEM message when a visual aspect of the combo box has changed.
  sym := RSLAddSymGlobal(V_INTEGER, 'LBS_SORT');
  RSLSymGlobalSet(sym, LBS_SORT);     //	Sorts strings in the list box alphabetically.
  sym := RSLAddSymGlobal(V_INTEGER, 'LBS_STANDARD');
  RSLSymGlobalSet(sym, LBS_STANDARD);     //	Sorts strings in the list box alphabetically. The parent window receives an input message whenever the user clicks or double-clicks a string. The list box has borders on all sides.
  sym := RSLAddSymGlobal(V_INTEGER, 'LBS_USETABSTOPS');
  RSLSymGlobalSet(sym, LBS_USETABSTOPS);     //	Enables a list box to recognize and expand tab characters when drawing its strings. The default tab positions are 32 dialog box units. A dialog box unit is a horizontal or vertical distance. One horizontal dialog box unit is equal to one-fourth of the current dialog box base-width unit. Windows calculates these units based on the height and width of the current system font. The GetDialogBaseUnits function returns the current dialog box base units in pixels.
  sym := RSLAddSymGlobal(V_INTEGER, 'LBS_WANTKEYBOARDINPUT');
  RSLSymGlobalSet(sym, LBS_WANTKEYBOARDINPUT);     //	Specifies that the owner of the list box receives WM_VKEYTOITEM messages whenever the user presses a key and the list box has the input focus. This enables an application to perform special processing on the keyboard input.
///////////////////////////////////////////////////////////////////////////
// ScrollBar Styles
///////////////////////////////////////////////////////////////////////////
  sym := RSLAddSymGlobal(V_INTEGER, 'SBS_BOTTOMALIGN');
  RSLSymGlobalSet(sym, SBS_BOTTOMALIGN);     //	Aligns the bottom edge of the scroll bar with the bottom edge of the rectangle defined by the parameters x, y, nWidth, and nHeight. The scroll bar has the default height for system scroll bars. Use this style with the SBS_HORZ style.
  sym := RSLAddSymGlobal(V_INTEGER, 'SBS_HORZ');
  RSLSymGlobalSet(sym, SBS_HORZ);     //	Designates a horizontal scroll bar. If neither the SBS_BOTTOMALIGN nor SBS_TOPALIGN style is specified, the scroll bar has the height, width, and position defined by x, y, nWidth, and nHeight.
  sym := RSLAddSymGlobal(V_INTEGER, 'SBS_LEFTALIGN');
  RSLSymGlobalSet(sym, SBS_LEFTALIGN);     //	Aligns the left edge of the scroll bar with the left edge of the rectangle defined by the parameters x, y, nWidth, and nHeight. The scroll bar has the default width for system scroll bars. Use this style with the SBS_VERT style.
  sym := RSLAddSymGlobal(V_INTEGER, 'SBS_RIGHTALIGN');
  RSLSymGlobalSet(sym, SBS_RIGHTALIGN);     //	Aligns the right edge of the scroll bar with the right edge of the rectangle defined by the parameters x, y, nWidth, and nHeight. The scroll bar has the default width for system scroll bars. Use this style with the SBS_VERT style.
  sym := RSLAddSymGlobal(V_INTEGER, 'SBS_SIZEBOX');
  RSLSymGlobalSet(sym, SBS_SIZEBOX);     //	Designates a size box. If you specify neither the SBS_SIZEBOXBOTTOMRIGHTALIGN nor the SBS_SIZEBOXTOPLEFTALIGN style, the size box has the height, width, and position specified by the parameters x, y, nWidth, and nHeight.
  sym := RSLAddSymGlobal(V_INTEGER, 'SBS_SIZEBOXBOTTOMRIGHTALIGN');
  RSLSymGlobalSet(sym, SBS_SIZEBOXBOTTOMRIGHTALIGN);     //	Aligns the lower-right corner of the size box with the lower-right corner of the rectangle specified by the parameters x, y, nWidth, and nHeight. The size box has the default size for system size boxes. Use this style with the SBS_SIZEBOX style.
  sym := RSLAddSymGlobal(V_INTEGER, 'SBS_SIZEBOXTOPLEFTALIGN');
  RSLSymGlobalSet(sym, SBS_SIZEBOXTOPLEFTALIGN);     //	Aligns the upper-left corner of the size box with the upper-left corner of the rectangle specified by the parameters x, y, nWidth, and nHeight. The size box has the default size for system size boxes. Use this style with the SBS_SIZEBOX style.
  sym := RSLAddSymGlobal(V_INTEGER, 'SBS_SIZEGRIP');
  RSLSymGlobalSet(sym, SBS_SIZEGRIP);     //	Same as SBS_SIZEBOX, but with a raised edge.
  sym := RSLAddSymGlobal(V_INTEGER, 'SBS_TOPALIGN');
  RSLSymGlobalSet(sym, SBS_TOPALIGN);     //	Aligns the top edge of the scroll bar with the top edge of the rectangle defined by the parameters x, y, nWidth, and nHeight. The scroll bar has the default height for system scroll bars. Use this style with the SBS_HORZ style.
  sym := RSLAddSymGlobal(V_INTEGER, 'SBS_VERT');
  RSLSymGlobalSet(sym, SBS_VERT);     //	Designates a vertical scroll bar. If you specify neither the SBS_RIGHTALIGN nor the SBS_LEFTALIGN style, the scroll bar has the height, width, and position specified by the parameters x, y, nWidth, and nHeight.
///////////////////////////////////////////////////////////////////////////
// Static Styles
///////////////////////////////////////////////////////////////////////////
  sym := RSLAddSymGlobal(V_INTEGER, 'SS_BITMAP');
  RSLSymGlobalSet(sym, SS_BITMAP);     //	Specifies a bitmap is to be displayed in the static control. The error code text is the name of a bitmap (not a filename) defined elsewhere in the resource file. The style ignores the nWidth and nHeight parameters; the control automatically sizes itself to accommodate the bitmap.
  sym := RSLAddSymGlobal(V_INTEGER, 'SS_BLACKFRAME');
  RSLSymGlobalSet(sym, SS_BLACKFRAME);     //	Specifies a box with a frame drawn in the same color as the window frames. This color is black in the default Windows color scheme.
  sym := RSLAddSymGlobal(V_INTEGER, 'SS_BLACKRECT');
  RSLSymGlobalSet(sym, SS_BLACKRECT);     //	Specifies a rectangle filled with the current window frame color. This color is black in the default Windows color scheme.
  sym := RSLAddSymGlobal(V_INTEGER, 'SS_CENTER');
  RSLSymGlobalSet(sym, SS_CENTER);     //	Specifies a simple rectangle and centers the error code text in the rectangle. The text is formatted before it is displayed. Words that extend past the end of a line are automatically wrapped to the beginning of the next centered line.
  sym := RSLAddSymGlobal(V_INTEGER, 'SS_CENTERIMAGE');
  RSLSymGlobalSet(sym, SS_CENTERIMAGE);     //	Specifies that the midpoint of a static control with the SS_BITMAP or SS_ICON style is to remain fixed when the control is resized. The four sides are adjusted to accommodate a new bitmap or icon.If a static control has the SS_BITMAP style and the bitmap is smaller than the control's client area, the client area is filled with the color of the pixel in the upper-left corner of the bitmap. If a static control has the SS_ICON style, the icon does not appear to paint the client area.
  sym := RSLAddSymGlobal(V_INTEGER, 'SS_GRAYFRAME');
  RSLSymGlobalSet(sym, SS_GRAYFRAME);     //	Specifies a box with a frame drawn with the same color as the screen background (desktop). This color is gray in the default Windows color scheme.
  sym := RSLAddSymGlobal(V_INTEGER, 'SS_GRAYRECT');
  RSLSymGlobalSet(sym, SS_GRAYRECT);     //	Specifies a rectangle filled with the current screen background color. This color is gray in the default Windows color scheme.
  sym := RSLAddSymGlobal(V_INTEGER, 'SS_ICON');
  RSLSymGlobalSet(sym, SS_ICON);     //	Specifies an icon displayed in the dialog box. The given text is the name of an icon (not a filename) defined elsewhere in the resource file. The style ignores the nWidth and nHeight parameters; the icon automatically sizes itself.
  sym := RSLAddSymGlobal(V_INTEGER, 'SS_LEFT');
  RSLSymGlobalSet(sym, SS_LEFT);     //	Specifies a simple rectangle and left-aligns the given text in the rectangle. The text is formatted before it is displayed. Words that extend past the end of a line are automatically wrapped to the beginning of the next left-aligned line.
  sym := RSLAddSymGlobal(V_INTEGER, 'SS_LEFTNOWORDWRAP');
  RSLSymGlobalSet(sym, SS_LEFTNOWORDWRAP);     //	Specifies a simple rectangle and left-aligns the given text in the rectangle. Tabs are expanded but words are not wrapped. Text that extends past the end of a line is clipped.
//  sym := RSLAddSymGlobal(V_INTEGER, 'SS_METAPICT');
//  RSLSymGlobalSet(sym, SS_METAPICT);     Specifies a metafile picture is to be displayed in the static control. The given text is the name of a metafile picture (not a filename) defined elsewhere in the resource file. A metafile static control has a fixed size; the metafile picture is scaled to fit the static control's client area.
  sym := RSLAddSymGlobal(V_INTEGER, 'SS_NOPREFIX');
  RSLSymGlobalSet(sym, SS_NOPREFIX);     //	Prevents interpretation of any ampersand (&) characters in the control's text as accelerator prefix characters. These are displayed with the ampersand removed and the next character in the string underlined. This static control style may be included with any of the defined static controls.
//An application can combine SS_NOPREFIX with other styles by using the bitwise OR (|) operator. This can be useful when filenames or other strings that may contain an ampersand (&) must be displayed in a static control in a dialog box.
  sym := RSLAddSymGlobal(V_INTEGER, 'SS_NOTIFY');
  RSLSymGlobalSet(sym, SS_NOTIFY);     //	Sends the parent window STN_CLICKED and STN_DBLCLK notification messages when the user clicks or double clicks the control.
  sym := RSLAddSymGlobal(V_INTEGER, 'SS_RIGHT');
  RSLSymGlobalSet(sym, SS_RIGHT);     //	Specifies a simple rectangle and right-aligns the given text in the rectangle. The text is formatted before it is displayed. Words that extend past the end of a line are automatically wrapped to the beginning of the next right-aligned line.
//  sym := RSLAddSymGlobal(V_INTEGER, 'SS_RIGHTIMAGE');
//  RSLSymGlobalSet(sym, SS_RIGHTIMAGE);     	Specifies that the bottom-right corner of a static control with the SS_BITMAP or SS_ICON style is to remain fixed when the control is resized. Only the top and left sides are adjusted to accommodate a new bitmap or icon.
  sym := RSLAddSymGlobal(V_INTEGER, 'SS_SIMPLE');
  RSLSymGlobalSet(sym, SS_SIMPLE);     //	Specifies a simple rectangle and displays a single line of left-aligned text in the rectangle. The text line cannot be shortened or altered in any way. The control's parent window or dialog box must not process the WM_CTLCOLORSTATIC message.
  sym := RSLAddSymGlobal(V_INTEGER, 'SS_WHITEFRAME');
  RSLSymGlobalSet(sym, SS_WHITEFRAME);     //	Specifies a box with a frame drawn with the same color as the window backgrounds. This color is white in the default Windows color scheme.
  sym := RSLAddSymGlobal(V_INTEGER, 'SS_WHITERECT');
  RSLSymGlobalSet(sym, SS_WHITERECT);     //	Specifies a rectangle filled with the current window background color. This color is white in the default Windows color scheme.
///////////////////////////////////////////////////////////////////////////
// dialog box styles
///////////////////////////////////////////////////////////////////////////
  sym := RSLAddSymGlobal(V_INTEGER, 'DS_3DLOOK');
  RSLSymGlobalSet(sym, DS_3DLOOK);     //	Gives the dialog box a nonbold font and draws three-dimensional borders around control windows in the dialog box.The DS_3DLOOK style is required only by Win32-based applications compiled for versions of Windows earlier than Windows 95 or Windows NT 4.0. The system automatically applies the three-dimensional look to dialog boxes created by applications compiled for current versions of Windows.
  sym := RSLAddSymGlobal(V_INTEGER, 'DS_ABSALIGN');
  RSLSymGlobalSet(sym, DS_ABSALIGN);     //	Indicates that the coordinates of the dialog box are screen coordinates; otherwise, Windows assumes they are client coordinates.
  sym := RSLAddSymGlobal(V_INTEGER, 'DS_CENTER');
  RSLSymGlobalSet(sym, DS_CENTER);     //	Centers the dialog box in the working area; that is, the area not obscured by the tray.
  sym := RSLAddSymGlobal(V_INTEGER, 'DS_CENTERMOUSE');
  RSLSymGlobalSet(sym, DS_CENTERMOUSE);     //	Centers the mouse cursor in the dialog box.
  sym := RSLAddSymGlobal(V_INTEGER, 'DS_CONTEXTHELP');
  RSLSymGlobalSet(sym, DS_CONTEXTHELP);     //	Includes a question mark in the title bar of the dialog box. When the user clicks the question mark, the cursor changes to a question mark with a pointer. If the user then clicks a control in the dialog box, the control receives a WM_HELP message. The control should pass the message to the dialog procedure, which should call the WinHelp function using the HELP_WM_HELP command. The Help application displays a pop-up window that typically contains help for the control.Note that DS_CONTEXTHELP is just a placeholder. When the dialog box is created, the system checks for DS_CONTEXTHELP and, if it is there, adds WS_EX_CONTEXTHELP to the extended style of the dialog box. WS_EX_CONTEXTHELP cannot be used with the WS_MAXIMIZEBOX or WS_MINIMIZEBOX styles.
  sym := RSLAddSymGlobal(V_INTEGER, 'DS_CONTROL');
  RSLSymGlobalSet(sym, DS_CONTROL);     //	Creates a dialog box that works well as a child window of another dialog box, much like a page in a property sheet. This style allows the user to tab among the control windows of a child dialog box, use its accelerator keys, and so on.
  sym := RSLAddSymGlobal(V_INTEGER, 'DS_FIXEDSYS');
  RSLSymGlobalSet(sym, DS_FIXEDSYS);     //	Use SYSTEM_FIXED_FONT instead of SYSTEM_FONT.
  sym := RSLAddSymGlobal(V_INTEGER, 'DS_LOCALEDIT');
  RSLSymGlobalSet(sym, DS_LOCALEDIT);     //	Applies to 16-bit applications only. This style directs edit controls in the dialog box to allocate memory from the application's data segment. Otherwise, edit controls allocate storage from a global memory object.
  sym := RSLAddSymGlobal(V_INTEGER, 'DS_MODALFRAME');
  RSLSymGlobalSet(sym, DS_MODALFRAME);     //	Creates a dialog box with a modal dialog-box frame that can be combined with a title bar and window menu by specifying the WS_CAPTION and WS_SYSMENU styles.
  sym := RSLAddSymGlobal(V_INTEGER, 'DS_NOFAILCREATE');
  RSLSymGlobalSet(sym, DS_NOFAILCREATE);     //	Creates the dialog box even if errors occur ѕ for example, if a child window cannot be created or if the system cannot create a special data segment for an edit control.
  sym := RSLAddSymGlobal(V_INTEGER, 'DS_NOIDLEMSG');
  RSLSymGlobalSet(sym, DS_NOIDLEMSG);     //	Suppresses WM_ENTERIDLE messages that Windows would otherwise send to the owner of the dialog box while the dialog box is displayed.
//  sym := RSLAddSymGlobal(V_INTEGER, 'DS_RECURSE');
//  RSLSymGlobalSet(sym, DS_RECURSE);     	Dialog box style for control-like dialog boxes.
  sym := RSLAddSymGlobal(V_INTEGER, 'DS_SETFONT');
  RSLSymGlobalSet(sym, DS_SETFONT);     //	Indicates that the dialog box template (the DLGTEMPLATE structure) contains two additional members specifying a font name and point size. The corresponding font is used to display text within the dialog box client area and within the dialog box controls. Windows passes the handle of the font to the dialog box and to each control by sending them the WM_SETFONT message.
  sym := RSLAddSymGlobal(V_INTEGER, 'DS_SETFOREGROUND');
  RSLSymGlobalSet(sym, DS_SETFOREGROUND);     //	Does not apply to 16-bit versions of Microsoft Windows. This style brings the dialog box to the foreground. Internally, Windows calls the SetForegroundWindow function for the dialog box.
  sym := RSLAddSymGlobal(V_INTEGER, 'DS_SYSMODAL');
  RSLSymGlobalSet(sym, DS_SYSMODAL);     //	Creates a system-modal dialog box. This style causes the dialog box to have the WS_EX_TOPMOST style, but otherwise has no effect on the dialog box or the behavior of other windows in the system when the dialog box is displayed.
///////////////////////////////////////////////////////////////////////////
//  Show constants
///////////////////////////////////////////////////////////////////////////
  sym := RSLAddSymGlobal(V_INTEGER, 'SW_HIDE');
  RSLSymGlobalSet(sym, SW_HIDE);           //Hides the window and activates another window.
  sym := RSLAddSymGlobal(V_INTEGER, 'SW_MAXIMIZE');
  RSLSymGlobalSet(sym, SW_MAXIMIZE);       //Maximizes the specified window.
  sym := RSLAddSymGlobal(V_INTEGER, 'SW_MINIMIZE');
  RSLSymGlobalSet(sym, SW_MINIMIZE);       //Minimizes the specified window and activates the next top-level window in the Z order.
  sym := RSLAddSymGlobal(V_INTEGER, 'SW_RESTORE');
  RSLSymGlobalSet(sym, SW_RESTORE);        //Activates and displays the window. If the window is minimized or maximized, Windows restores it to its original size and position. An application should specify this flag when restoring a minimized window.
  sym := RSLAddSymGlobal(V_INTEGER, 'SW_SHOW');
  RSLSymGlobalSet(sym, SW_SHOW);           //Activates the window and displays it in its current size and position.
  sym := RSLAddSymGlobal(V_INTEGER, 'SW_SHOWDEFAULT');
  RSLSymGlobalSet(sym, SW_SHOWDEFAULT);    //Sets the show state based on the SW_ flag specified in the STARTUPINFO structure passed to the CreateProcess function by the program that started the application.
  sym := RSLAddSymGlobal(V_INTEGER, 'SW_SHOWMAXIMIZED');
  RSLSymGlobalSet(sym, SW_SHOWMAXIMIZED);  //Activates the window and displays it as a maximized window.
  sym := RSLAddSymGlobal(V_INTEGER, 'SW_SHOWMINIMIZED');
  RSLSymGlobalSet(sym, SW_SHOWMINIMIZED);  //Activates the window and displays it as a minimized window.
  sym := RSLAddSymGlobal(V_INTEGER, 'SW_SHOWMINNOACTIVE');
  RSLSymGlobalSet(sym, SW_SHOWMINNOACTIVE);//Displays the window as a minimized window. The active window remains active.
  sym := RSLAddSymGlobal(V_INTEGER, 'SW_SHOWNA');
  RSLSymGlobalSet(sym, SW_SHOWNA);         //Displays the window in its current state. The active window remains active.
  sym := RSLAddSymGlobal(V_INTEGER, 'SW_SHOWNOACTIVATE');
  RSLSymGlobalSet(sym, SW_SHOWNOACTIVATE); //Displays a window in its most recent size and position. The active window remains active.
  sym := RSLAddSymGlobal(V_INTEGER, 'SW_SHOWNORMAL');
  RSLSymGlobalSet(sym, SW_SHOWNORMAL);     //Activates and displays a window. If the window is minimized or maximized, Windows restores it to its original size and position. An application should specify this flag when displaying the window for the first time.
///////////////////////////////////////////////////////////////////////////
// Константы-флаги для MsgBox
///////////////////////////////////////////////////////////////////////////
  //типы кнопок
  sym := RSLAddSymGlobal(V_INTEGER, 'MB_ABORTRETRYIGNORE');          
  RSLSymGlobalSet(sym, MB_ABORTRETRYIGNORE);     //	The message box contains three push buttons: Abort, Retry, and Ignore.
  sym := RSLAddSymGlobal(V_INTEGER, 'MB_OK');          
  RSLSymGlobalSet(sym, MB_OK);     //	The message box contains one push button: OK. This is the default.
  sym := RSLAddSymGlobal(V_INTEGER, 'MB_OKCANCEL');          
  RSLSymGlobalSet(sym, MB_OKCANCEL);     //	The message box contains two push buttons: OK and Cancel.
  sym := RSLAddSymGlobal(V_INTEGER, 'MB_RETRYCANCEL');          
  RSLSymGlobalSet(sym, MB_RETRYCANCEL);     //	The message box contains two push buttons: Retry and Cancel.
  sym := RSLAddSymGlobal(V_INTEGER, 'MB_YESNO');          
  RSLSymGlobalSet(sym, MB_YESNO);     //	The message box contains two push buttons: Yes and No.
  sym := RSLAddSymGlobal(V_INTEGER, 'MB_YESNOCANCEL');          
  RSLSymGlobalSet(sym, MB_YESNOCANCEL);     //	The message box contains three push buttons: Yes, No, and Cancel.
  //типы иконок
  sym := RSLAddSymGlobal(V_INTEGER, 'MB_ICONEXCLAMATION');          
  RSLSymGlobalSet(sym, MB_ICONEXCLAMATION);     //, 
  sym := RSLAddSymGlobal(V_INTEGER, 'MB_ICONWARNING');          
  RSLSymGlobalSet(sym, MB_ICONWARNING);     //	An exclamation-point icon appears in the message box.
  sym := RSLAddSymGlobal(V_INTEGER, 'MB_ICONINFORMATION');
  RSLSymGlobalSet(sym, MB_ICONINFORMATION);     //, 
  sym := RSLAddSymGlobal(V_INTEGER, 'MB_ICONASTERISK');          
  RSLSymGlobalSet(sym, MB_ICONASTERISK);     //	An icon consisting of a lowercase letter i in a circle appears in the message box.
  sym := RSLAddSymGlobal(V_INTEGER, 'MB_ICONQUESTION');
  RSLSymGlobalSet(sym, MB_ICONQUESTION);     //	A question-mark icon appears in the message box.
  sym := RSLAddSymGlobal(V_INTEGER, 'MB_ICONSTOP');
  RSLSymGlobalSet(sym, MB_ICONSTOP);     //, 
  sym := RSLAddSymGlobal(V_INTEGER, 'MB_ICONERROR');
  RSLSymGlobalSet(sym, MB_ICONERROR);     //б 
  sym := RSLAddSymGlobal(V_INTEGER, 'MB_ICONHAND');
  RSLSymGlobalSet(sym, MB_ICONHAND);     //	A stop-sign icon appears in the message box.
  //возвращаемое значение
  sym := RSLAddSymGlobal(V_INTEGER, 'IDABORT');
  RSLSymGlobalSet(sym, IDABORT);     //	Abort button was selected.
  sym := RSLAddSymGlobal(V_INTEGER, 'IDCANCEL');
  RSLSymGlobalSet(sym, IDCANCEL);     //	Cancel button was selected.
  sym := RSLAddSymGlobal(V_INTEGER, 'IDIGNORE');
  RSLSymGlobalSet(sym, IDIGNORE);     //	Ignore button was selected.
  sym := RSLAddSymGlobal(V_INTEGER, 'IDNO');
  RSLSymGlobalSet(sym, IDNO);     //	No button was selected.
  sym := RSLAddSymGlobal(V_INTEGER, 'IDOK');
  RSLSymGlobalSet(sym, IDOK);     //	OK button was selected.
  sym := RSLAddSymGlobal(V_INTEGER, 'IDRETRY');
  RSLSymGlobalSet(sym, IDRETRY);     //	Retry button was selected.
  sym := RSLAddSymGlobal(V_INTEGER, 'IDYES');
  RSLSymGlobalSet(sym, IDYES);     //	Yes button was selected.
///////////////////////////////////////////////////////////////////////////
// Добавление объектов
///////////////////////////////////////////////////////////////////////////
  RslAddUniClass(PWinObjTable, TRUE); 
  RSLAddStdProc(V_INTEGER, 'MessageBox', @RSLMessageBox, 0);
End;
////////////////////////////////////////////////////////////////
//Точка входа в бибилиотеку
////////////////////////////////////////////////////////////////
Procedure DLLEntryPoint(Reason: DWORD);
Begin
  Case Reason of
    Dll_Process_Attach:; //Подключение процесса
    Dll_Thread_Attach:; //Подключение потока
    Dll_Thread_Detach:; //Отключение потока
    Dll_Process_Detach:; //Отключение процесса
  End; // case
End;

Exports
InitExec,
DoneExec,
RslAttach,
AddModuleObjects;

Begin
  If (Not Assigned(DllProc)) then begin
    DllProc := @DLLEntryPoint;
    DllEntryPoint(Dll_Process_Attach);
  End;
End.
