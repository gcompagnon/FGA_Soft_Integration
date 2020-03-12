@echo off
@rem 
@rem ------------------------------------------------------------------
@rem Company: Software- und Organisations-Service GmbH
@rem Author : Oliver Haufe <oliver.haufe@sos-berlin.com>
@rem Dated  : 2010-11-22
@rem Purpose: set environment to control Job Scheduler via command line
@rem ------------------------------------------------------------------

set INSTALL_PATH=C:\Program Files\jobscheduler\scheduler
@rem set APPDATA_PATH=C:\Documents and Settings\All Users\Application Data\jobscheduler\scheduler
@rem set APPDATA_PATH=\\vill1\prive\TQA\Personnel\JOBSCHEDULER\scheduler
set APPDATA_PATH=C:\JOBSCHEDULER\scheduler
set CONFIG_PATH=C:\FGA_SOFT_INTEGRATION\jobscheduler\scheduler
set APPLOG_PATH=C:\JOBSCHEDULER\scheduler

if not defined APPDATA_PATH set APPDATA_PATH=%INSTALL_PATH%
set SCHEDULER_HOME=%INSTALL_PATH:\=/%
set SCHEDULER_DATA=%APPDATA_PATH:\=/%
set SCHEDULER_LOG=%APPLOG_PATH:\=/%
set SCHEDULER_CONFIG=%CONFIG_PATH:\=/%
@rem set SCHEDULER_ID=scheduler
set SCHEDULER_ID=FGA_ordonnanceur
if not defined JAVA_HOME set JAVA_HOME=C:\Program Files\Java\jdk1.7.0_05

set SOS_INI=%SCHEDULER_CONFIG%/config/sos.ini
set SCHEDULER_INI=%SCHEDULER_CONFIG%/config/factory.ini
set SCHEDULER_PID="%SCHEDULER_LOG%/logs/scheduler.pid"
set SCHEDULER_CLUSTER_OPTIONS=
set SCHEDULER_PARAMS=-id="%SCHEDULER_ID%" -sos.ini="%SOS_INI%" -config="%SCHEDULER_CONFIG%/config/scheduler.xml" -ini="%SCHEDULER_INI%" -env="SCHEDULER_HOME=%SCHEDULER_HOME%" -env="SCHEDULER_DATA=%SCHEDULER_DATA%" -param="%SCHEDULER_DATA%" -cd="%SCHEDULER_DATA%" -include-path="%SCHEDULER_DATA%"
set SCHEDULER_START_PARAMS=%SCHEDULER_PARAMS% -log-dir="%SCHEDULER_LOG%/logs" -log="%SCHEDULER_LOG%/logs/scheduler.log" -pid-file=%SCHEDULER_PID%
set SCHEDULER_BIN="%INSTALL_PATH%\bin\scheduler.exe"
