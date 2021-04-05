if exists("b:current_syntax")
	finish
endif

syntax keyword interfaceOptions metric pointopoint media hwaddress ether mtu hostname
syntax keyword interfaceOptions leasehours leasetime vendor client bootfile server hwaddr provider frame netnum endpoint local ttl network
syntax keyword interfaceKeyword mapping script  down post-down map

syntax keyword sourceKeyword source contained

"setting shared variables


let essid = '(("[[:alnum:] \._-]+")|[[:alnum:] \._-]+)'

let inetName1 = '((en|wl)[ospx][0-9a-z]+)([:.]\d{1,4})*'
let inetName2 = '((wlan|eth|vlan|br|bond|tap|tun|virbr|vrrp)\d+)([:.]\d{1,4})*'
let inetName3= 'lo'
"let ip = '(([0-9]{1,3}\.){3}[0-9]{1,3}(\/[0-9]{1,3})?) | (([0-9]{1,3}\.){3}[0-9]{1,3}(\/[0-9]{1,3})?\/\d{2})'
let ip = '([0-9]{1,3}\.){3}[0-9]{1,3}(\/[0-9]{1,2})?'

let netmask1 = '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'
let netmask2 = '\d{2}'

let mac  = '([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}'

"source path
syntax match source '\v^\s*source\s+\p+\s*$' contains=sourceKeyword

"Comment
syn keyword	todo		TODO XXX contained
syntax match interfaceComment "\v^[[:space:]]*#.*$" contains=todo


"interface Mode
syntax keyword interfaceMode static dhcp loopback manual

" netmask
exe 'syntax match interfaceNetmask /\v' . netmask1 . '/ contained'
exe 'syntax match interfaceNetmask /\v' . netmask2 . '/ contained'

"ipv4
exe 'syntax match interfaceIp /\v' . ip .  '/ contained'

"mac

exe 'syntax match macSyntax /\v' . mac .  '/ '

" Interface Names
exe 'syntax match interfaceNames /\v' . inetName1 .'/ contained'
exe 'syntax match interfaceNames /\v' . inetName2 .'/ contained'
exe 'syntax match interfaceNames /\v' . inetName3 .'/ contained'
exe 'syntax match interfaceNamesNotLo /\v' . inetName1 .'/ contained'
exe 'syntax match interfaceNamesNotLo /\v' . inetName2 .'/ contained'


"auto line
exe 'syntax match autoLine /' . '\v^\s*(auto|allow-hotplug)(\s+' . inetName1 . '|\s+' . inetName2 . ')+\s*$/ contains=interfaceNamesNotLo'
exe 'syntax match autoLine /' . '\v^\s*(auto)(\s+' . inetName1 . '|\s+' . inetName2 . '|\s+' . inetName3 .  ')+\s*$/ contains=interfaceNames'


" Interface settings
exe 'syntax match interfaceSetLine /' . '\v^\s*(iface)\s+' . inetName1  . '\s+inet\s+(static|dhcp|loopback|manual)\s*$' .  '/ contains=interfaceMode,interfaceNames'
exe 'syntax match interfaceSetLine /' . '\v^\s*(iface)\s+' . inetName2  . '\s+inet\s+(static|dhcp|loopback|manual)\s*$' .  '/ contains=interfaceMode,interfaceNames'
exe 'syntax match interfaceSetLine /' . '\v^\s*(iface)\s+' . inetName3  . '\s+inet\s+(static|dhcp|loopback)\s*$' .  '/ contains=interfaceMode,interfaceNames'



let afterkey = '(systemctl|ifconfig|ip|route|add|del|-net|-host|default|netmask|gw|via|dev|modprobe|rule|from|table|\s)'
exe 'syntax match afterKey /\v' . afterkey .'/ contained'
exe 'syntax match upSyntax /' . '\v^\s*(post-up|pre-up|up|down)\s+(' . afterkey . '|'  . ip . ')+' . '\s*$' .  '/ contains=interfaceIp,afterKey'


" set address of host and gateway
exe 'syntax match address_line /' .  '\v^\s*(address|gateway|broadcast)\s+' . ip  . '\s*$' . '/ contains=interfaceIp'

" set netmask

exe 'syntax match netmask_line /' .  '\v^\s*(netmask)\s+' . netmask1  . '\s*$' . '/ contains=interfaceNetmask'
exe 'syntax match netmask_line /' .  '\v^\s*(netmask)\s+' . netmask2  . '\s*$' . '/ contains=interfaceNetmask'

" wireless settings
let mode = '(ad-hoc|managed)'
let wkey = '(off|on)'
let passwd = '\p+'

syntax match wirelessKeyword  '\v(wpa-psk|wpa-conf|wireless-key|wireless-essid|wireless-channel|wireless-mode|wpa-ssid)' contained
exe 'syntax match wireless_essid /' .  '\v^\s*(wireless-essid)\s+' . essid  . '\s*$' . '/ contains=wirelessKeyword'
exe 'syntax match wireless_channel  /' .  '\v^\s*(wireless-channel)\s+\d{1,2}\s*$' . '/ contains=wirelessKeyword'
exe 'syntax match wireless_mode /' .  '\v^\s*(wireless-mode)\s+' . mode  . '\s*$' . '/ contains=wirelessKeyword'
exe 'syntax match wpa_essid /' .  '\v^\s*(wpa-ssid)\s+' . essid  . '\s*$' . '/ contains=wirelessKeyword'
exe 'syntax match wpa_psk /' .  '\v^\s*(wpa-psk)\s+' . passwd  . '\s*$' . '/ contains=wirelessKeyword'
exe 'syntax match wpa_conf /' .  '\v^\s*(wpa-conf)\s+' . '\p+'  . '\s*$' . '/ contains=wirelessKeyword'
exe 'syntax match wireless_key /' .  '\v^\s*(wireless-key)\s+' . passwd  . '\s*$' . '/ contains=wirelessKeyword'
exe 'syntax match wireless_key_off /' .  '\v^\s*(wireless-key)\s+' . wkey  . '\s*$' . '/ contains=wirelessKeyword'





"link to colors

hi link interfaceComment cblue
hi link interfaceMode ccyan
hi link interfaceNetmask cmagenta
hi link interfaceIP cmagenta
hi link macSyntax cmagenta
hi link interfaceNames cred
hi link interfaceNamesNotLo cred
hi link interfaceOptions cwhite
hi link wirelessKeyword cwhite
hi link sourceKeyword cwhite
hi link afterKey cgreen


hi link source cyellow
hi link wireless_essid cyellow
hi link wireless_channel cmagenta
hi link wireless_mode cwhite
hi link wireless_key_off cwhite
hi link wireless_key cgray
hi link wpa_psk cgray
hi link wpa_essid cyellow
hi link wpa_conf cyellow

hi link autoLine cwhite
hi link interfaceSetLine cwhite
hi link address_line cwhite
hi link netmask_line cwhite
hi link interfaceKeyword cgreen
hi link upSyntax cwhite


"define colors
highlight cred ctermfg=Red
highlight cblue ctermfg=Blue
highlight ccyan ctermfg=Cyan
highlight cmagenta ctermfg=Magenta
highlight cgreen ctermfg=Green
highlight cwhite ctermfg=White
highlight cyellow ctermfg=Yellow
highlight cgray ctermfg=DarkGray


let b:current_syntax = "interface"
