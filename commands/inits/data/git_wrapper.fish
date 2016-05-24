# Remove any existing git alias or function
unalias git > /dev/null 2>&1
functions -e git > /dev/null 2>&1

# User the full path to git to avoid infinite loop with git function
set -x SCMPUFF_GIT_CMD (which git)

# Wrap git with the 'hub' github wrapper, if installed
if type hub > /dev/null 2>&1; set -x SCMPUFF_GIT_CMD "hub"; end

function git
  switch $1
  case commit blame log rebase merge
    eval "scmpuff expand --"$SCMPUFF_GIT_CMD" "$@
  case checkout diff rm reset
    eval "scmpuff expand --relative -- "$SCMPUFF_GIT_CMD" "$@
  case add
    eval "scmpuff expand -- "$SCMPUFF_GIT_CMD" "$@
    scmpuff_status
  case '*'
    eval $SCMPUFF_GIT_CMD $@
end
