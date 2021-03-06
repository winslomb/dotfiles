autoload zmv
autoload -U colors &&  colors

eval $( dircolors -b $HOME/.ls_colors/LS_COLORS )

export PYTHONSTARTUP="$HOME/.pythonrc"

export MANPAGER="vimmanpager"

export GDFONTPATH=/usr/share/fonts/ttf-bitstream-vera

export SDL_AUDIODRIVER=alsa

#{{{ PATH

# add user scripts to path
PATH="${HOME}/.scripts:${PATH}:"

# add user binaries to path
PATH="${HOME}/.bin:${PATH}:"

# add sbin to PATH so sudo can tab complete it
PATH="${PATH}:/sbin:/usr/sbin:"

PATH="${HOME}/eagle-5.10.0/bin:${PATH}:"

# altera
PATH="/opt/altera/quartus/bin:${PATH}:"
PATH="/media/other/opt/altera/nios2eds/bin/gnu/H-i686-pc-linux-gnu/bin:${PATH}:"
PATH="/media/other/opt/altera/nios2eds/sdk2/bin/:${PATH}:"
PATH="/media/other/opt/altera/nios2eds/bin/:${PATH}:"
PATH="/media/other/opt/altera/nios2eds/:${PATH}:"

#}}}

#{{{ Tab completion

autoload -Uz compinit && compinit

# color partial completions
zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)(?)*==34=0}:${(s.:.)LS_COLORS}")';

# tab complete known hosts
hosts=(`sed 's/\[\|\]\| .*//g;s/,/\n/g;s/:.*$//g' ~/.ssh/known_hosts | sort | uniq | tr '\n' ' '`)
zstyle ':completion:*:hosts' hosts $hosts

# case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# kill tab completion
zstyle ':completion:*:processes-names' command 'ps -e -o comm='
zstyle ':completion:*:processes' command 'ps -au$USER'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;32'

# completion options
setopt COMPLETE_IN_WORD

#}}}

#{{{ Aliases

alias ssh_server='ssh pwner@192.168.1.222'
alias ssh_router='ssh admin@router'
alias ssh_ucfilespace='ssh winslomb@ucfilespace.uc.edu'
alias ssh_uceng='ssh winslomb@virtulab.ceas1.uc.edu '
alias ssh_tv='ssh media@durknation.gotdns.com -p337'
alias server='192.168.1.222'
alias media='192.168.1.122'

alias matlab='wmname LG3D && /usr/local/MATLAB/R2010b/bin/matlab'
alias eye3d='eyeD3 --fs-encoding=utf8 --rename="%A - %t" ./*'

#alias scpp='scp $1 pwner@192.168.1.222:/mnt/drive_1/torrents/watch/'
function scpp () { 
	scp $1 pwner@192.168.1.222:/mnt/drive_1/uploads/ 
}

alias mount_server='sshfs -o reconnect -o follow_symlinks pwner@192.168.1.222:/ ~/Desktop/mnt/server && sshfs -o reconnect -o follow_symlinks pwner@192.168.1.222:/mnt/drive_1/music/ /media/rosewill/music/server_music/'

#alias mount_server='sshfs -p69 -o reconnect -o follow_symlinks pwner@durknation.gotdns.com:/ ~/Desktop/mnt/server/'
alias mount_school='sshfs -o reconnect -o follow_symlinks winslomb@virtulab.ceas1.uc.edu:/ ~/Desktop/mnt/school'

alias matt="terminator -x alsamixer & terminator -x ncmpcpp & terminator -x htop &"

alias ls='ls --group-directories-first --color=auto -X -h --classify'
alias ll='ls -l'
alias lla='ll -a'
alias rrsync='rsync -avz --stats --progress'
alias grep='grep --color'
alias egrep='egrep --color'
alias df='df -h'
alias watch='watch -n1 -d --color'
alias lsdir='for dir in *;do;if [ -d $dir ];then;du -hsL $dir 2>/dev/null;fi;done'
alias locate='locate -i'

alias lower='tr "[:upper:]" "[:lower:]"'
alias upper='tr "[:lower:]" "[:upper:]"'

alias back='popd'

alias nowrap='cut -c -$COLUMNS'

#}}}

#{{{ Options

# don't cycle through completions
setopt BASH_AUTO_LIST
setopt NO_AUTO_MENU

# cd=pushd
setopt AUTO_PUSHD
setopt PUSHD_SILENT

# regex like globbing: cp ^*.(tar|bz2|gz)
setopt EXTENDED_GLOB

# don't beep
setopt NO_BEEP

# emacs keybindings
setopt EMACS

# disable ctrl-s (breaks rtorrent)
setopt NO_FLOW_CONTROL

# = is needed for emerge
unsetopt EQUALS

# case insensitive globbing
setopt NO_CASE_GLOB

#}}}

#{{{ Key bindings

# home / end keys
bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line

bindkey '' vi-forward-word
bindkey '' vi-backward-word
bindkey '' vi-backward-char
bindkey '' vi-forward-char

# control+j is hard mapped to line feed?
#bindkey ' ' down-history
bindkey '' up-history

#}}}

#{{{ History

HISTFILE=~/.history

SAVEHIST=500000
HISTSIZE=500000

# write after each command
setopt INC_APPEND_HISTORY

# share history between multiple shells
setopt SHARE_HISTORY

setopt HIST_IGNORE_DUPS

# remove superfluous blanks
setopt HIST_REDUCE_BLANKS

# don't store if command begins with a space
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE

# don't execute a history expansion, just show it
setopt HIST_VERIFY

h() { if [ -z "$*" ]; then history 1; else history 1 | egrep "$@"; fi; }

#}}}

#{{{ VCS info in PS1

# http://briancarper.net/blog/570/git-info-in-your-zsh-prompt

# execute commands in PS1
setopt PROMPT_SUBST

autoload -Uz vcs_info

zstyle ':vcs_info:*' stagedstr ' +'
zstyle ':vcs_info:*' unstagedstr ' *'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{11}%r'
zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' formats '%F{yellow}(%b%c%u%F{yellow}) '

#}}}

#{{{ Terminal title

function title_job() {
    if [[ $TERM == 'screen'* ]]; then
        print -Pn "\ek${1//\\/\\\\}\e\\"
    else
        print -Pn "\e]0;${1//\\/\\\\}\a"
    fi
}


function title_path() {
    if [[ $TERM == 'screen'* ]]; then
        print -Pn "\ek%~\e\\"
    else
        print -Pn "\e]0;%n@%m: %~\a"
    fi
}

# set the intial title
title_path

#}}}

precmd() { vcs_info; title_path; }

preexec() { title_job $1; }

PROMPT='%B%(!.%F{red}.%F{green})%n@%m %B%F{blue}%~ ${vcs_info_msg_0_}%F{blue}%# %b%f%k'
