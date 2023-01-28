#*####################################################*#
#*######### Colored Bash Prompt for Git Bash #########*#
#*####################################################*#

# ? The various escape codes, we can use to color our prompt.
RED="\[\033[0;31m\]"
BRIGHT_RED="\[\e[97;101m\]"
YELLOW="\[\033[1;33m\]"
GREEN="\[\033[0;32m\]"
BLUE="\[\033[1;34m\]"
PURPLE="\[\033[0;35m\]"
LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
WHITE="\[\033[1;37m\]"
LIGHT_GRAY="\[\033[0;37m\]"
COLOR_NONE="\[\e[0m\]"

MEHNDI="\e[42m"
TOMATO="\e[101m"
LIGHT_YELLOW="\e[30;103m"
WHITE="\e[1;7m"
LIGHT_BLUE=$(echo -e "\e[97;104m")
LIGHT_ORANGE=$(echo -e "\e[30;43m")
PINK=$(echo -e "\e[97;45m")
COLOR_NONE_2="\e[0m"
COLOR_NONE_3=$(echo -e "\e[0m")

# ? Determine active Python virtualenv details.
function get_virtualenv() {
    if test -z "$VIRTUAL_ENV"; then    # $VIRTUAL_ENV is an environment variable.
        # PYTHON_VIRTUALENV=""
        echo ""
    else
        echo -e ${TOMATO}[$( (basename ${VIRTUAL_ENV}))]${COLOR_NONE_2}
        # PYTHON_VIRTUALENV=${BRIGHT_RED}[`(basename ${VIRTUAL_ENV})`]${COLOR_NONE}" "
        # PYTHON_VIRTUALENV="\[\e[97;101m\][`(basename \"$VIRTUAL_ENV\")`]${COLOR_NONE} "
    fi
}

# ? Show Untracked Deleted & Modified files.
get_git_stats() {
    local STATUS=$(git status -s 2>/dev/null)
    local ADDED=$(echo "$STATUS" | grep '??' | wc -l)
    local DELETED=$(echo "$STATUS" | grep ' D' | wc -l)
    local MODIFIED=$(echo "$STATUS" | grep ' M' | wc -l)
    local STATS=''

    if [ $ADDED != 0 ]; then
        STATS="${MEHNDI} $ADDED "
    fi

    if [ $DELETED != 0 ]; then
        STATS="$STATS${TOMATO} $DELETED "
    fi

    if [ $MODIFIED != 0 ]; then
        STATS="$STATS${LIGHT_YELLOW} $MODIFIED "
    fi

    echo -e "${COLOR_NONE_2}${STATS}${COLOR_NONE_2}"
}

# ? Show commits in bash prompt.
function get_origin_dist {
    local STATUS="$(git status 2>/dev/null)"
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
        echo -en "${WHITE} $DIST_STRING "
    fi
}

# ? Return the prompt symbol to use, colorized based on the return value of the previous command.
function set_prompt_symbol() {
    # if test $1 -eq 0 ; then
    if [ $1 = 0 ]; then
        echo -en "${LIGHT_GREEN}\$${COLOR_NONE}"
        # echo "\[\033[1;32m\]\$\[\e[0m\]"    # Green
        # PROMPT_SYMBOL="${LIGHT_GREEN}\$${COLOR_NONE}"
    else
        echo -en "${LIGHT_RED}\$${COLOR_NONE}"
        # echo "\[\033[1;31m\]\$\[\e[0m\]"    # Red
        # PROMPT_SYMBOL="${LIGHT_RED}\$${COLOR_NONE}"
    fi
}

# ? Setting Variables and calling funcitons.
__PS1_BEFORE='\n'                                        # New line character
__PS1_SET_VENV='`get_virtualenv` '                       # Get Python env active-inactive status
__PS1_USER='${LIGHT_BLUE} \u '                           # Username
__PS1_LOCATION='${LIGHT_ORANGE} \w '                     # Working dir path
__PS1_GIT_BRANCH='${PINK}`__git_ps1`${COLOR_NONE_3}'     # Git branch name
__PS1_GIT_STATS=' `get_git_stats` '                       # Call function, get git status Add, Modify, Delete
__PS1_GIT_DIST='`get_origin_dist`'                       # Call function, get ahead or behind status
__PS1_AFTER='${COLOR_NONE_3}\n\n'                        # No color set

# __PS1="${__PS1_BEFORE}${__PS1_TIME}${__PS1_USER}${__PS1_LOCATION}${__PS1_GIT_BRANCH}${__PS1_GIT_STATS}${__PS1_GIT_DIST}${__PS1_AFTER}"

export PS1="${__PS1_BEFORE}${__PS1_SET_VENV}${__PS1_USER}${__PS1_LOCATION}${__PS1_GIT_BRANCH}${__PS1_GIT_STATS}${__PS1_GIT_DIST}${__PS1_AFTER}$(set_prompt_symbol $?) "



# Test
# __PS1_SET_PROMPT='\[\033[1;$(($?==0?32:31))m\]$ ${COLOR_NONE_3}'
# export PS1="${__PS1_BEFORE}${__PS1_SET_VENV}${__PS1_USER}${__PS1_LOCATION}${__PS1_GIT_BRANCH}${__PS1_GIT_STATS}${__PS1_GIT_DIST}${__PS1_AFTER}${__PS1_SET_PROMPT} "
