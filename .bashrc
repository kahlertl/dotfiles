#!/bin/bash
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

HISTSIZE=100000                   # big big history
HISTFILESIZE=100000               # big big history
shopt -s histappend               # append to history, don't overwrite it

# Save and reload the history after each command finishes
# PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# directory in which this script is located
__FILE__="$(readlink -f ${BASH_SOURCE[0]})"
__DIR__="$(dirname $__FILE__)"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color)
        color_prompt=yes
        ;;
esac

# Uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

show_virtual_env() {
  if [ -n "$VIRTUAL_ENV" ]; then
    # echo "($(basename $VIRTUAL_ENV))"
    echo "venv"
  fi
}

# Uncomment the following line to display the hostname in the
# command line prompt
#prompt_host=yes

# Escape sequences for PS1 prompt
# -------------------------------
# 
# Time 12h   \T
# Time 12a   \@
# 
# Path Short \w
# Path Full  \W
# 
# Jobs \j
# User \u
# Host \h

if [ "$color_prompt" = yes ]; then
    # Include color definitions
    . $__DIR__/colors

    # Build of Steve Losh's prompt
     
    # PS1="${debian_chroot:+($debian_chroot)}"
    # PS1+="${MonoBPink}\u "
    # PS1+="${BWhite}at "
    # PS1+="${CandyBOrange}\h "
    # PS1+="${BWhite}in "
    # PS1+="${BGreen}\w "
    # PS1+="$(__git_ps1 "${BWhite}on ${MonoBPink}%s ")"
    # PS1+="\n${BWhite}\$ $Color_Off"

    # Monokai inspired prompt theme
    PS1="${debian_chroot:+($debian_chroot)}"
    if [[ $EUID -ne 0 ]]; then
        PS1+="${MonoBGreen}\u"
    else
        PS1+="${BRed}\u"
    fi

    if [ "$prompt_host" = yes ] || [ ! -z "$SSH_CLIENT" ]; then
        PS1+="${CandyBGray}@"
        # PS1+="${CandyBGray} at " # A more verbose alternative
        PS1+="${CandyBOrange}\h "
    else
        PS1+=" "
    fi

    # PS1+="${CandyBGray}in "
    PS1+="${BWhite}\w "
    # PS1+="$(__git_ps1 "${CandyBGray}on ${MonoBPink}%s ")"
    PS1+="${MonoBPink}\$(__git_ps1 '${CandyBGray}on ${MonoBPink}%s ')"
    PS1+="${CandyBOrange}\$(show_virtual_env)"
    PS1+="\n${BWhite}"
    if [[ $EUID -ne 0 ]]; then
      PS1+="\$"
    else
      PS1+="#"
    fi
    PS1+=" $Color_Off"
else
    # prompt without color support
    PS1="${debian_chroot:+($debian_chroot)}\u"

    # Use host only of flag is set
    if [ "$prompt_host" = yes ]; then
        PS1+="@\h "
    else
        PS1+=" "
    fi

    # Append short path and git status
    PS1+="\w \$(__git_ps1 'on %s ')\$(show_virtual_env)\n\$ "
fi

# Clear flags
unset color_prompt force_color_prompt prompt_host

# If this is an xterm set the title to user@host:dir
# case "$TERM" in
#     xterm*|rxvt*)
#         PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
#         ;;
#     *)
#         ;;
# esac


# Alias definitions.
# 
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
. $__DIR__/aliases

# List of directories that should be included to the PATH variable
# if they exist
BIN_DIRS=(
    "$HOME/bin"
    "$HOME/local/bin"
    "$HOME/.local/bin"
    "$HOME/.gem/ruby/2.3.0/bin"
)

# Set PATH so it includes user's private bin directories if they exists
for dir in ${BIN_DIRS[@]}; do
    if [ -d $dir ] ; then
        PATH="$dir:$PATH"
    fi
done

# Export the locale settings to supprt UTF-8
export LC_ALL="en_US.UTF-8"

# . $__DIR__/virtualenvwrapper
# . $__DIR__/virtualenv-auto-activate.sh

eval "$(direnv hook bash)"

# added by travis gem
[ -f /home/lucas/.travis/travis.sh ] && source /home/lucas/.travis/travis.sh
