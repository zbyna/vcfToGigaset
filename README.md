# Phone  Book for  Gigaset 610,620H 

This program was created due to simple reason. After we had purchased the home VOIP phone
GIGASET 610 IP, I found out that the official application of the manufacturer for work with a phone book
of each headset just does not support our model 610 IP.

The program allows you:
- editing the phone book of any handset of the base according to the user's selection
- unlimited phone book edit history (undo, redo)
- export and import data in a format readable for Android phones
- import and export of phone book in vcf format,

![](https://i.imgur.com/E1LWBWk.png)

The Program was created in [Free Pascal](http://www.freepascal.org/) with help of development environment [CodeTyphon](http://www.pilotlogic.com/sitejoom/),
which is based on the excellent [Lazarus IDE](www.lazarus-ide.org/ ). 

Phone book is represented by a table in the [Firebird](http://www.firebirdsql.org/) relational database.

Access to the Web interface of phone uses Chromium Embedded Framework for Free Pascal created by dliw [fpCEF3](https://github.com/dliw/fpCEF3).

![](https://i.imgur.com/NZtzRiQ.png)

If you want to try to compile this program you will need CEF libraries + subprocess.exe extracted to the main directory.
http://uloz.to/xYej2VBz/cef-3-2454-1342-win32-subprocess-rar

Program was tested in win7 64bit. with FreePascal  3.1.1  SVN Rev 54621 32bit and  CodeTyphon 6.1

![](https://i.imgur.com/Jn5sXAs.png)
