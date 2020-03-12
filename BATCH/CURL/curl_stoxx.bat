@ECHO OFF
:Loop
IF "%1"=="" GOTO Continue
curl-7.28.1\curl --proxy MALAKOFFMEDERIC\TQA:C105UREZ@proxy-Google.si2m.tec:8080 --user gcompagnon@federisga.fr:masterJ2EE http://www.stoxx.com/download/data/change_files/%1 -o %1
SHIFT
GOTO Loop
:Continue

