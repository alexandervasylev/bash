# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[[ -z "${PS1}" ]] && return

# Don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Colors
CF_RED="\033[31m"
CB_RED="\033[41m"
CF_BLUE="\033[34m"
CB_BLUE="\033[44m"
CF_CYAN="\033[36m"
CB_CYAN="\033[46m"
CF_GRAY="\033[90m"
CB_GRAY="\033[100m"
CF_BLACK="\033[30m"
CB_BLACK="\033[40m"
CF_GREEN="\033[32m"
CB_GREEN="\033[42m"
CF_WHITE="\033[97m"
CB_WHITE="\033[107m"
ENDCOLOR="\033[0m"
CF_YELLOW="\033[33m"
CB_YELLOW="\033[44m"
CF_MAGENTA="\033[35m"
CB_MAGENTA="\033[45m"

# PS1
function get_git_branch_name() {
    local name="$(git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/' | tr -d ' ()')"

    [[ -n "${name}" ]] && echo "|git:${name}"
}

function get_kube_context() {
    local name="$(kubectl config current-context 2>/dev/null)"

    [[ -f "${HOME}/.kube/config" ]] && [[ -n ${name} ]] && echo "|k:${name}"
}

export PS1="\[${CF_GREEN}\]\w\[${ENDCOLOR}\]\[${CF_YELLOW}\]\$(get_kube_context)\[${ENDCOLOR}\]\[${CF_MAGENTA}\]\$(get_git_branch_name)\[${ENDCOLOR}\] $ "

# Extra env
export HELM_EXPERIMENTAL_OCI=1
export BASH_SILENCE_DEPRECATION_WARNING=1

# Aliases
alias kctx="kubectl config use-context"
alias tfplan="tfenv use && terraform plan -out /tmp/plan"
alias sublime="open -a \"Sublime Text\""
alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'

# Load private bashrc
[[ -f "${HOME}/.bashrc_private" ]] && source "${HOME}/.bashrc_private"

# Load environment
function lenv() {
    local env_path="${1}"

    [[ -z "${env_path}" ]] && env_path=".environment"

    if [[ -f "${env_path}" ]]; then
        source "${env_path}"
        echo "Environment from ${env_path} loaded..."
    else
        echo "No environment file here"
    fi
}

# Add key to ssh-agent
ssh-add -k

# Other
eval "$(/opt/homebrew/bin/brew shellenv)"
