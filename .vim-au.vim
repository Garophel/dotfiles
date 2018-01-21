"	Default
imap ,out print()<esc>T(i
imap ,err print()<esc>T(i

"	Java
autocmd! FileType java call MyJavaAUs()
function MyJavaAUs()
	imap ,out System.out.println();<esc>T(i
	imap ,err System.err.println();<esc>T(i
endfunction

"	C#
autocmd! FileType cs call MyCSAUs()
function MyCSAUs()
	imap ,out Console.WriteLine();<esc>T(i
	imap ,err Console.Error.WriteLine();<esc>T(i
endfunction

"	Python
autocmd! FileType python call MyPythonAUs()
function MyPythonAUs()
	imap ,out print()<esc>T(i
	imap ,err print(, file=sys.stderr)<esc>T(i
endfunction

"	JavaScript
autocmd! FileType javascript call MyJSAUs()
function MyJSAUs()
	imap ,out console.log();<esc>T(i
	imap ,err console.error();<esc>T(i
endfunction

"	C
autocmd! FileType c call MyCAUs()
function MyCAUs()
	imap ,out printf();<esc>T(i
	imap ,err fprintf(stderr, );<esc>F)i
endfunction

autocmd! FileType tex call MyTexAUs()
function MyTexAUs()
	imap ,ö \"{o}
	imap ,ä \"{a}
	imap ,Ö \"{O}
	imap ,Ä \"{A}
endfunction
