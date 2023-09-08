# My bash
<h2>Description</h2>
These are my personal bash script and definitions used on my personal computers.

<h2>Use</h2>
To use just clone the project and add source ./&gt;Path to my_bash.sh&lt; in the ~/.bashrc file. Update your username in the script so that you don't try to log into my private repos.

This has the following functionality
1. Added common colors to use in the terminal.
2. Updates the terminal prompt to make it more
- &gt;Username&lt;@&gt;Hostname&lt; &gt;Path&lt; (&gt;Git information&lt;)
3. ls command colors.
4. Includes my preferred mergetool, difftool and core editor for git.
5. My username, email and and commit template
6. Clone function to simplify git clone command with repo completion.
- Command: clone &gt;repo name&lt;
7. Function to update completion information for github repos.
- Command: update_repos
The command will log into github and make a rest request to get github repos for a user.
8. Notify function to show information if running long terminal scripts.
- Comand: notify

<h2>Personalization</h2>
MY_GIT_USERNAME=&gt;Git username&lt;
MY_GIT_NAME="&gt;Git name&lt;"
MY_GIT_EMAIL="&gt;Git email&lt;"
MY_GIT_PATH="&gt;Path to where to clone&lt;"




