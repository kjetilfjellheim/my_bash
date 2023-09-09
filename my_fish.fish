#!/bin/fish

set -x MY_GIT_USERNAME "kjetilfjellheim"
set -x MY_GIT_NAME "Kjetil Fjellheim"
set -x MY_GIT_EMAIL "kjetil@forgottendonkey.net"
set -x MY_GIT_PATH "/home/kjetil/Code"

# Set the prompt
function fish_prompt
    set_color white
    set -l git_branch (git branch 2>/dev/null | sed -n '/\* /s///p')
    echo -n (whoami)'@'(hostname)':'
    set_color $fish_color_cwd
    echo -n (prompt_pwd --full-length-dirs=2 --dir-length=2) 
    set_color purple
    echo -n '{'
    echo -n "$git_branch"
    echo -n '}'
    set_color normal
    echo -n ' $ '
end

#Use git color ui
git config --global color.ui true

#Git dfiff highlight colors
git config --global color.diff-highlight.oldNormal    "red bold"
git config --global color.diff-highlight.oldHighlight "red bold 52"
git config --global color.diff-highlight.newNormal    "green bold"
git config --global color.diff-highlight.newHighlight "green bold 22"

#Git diff colors
git config --global color.diff.meta       "11"
git config --global color.diff.frag       "magenta bold"
git config --global color.diff.func       "146 bold"
git config --global color.diff.commit     "yellow bold"
git config --global color.diff.old        "red bold"
git config --global color.diff.new        "green bold"
git config --global color.diff.whitespace "red reverse"

#Git merge and diff tool config
git config --global core.editor "code --wait --new-window"
git config --global diff.tool vscode
git config --global difftool.vscode.cmd 'code --wait --diff $LOCAL $REMOTE'
git config --global merge.tool vscode
git config --global mergetool.vscode.cmd 'code --wait $MERGED'

#My git information
git config --global user.name "$MY_GIT_NAME"
git config --global user.email "$MY_GIT_EMAIL"
#Git commit template
git config --global commit.template $MY_GIT_PATH/my_bash/gittemplate.txt

#Git clone function 
function clone
    echo "Cloning git@github.com\:$MY_GIT_USERNAME/$argv[1].git to $MY_GIT_PATH/$argv[1]"
    cd $MY_GIT_PATH
    git clone git@github.com:$MY_GIT_USERNAME/$argv[1].git $argv[1]
    cd $argv[1]
    echo "Completed cloning"
end

#Notify using kde notification
function notify
    kdialog --passivepopup "$argv[1]" 5
end

#Update git clone repo completion
function update_repos_completion
   set token (gh auth token)
   if [ "$token" = "" ] 
       echo "Not logged in"
       gh auth login
       set token `gh auth token`       
   else
       echo "Logged in"
   end   
   set repos (curl -L -H "Accept: application/vnd.github+json" -H "Authorization: Bearer $token" -H "X-GitHub-Api-Version: 2022-11-28" "https://api.github.com/users/$MY_GIT_USERNAME/repos?per_page=100" | jq '.[] | .ssh_url' | cut -d'/' -f2 | sed 's/\.git\"//g' | tr '\n' ' ')
   echo "$repos"
   echo "complete -r -f -c \"clone\" -a \"$repos\" " > ~/.config/fish/completions/clone.fish
end

bind \t complete
