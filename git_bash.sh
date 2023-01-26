######################################################
########## Colored Bash Prompt for Git Bash ##########
######################################################

# The various escape codes that we can use to color our prompt.
        RED="\[\033[0;31m\]"
     YELLOW="\[\033[1;33m\]"
      GREEN="\[\033[0;32m\]"
       BLUE="\[\033[1;34m\]"
     PURPLE="\[\033[0;35m\]"
  LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
      WHITE="\[\033[1;37m\]"
 LIGHT_GRAY="\[\033[0;37m\]"
 COLOR_NONE="\[\e[0m\]"


# Return the prompt symbol to use, colorized based on the return value of the previous command.
function set_prompt_symbol () {
  if test $1 -eq 0 ; then
      PROMPT_SYMBOL="${LIGHT_GREEN}\$${COLOR_NONE}"
  else
      PROMPT_SYMBOL="${LIGHT_RED}\$${COLOR_NONE}"
  fi
}


# Determine active Python virtualenv details.
function set_virtualenv () {
  if test -z "$VIRTUAL_ENV" ; then
      PYTHON_VIRTUALENV="\[\e[97;101m\][`(basename \"$VIRTUAL_ENV\")`]${COLOR_NONE} "
  else
      PYTHON_VIRTUALENV=""
  fi
}


# Show commits in bash prompt.
function origin_dist {
 local STATUS="$(git status 2> /dev/null)"
 local DIST_STRING=""

 local IS_AHEAD=$(echo -n "$STATUS" | grep "ahead")
 local IS_BEHIND=$(echo -n "$STATUS" | grep "behind")

 if [ ! -z "$IS_AHEAD" ]; then
  local DIST_VAL=$(echo "$IS_AHEAD" | sed 's/[^0-9]*//g')
  DIST_STRING="$DIST_VAL ››"
 elif [ ! -z "$IS_BEHIND" ]; then
  local DIST_VAL=$(echo "$IS_BEHIND" | sed 's/[^0-9]*//g')
  DIST_STRING="‹‹ $DIST_VAL"
 fi

 if [ ! -z "$DIST_STRING" ]; then
  echo -en "\e[1;7m $DIST_STRING "
 fi
}

# Show Untracked, Modified & Deleted files.
git_stats() {
  local STATUS=$(git status -s 2> /dev/null)
  local ADDED=$(echo "$STATUS" | grep '??' | wc -l)
  local DELETED=$(echo "$STATUS" | grep ' D' | wc -l)
  local MODIFIED=$(echo "$STATUS" | grep ' M' | wc -l)
  local STATS=''

  if [ $ADDED != 0 ]; then
    STATS="\e[42m $ADDED "
  fi

  if [ $DELETED != 0 ]; then
    STATS="$STATS\e[101m $DELETED "
  fi

  if [ $MODIFIED != 0 ]; then
    STATS="$STATS\e[30;103m $MODIFIED "
  fi

  echo -e "\e[0m $STATS\e[0m"
}


# Setting Variables.
__PS1_BEFORE='\n'
__PS1_USER='\[\e[97;104m\] \u '
__PS1_LOCATION='\[\e[30;43m\] \w '
__PS1_GIT_BRANCH='\[\e[97;45m\] `__git_ps1` '
__PS1_GIT_STATS='`git_stats` '
__PS1_AFTER='\[\e[0m\]\n\n'
__PS1_GIT_DIST='`origin_dist`'
set_prompt_symbol $?
set_virtualenv


# export PS1="${__PS1_BEFORE}${__PS1_USER}${__PS1_LOCATION}${__PS1_GIT_BRANCH}${__PS1_GIT_STATS}${__PS1_AFTER}"
# __PS1="${__PS1_BEFORE}${__PS1_TIME}${__PS1_USER}${__PS1_LOCATION}${__PS1_GIT_BRANCH}${__PS1_GIT_STATS}${__PS1_GIT_DIST}${__PS1_AFTER}"
# ORIG_PS1="$PS1"
export PS1="${__PS1_BEFORE}${PYTHON_VIRTUALENV}${__PS1_USER}${__PS1_LOCATION}${__PS1_GIT_BRANCH}${__PS1_GIT_STATS}${__PS1_GIT_DIST}${__PS1_AFTER}${PROMPT_SYMBOL} "






# __PS_TIME?
