# If you come from bash you might have to change your $PATH.
export PATH=$HOME/.npm-global/bin::$HOME/.gem/ruby/2.5.0/bin:$HOME/bin:/usr/local/bin:$PATH
export PATH="$PATH:$HOME/.rvm/bin:$HOME/.rvm/scripts/rvm"

export ANSIBLE_INVENTORY=/home/legogris/dev/kaiko/devops/ansible/ec2.py
export EC2_INI_PATH=/home/legogris/dev/kaiko/devops/ansible/ec2.ini
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/legogris/dev/google-cloud-sdk/path.zsh.inc' ]; then source '/home/legogris/dev/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/legogris/dev/google-cloud-sdk/completion.zsh.inc' ]; then source '/home/legogris/dev/google-cloud-sdk/completion.zsh.inc'; fi
