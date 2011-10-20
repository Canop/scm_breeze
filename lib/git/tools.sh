# -------------------------------------------------------
# SCM Breeze - Streamline your SCM workflow.
# Copyright 2011 Nathan Broadbent (http://madebynathan.com). All Rights Reserved.
# Released under the LGPL (GNU Lesser General Public License)
# -------------------------------------------------------

# -----------------------------------------------------------------
# Git Tools
# - Please feel free to add your own git scripts, and send me a pull request
#   at https://github.com/ndbroadbent/scm_breeze
# -----------------------------------------------------------------


# Remove files/folders from git history
# -------------------------------------------------------------------
# To use it, cd to your repository's root and then run the function
# with a list of paths you want to delete. e.g. git_remove_history path1 path2
# Original Author: David Underhill
git_remove_history() {
  # Make sure we're at the root of a git repo
  if [ ! -d .git ]; then
      echo "Error: This script must be run from the root of a git repository"
      return
  fi
  # Remove all paths passed as arguments from the history of the repo
  files=$@
  git filter-branch --index-filter "git rm -rf --cached --ignore-unmatch $files" HEAD
  # Remove the temporary history git-filter-branch otherwise leaves behind for a long time
  rm -rf .git/refs/original/ && git reflog expire --all &&  git gc --aggressive --prune
}


# Stage a range of lines from a file
# -------------------------------------------------------------------
# If you wanted to commit lines 15 to 25 of README.markdown, you would run:
#    git_partial_add README.markdown:15-25
git_partial_add() {
  # Make sure we're at the root of a git repo
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Error: This script must be run from a git repository"
    return
  fi
  if [ -z "$1" ]; then return 1; fi



  # Expand args and process resulting set of files.
  for file in $(git_expand_args "$@"); do
    changed_file=$(mktemp -t tmp.XXXXXXXXXX)
    cp -f file $changed_file
    git checkout $file



  done
  echo "#"
}
