---
title: 如何在 macOS High Sierra 上安装 GDB
excerpt: "To make this process less painful ..."
categories: programming
tags: c
---

## System Requirement

This process is only tested on macOS High Sierra version 10.13.6. Other OS versions *may* work, but not guarranteed.

## Before you start

Ask yourself: Do you **really** need GDB on macOS? It's less painful to install and also to use [LLDB](https://lldb.llvm.org/) on macOS. If your answer is a firm YES, let's continue.

## GDB

1. If your system has any broken version of GDB running, uninstall them. The sample code provided is to uninstall GDB using `brew`.

    ```bash
    brew uninstall --force gdb
    ```

2. Test whether GDB is successfully uninstalled.

    ```bash
    $ gdb
    -bash: gdb: command not found
    ```

3. Open Keychain Access
4. In menu, open Keychain Access > Certificate Assistant > Create a certificate...
5. Enter the information below: 

    ```bash
    Name: gdbc
    Identity type: Self Signed Root
    Check: let me override defaults
    ```

6. Continue to completion
7. In the left-hand panel, click **login**
8. Right click on `gdbc` and export this local certificate
9. Delete this certificate
10. In the left-hand panel, click system
11. Click on the little `+` sign at the bottom 
12. Choose the certificate that you just exported
13. After you successfully import the certificate, double click on `gdbc`
14. Unfold `Trust` tab
15. Choose `Always Trust` for `Code Signing` item
16. Open a new terminal
17. Install GDB v8.0.1 (This is the version that's compatible with High Sierra)

    ```bash
    brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/9ec9fb27a33698fc7636afce5c1c16787e9ce3f3/Formula/gdb.rb
    ```

18. Avoid upgrading GDB

    ```bash
    brew pin gdb
    ```

19. Codesign GDB using your self-signed certificate:

    ```bash
    codesign -fs gdbc /usr/local/bin/gdb
    ```

20. Restart your mac and hold down command-R until apple logo appears. (OS will boot into recovery mode)
21. Open terminal window (in Utilities tab)
22. Type in `csrutil enable --without debug`, ignore error messages.
23. Type in `reboot`
24. You are good to go. Have fun with `gdb` on macOS!

## Little Demo

```bash
Last login: Sat Feb 16 17:46:58 on ttys001
jackni@Chenjies-MacBook-Pro ~ $ cd Desktop/
jackni@Chenjies-MacBook-Pro Desktop $ gdb ./a.out
GNU gdb (GDB) 8.0.1
Copyright (C) 2017 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "x86_64-apple-darwin17.0.0".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
<http://www.gnu.org/software/gdb/documentation/>.
For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from ./a.out...Reading symbols from /Users/jackni/Desktop/a.out.dSYM/Contents/Resources/DWARF/a.out...done.
done.
(gdb) b main
Breakpoint 1 at 0x100000f6d: file test.c, line 5.
(gdb) r
Starting program: /Users/jackni/Desktop/a.out
[New Thread 0x2803 of process 4041]
warning: unhandled dyld version (15)

Thread 2 hit Breakpoint 1, main (argc=1, argv=0x7ffeefbff898) at test.c:5
5		int i = 10;
(gdb) n
8			printf("hello\n");
(gdb) p i
$1 = 10
(gdb) q
A debugging session is active.

	Inferior 1 [process 4041] will be killed.

Quit anyway? (y or n) y
```