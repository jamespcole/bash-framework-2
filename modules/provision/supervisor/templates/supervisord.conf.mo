; supervisor config file

[unix_http_server]
file=/var/run/{{ __params.instance-name }}.sock   ; (the path to the socket file)
chmod=0700                       ; sockef file mode (default 0700)

[supervisord]
logfile={{ __params.log-file }} ; (main log file;default $CWD/supervisord.log)
pidfile=/var/run/{{ __params.instance-name }}.pid ; (supervisord pidfile;default supervisord.pid)
childlogdir={{ __params.child-log-dir }}            ; ('AUTO' child log dir, default $TEMP)

; the below section must remain in the config file for RPC
; (supervisorctl/web interface) to work, additional interfaces may be
; added by defining them in separate rpcinterface: sections
[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

[supervisorctl]
serverurl=unix:///var/run/{{ __params.instance-name }}.sock ; use a unix:// URL  for a unix socket

; The [include] section can just contain the "files" setting.  This
; setting can list multiple files (separated by whitespace or
; newlines).  It can also contain wildcards.  The filenames are
; interpreted as relative to this file.  Included files *cannot*
; include files themselves.

[include]
files = {{ __params.configs-d-path }}
; files = /etc/supervisor/conf.d/*.conf
