source ~/src/gdb-dashboard/.gdbinit

# My own stuff
define hookpost-up
dashboard
end

define hookpost-down
dashboard
end

alias dew='dashboard expressions watch'
alias deu='dashboard expressions unwatch'
alias dec='dashboard expressions clear'

