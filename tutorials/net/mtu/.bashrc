source /bp/common.sh

SCENARIO="error"
if [ -f /bp/.scenario ]; then
    SCENARIO=$(< /bp/.scenario)
fi

NS=""
_NS="$(ip netns identify $$)"
if [ "${_NS}" != "" ]; then
	NS="#${_NS}"
fi

if tput setaf 1 >/dev/null 2>&1; then
    PS1="\[\e[36m\]bp\[\e[33m\](${SCENARIO}${NS})\[\e[0m\]"
else
    PS1="bp(${SCENARIO}${NS})"
fi

PS1="${PS1}\$ "

# Ask before removing files
alias rm='rm -i'

alias _exec='exec'
alias help="/bp/help.sh"
alias describe="/bp/describe.sh"

exec(){
	if [ -z "${1:-}" ] || [ -z "${2:-}" ] ; then
		echo "Usage: exec <namespace_name> <command>"
		return 1
	fi
	NS=${1}
	shift
	_check_ns "${NS}"
	ip netns exec ${NS} ${@}
}

export IGNOREEOF=3
exit(){
	if [ "${NS}" != "" ]; then
		builtin exit;
	fi

	echo "Exiting will destroy the container and its namespaces."
	read -p "Are you sure you want to exit? [y/N] " answer
	case "$answer" in
		[Yy]* ) builtin exit;;
		* ) echo "Exit cancelled.";;
	esac
}

shell(){
	if [ -z "${1:-}" ]; then
		echo "Usage: shell <namespace_name>"
		return 1
	fi
	_check_ns "${1}"

	ip netns exec ${1} bash --rcfile /bp/.bashrc -i
}

_shell_completion(){
	local cur
	cur="${COMP_WORDS[COMP_CWORD]}"
	local namespaces=($(ip netns list | awk '{print $1}'))
	COMPREPLY=( $(compgen -W "${namespaces[*]}" -- "$cur") )
}
complete -F _shell_completion shell
