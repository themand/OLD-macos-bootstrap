source ~/.bash_prompt

alias ls="command ls -laGF"
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'
alias df="df -H"
alias du="du -h"

export PATH="$HOME/bin:$PATH";
export EDITOR='vi';
export GREP_OPTIONS='--color=auto';
