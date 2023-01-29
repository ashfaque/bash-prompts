#*####################################################*#
#*######### Colored Bash Prompt for Git Bash #########*#
#*####################################################*#

# ? The various escape codes, we can use to color our prompt.
RED="\[\033[0;31m\]";              BLUE="\[\033[1;34m\]";           GREEN="\[\033[0;32m\]"
LIGHT_RED="\[\e[1;31m\]";          LIGHT_GREEN="\[\e[1;32m\]";      WHITE="\e[1;7m"
YELLOW="\[\033[1;33m\]";           PURPLE="\[\033[0;35m\]";         LIGHT_GRAY="\[\033[0;37m\]"
MEHNDI="\e[42m";                   TOMATO="\e[101m";                LIGHT_YELLOW="\e[30;103m"
PINK=$(echo -e "\e[97;45m");       LIGHT_BLUE=$(echo -e "\e[97;104m")
ORANGE=$(echo -e "\e[30;43m");     BRIGHT_RED=$(echo -e "\e[97;101m")
COLOR_NONE="\[\e[0m\]";            COLOR_NONE_2="\e[0m";            COLOR_NONE_3=$(echo -e "\e[0m")
# LIGHT_RED="\[\033[1;31m\]";      LIGHT_GREEN="\[\033[1;32m\]";    WHITE="\[\033[1;37m\]"


# ? Determine active Python virtualenv details.
function get_virtualenv() {
    if test -z "$VIRTUAL_ENV"; then    # $VIRTUAL_ENV is an environment variable.
        echo ""
    else
        echo -e ${TOMATO}[$( (basename ${VIRTUAL_ENV}))]${COLOR_NONE_2}
    fi
}


# ? If root user then red, else it will be blue.
function get_user_bg_color() {
    if [[ "${EUID}" -eq 0 ]]; then
        USER_BG_COLOR=$BRIGHT_RED
    else
        USER_BG_COLOR=$LIGHT_BLUE
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


# ? Get count of current running paused jobs.
function get_jobs_count() {
    local JOBS=$(jobs 2>/dev/null)
    local JOBS_COUNT=$(echo "$JOBS" | grep 'Stopped' | wc -l)
    if [ $JOBS_COUNT != 0 ]; then
        echo -en "${WHITE} $JOBS_COUNT ${COLOR_NONE_2}"
    else
        echo ""
    fi
}


# ? Return the prompt symbol to use, colorized based on the return value of the previous command.
function set_prompt_symbol() {
    local STATUS="$?"
    local STATUS_COLOR=""
    if [ $STATUS != 0 ]; then
        STATUS_COLOR=$LIGHT_RED
    else
        STATUS_COLOR=$LIGHT_GREEN
    fi
    # export PS1="${__PS1}${STATUS_COLOR}λ${COLOR_NONE} "    # λ
    export PS1="${__PS1}${STATUS_COLOR}\$${COLOR_NONE} "    # $
}


# ? Setting Variables and calling funcitons.
get_user_bg_color                                        # Calling the function
__PS1_BEFORE='\n'                                        # New line character
__PS1_SET_VENV='`get_virtualenv` '                       # Get Python env active-inactive status
__PS1_USER='${USER_BG_COLOR} \u '                        # Username
__PS1_LOCATION='${ORANGE} \w '                           # Working dir path
__PS1_GIT_BRANCH='${PINK}`__git_ps1`${COLOR_NONE_3}'     # Git branch name
__PS1_GIT_STATS=' `get_git_stats` '                      # Call function, get git status Add, Modify, Delete
__PS1_GIT_DIST='`get_origin_dist`'                       # Call function, get ahead or behind status
__PS1_AFTER='${COLOR_NONE_3}\n\n'                        # No color set
__PS1_JOBS='`get_jobs_count` '

__PS1="${__PS1_BEFORE}${__PS1_SET_VENV}${__PS1_USER}${__PS1_LOCATION}${__PS1_GIT_BRANCH}${__PS1_GIT_STATS}${__PS1_GIT_DIST}${__PS1_AFTER}${__PS1_JOBS}"


export GIT_PS1_SHOWDIRTYSTATE=1            # Shows a `*` beside branch name, if something modified in the git repo.
export PROMPT_COMMAND=set_prompt_symbol    # Calling function which actually exports PS1. PROMPT_COMMAND is an env variable which runs just before prompt is shown.
