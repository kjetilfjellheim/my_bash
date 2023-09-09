#!/bin/fish

set -x MY_GIT_USERNAME "kjetilfjellheim"
set -x MY_GIT_NAME "Kjetil Fjellheim"
set -x MY_GIT_EMAIL "kjetil@forgottendonkey.net"
set -x MY_GIT_PATH "/home/kjetil/Code"

#Common color information
set LIGHTGRAY "\033[0;37m"
set WHITE "\033[1;37m"
set BLACK "\033[0;30m"
set DARKGRAY "\033[1;30m"
set RED "\033[0;31m"
set LIGHTRED "\033[1;31m"
set GREEN "\033[0;32m"
set LIGHTGREEN "\033[1;32m" 
set BROWN "\033[0;33m"
set YELLOW "\033[1;33m"
set BLUE "\033[0;34m"
set LIGHTBLUE "\033[1;34m"
set MAGENTA "\033[0;35m"
set LIGHTMAGENTA "\033[1;35m"
set CYAN "\033[0;36m"
set LIGHTCYAN "\033[1;36m"
set NOCOLOR "\033[0m"

# Set the prompt
set -x PS1 "\n$WHITE\u@\h $RED\w$GREEN\$(GIT_PS1_SHOWUNTRACKEDFILES=1 GIT_PS1_SHOWDIRTYSTATE=1 __git_ps1)$NOCOLOR"
set -x LS_COLORS 'no=00:fi=00:di=00;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:*.xml=00;31:'

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
   complete -a "$repos" clone
end

