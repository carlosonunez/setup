# ==================================================================
# Most of this was taken from the example .bash_profile on tldp.org.
# ==================================================================
# =================
# COLORS
# =================

# Enable terminal color support.
export TERM="xterm-color"
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

get_os_type() {
  case "$(uname)" in
    "Darwin")
      echo "Darwin"
      ;;
    "Linux")
      echo "$(lsb_release -is)"
      ;;
    *)
      echo "Unsupported"
      ;;
  esac
}

install_application() {
  if [ $# -eq 0 ]
  then
    printf "${BRed}ERROR${NC}: install_application requires some arguments.\n"
    return 1
  fi
  package_manager_command_to_run=""
  os_type=$(get_os_type)
  echo "OS Type: $os_type"
  case $os_type in
    "Darwin")
      package_manager_command_to_run="brew install"
      ;;
    "Ubuntu"|"Debian")
      package_manager_command_to_run="sudo apt-get -y install"
      ;;
    "Red Hat"|"Fedora")
      package_manager_command_to_run="sudo yum -y install"
      ;;
    "SuSE")
      package_manager_command_to_run="sudo zypper install"
      ;;
    *)
      printf "${BRed}ERROR${NC}: OS [$os_type] is unsupported\n"
      return 1
      ;;
  esac
  eval "$package_manager_command_to_run $@"
}

# ===========================================================================
# Start up tmux before doing anything else.
# We will only load our profile within a TMUX pane to save on loading time.
# ===========================================================================
alias tmux='tmux -u'
if [ "$TMUX_PANE" == "" ]
then
  if [ "$(which tmux)" == "" ]
  then
    case "$(get_os_type)" in
      "Darwin")
        brew install tmux
        ;;
      "Ubuntu"|"Debian")
        sudo apt-get update -yqqu
        sudo add-apt-repository -yu ppa:pi-rho/dev
        sudo apt-get update -yqqu
        sudo apt-get install -yqqu python-software-properties software-properties-common
        sudo apt-get install -yqq tmux-next=2.3~20160913~bzr3547+20-1ubuntu1~ppa0~ubuntu16.04.1
        alias tmux=tmux-next
        ;;
      *)
        printf "${BYellow}WARN${NC}: No subroutine written for OS $(get_os_type). \
Assuming package name of 'tmux'.\n"
        install_application "tmux"
    esac
  fi
  tmux ls 2>&1 > /dev/null && {
  tmux attach -t 0
  } || {
    tmux
  }
# ============================================
# Load .bash_profile once within a tmux pane
# ============================================
else
  # Normal Colors
  Black='\033[0;30m'        # Black
  Red='\033[0;31m'          # Red
  Green='\033[0;32m'        # Green
  Yellow='\033[0;33m'       # Yellow
  Blue='\033[0;34m'         # Blue
  Purple='\033[0;35m'       # Purple
  Cyan='\033[0;36m'         # Cyan
  White='\033[0;37m'        # White

  # Bold
  BBlack='\033[1;30m'       # Black
  BRed='\033[1;31m'         # Red
  BGreen='\033[1;32m'       # Green
  BYellow='\033[1;33m'      # Yellow
  BBlue='\033[1;34m'        # Blue
  BPurple='\033[1;35m'      # Purple
  BCyan='\033[1;36m'        # Cyan
  BWhite='\033[1;37m'       # White

  # Background
  On_Black='\033[40m'       # Black
  On_Red='\033[41m'         # Red
  On_Green='\033[42m'       # Green
  On_Yellow='\033[43m'      # Yellow
  On_Blue='\033[44m'        # Blue
  On_Purple='\033[45m'      # Purple
  On_Cyan='\033[46m'        # Cyan
  On_White='\033[47m'       # White

  NC="\033[m"               # Color Reset


  ALERT=${BWhite}${On_Red} # Bold White on red background

  # ================================
  # EXTRAS
  # ================================


  # =================
  # SET PROMPT
  # =================
  set_bash_prompt() {
    # ==========================================
    # Check if I'm root or someone else.
    # ==========================================
    my_username="carlosnunez"
    fmtd_username=$my_username

    if [ $USER != $my_username ]; then
      fmtd_username="\[$On_Purple\]\[$BWhite\]$my_username\[$NC\]"
    elif [ $EUID -eq 0 ]; then
      fmtd_username="\[$ALERT\]$my_username\[$NC\]"
    else
      fmtd_username="\[$On_Green\]\[$BBlack\]$my_username\[$NC\]"
    fi

    # ===================
    # Error code
    # ===================
    error_code_str=""
    [[ "$1" != "0" ]] && error_code_str="\[$On_Red\]\[$BWhite\]<<$1>>\[$NC\]"

    # ===================
    # Machine name
    # ===================
    hostname_fmtd="\[$On_Yellow\]\[$BBlack\]localhost\[$NC\]"
    if [ ! -z "$SSH_CLIENT" ]; then
      hostname_fmtd="\[$On_Yellow\]\[$BBlack\]$HOSTNAME\[$NC\]"
    fi
    if [ ! -d .git -o "`git branch >/dev/null 2>/dev/null; echo $?`" -ne "0" ]; then
      PS1="$error_code_str\[$BCyan\][$(date "+%Y-%m-%d %H:%M:%S")\[$NC\] $fmtd_username@$hostname_fmtd \[$BCyan\]\W]\[$NC\]\[$Yellow\]\$\[$NC\]: "
    elif [ ! -d .git -o `git status --porcelain 2>/dev/null | wc -l | tr -d ' '` -eq 0 ]; then
      PS1="$error_code_str\[$BCyan\][$(date "+%Y-%m-%d %H:%M:%S")\[$NC\] $fmtd_username@$hostname_fmtd \[$Green\]<<\$(get_git_branch)>>\[$NC\] \[$BCyan\]\W]\[$NC\]\[$Yellow\]\$\[$NC\]: "
    else
      PS1="\[$BCyan\][$(date "+%Y-%m-%d %H:%M:%S")\[$NC\] $fmtd_username@$hostname_fmtd \[$Red\]<<\$(get_git_branch)>>\[$NC\] \[$BCyan\]\W]\[$NC\] \[$Yellow\]\$\[$NC\]: "
    fi
  }

  # Normal Colors
  Black='\033[0;30m'        # Black
  Red='\033[0;31m'          # Red
  Green='\033[0;32m'        # Green
  Yellow='\033[0;33m'       # Yellow
  Blue='\033[0;34m'         # Blue
  Purple='\033[0;35m'       # Purple
  Cyan='\033[0;36m'         # Cyan
  White='\033[0;37m'        # White

  # Bold
  BBlack='\033[1;30m'       # Black
  BRed='\033[1;31m'         # Red
  BGreen='\033[1;32m'       # Green
  BYellow='\033[1;33m'      # Yellow
  BBlue='\033[1;34m'        # Blue
  BPurple='\033[1;35m'      # Purple
  BCyan='\033[1;36m'        # Cyan
  BWhite='\033[1;37m'       # White

  # Background
  On_Black='\033[40m'       # Black
  On_Red='\033[41m'         # Red
  On_Green='\033[42m'       # Green
  On_Yellow='\033[43m'      # Yellow
  On_Blue='\033[44m'        # Blue
  On_Purple='\033[45m'      # Purple
  On_Cyan='\033[46m'        # Cyan
  On_White='\033[47m'       # White

  NC="\033[m"               # Color Reset


  ALERT=${BWhite}${On_Red} # Bold White on red background

  # ================================
  # EXTRAS
  # ================================


  # =================
  # SET PROMPT
  # =================
  set_bash_prompt() {
    # ==========================================
    # Check if I'm root or someone else.
    # ==========================================
    my_username="carlosnunez"
    fmtd_username=$my_username

    if [ $USER != $my_username ]; then
      fmtd_username="\[$On_Purple\]\[$BWhite\]$my_username\[$NC\]"
    elif [ $EUID -eq 0 ]; then
      fmtd_username="\[$ALERT\]$my_username\[$NC\]"
    else
      fmtd_username="\[$On_Green\]\[$BBlack\]$my_username\[$NC\]"
    fi

    # ===================
    # Error code
    # ===================
    error_code_str=""
    [[ "$1" != "0" ]] && error_code_str="\[$On_Red\]\[$BWhite\]<<$1>>\[$NC\]"

    # ===================
    # Machine name
    # ===================
    hostname_fmtd="\[$On_Yellow\]\[$BBlack\]localhost\[$NC\]"
    if [ ! -z "$SSH_CLIENT" ]; then
      hostname_fmtd="\[$On_Yellow\]\[$BBlack\]$HOSTNAME\[$NC\]"
    fi
    if [ ! -d .git ]
    then 
      PS1="$error_code_str\[$BCyan\][$(date "+%Y-%m-%d %H:%M:%S")\[$NC\] $fmtd_username@$hostname_fmtd \[$BCyan\]\W]\[$NC\]\[$Yellow\]\$\[$NC\]: "
    else
      PS1="\[$BCyan\][$(date "+%Y-%m-%d %H:%M:%S")\[$NC\] $fmtd_username@$hostname_fmtd \[$Red\]<<\$(get_git_branch)>>\[$NC\] \[$BCyan\]\W]\[$NC\] \[$Yellow\]\$\[$NC\]: "
    fi
  }
# =================
# SET PROMPT
# =================
set_bash_prompt() {
  # ==========================================
  # Check if I'm root or someone else.
  # ==========================================
  my_username="carlosnunez"
  fmtd_username=$my_username

  if [ $USER != $my_username ]; then
    fmtd_username="\[$On_Purple\]\[$BWhite\]$my_username\[$NC\]"
  elif [ $EUID -eq 0 ]; then
    fmtd_username="\[$ALERT\]$my_username\[$NC\]"
  else
    fmtd_username="\[$On_Green\]\[$BBlack\]$my_username\[$NC\]"
  fi

  # ===================
  # Error code
  # ===================
  error_code_str=""
  [[ "$1" != "0" ]] && error_code_str="\[$On_Red\]\[$BWhite\]<<$1>>\[$NC\]"

  # ===================
  # Machine name
  # ===================
  hostname_fmtd="\[$On_Yellow\]\[$BBlack\]localhost\[$NC\]"
  if [ ! -z "$SSH_CLIENT" ]; then
    hostname_fmtd="\[$On_Yellow\]\[$BBlack\]$HOSTNAME\[$NC\]"
  fi
  if [ ! -d .git ]
  then 
    PS1="$error_code_str\[$BCyan\][$(date "+%Y-%m-%d %H:%M:%S")\[$NC\] $fmtd_username@$hostname_fmtd \[$BCyan\]\W]\[$NC\]\[$Yellow\]\$\[$NC\]: "
  else
    git_repository_status="$(git status --porcelain)"
    if [ "$(echo $git_repository_status | grep '??')" != "" ]
    then
      PS1="\[$BCyan\][$(date "+%Y-%m-%d %H:%M:%S")\[$NC\] $fmtd_username@$hostname_fmtd \[$BRed\]<<\$(get_git_branch)>>*\[$NC\] \[$BCyan\]\W]\[$NC\] \[$Yellow\]\$\[$NC\]: "
    elif [ "$git_repository_status" != "" ]
    then
      PS1="\[$BCyan\][$(date "+%Y-%m-%d %H:%M:%S")\[$NC\] $fmtd_username@$hostname_fmtd \[$Red\]<<\$(get_git_branch)>>\[$NC\] \[$BCyan\]\W]\[$NC\] \[$Yellow\]\$\[$NC\]: "
    else
      PS1="\[$BCyan\][$(date "+%Y-%m-%d %H:%M:%S")\[$NC\] $fmtd_username@$hostname_fmtd \[$Green\]<<\$(get_git_branch)>>\[$NC\] \[$BCyan\]\W]\[$NC\] \[$Yellow\]\$\[$NC\]: "
    fi
  fi
}

  # =================
  # ALIASES
  # =================
  alias killmatch='kill_all_matching_pids'
  alias clip='xclip'
  [[ "$(uname)" == "Darwin" ]] && {
    alias ls='ls -Glart --group-directories-first'
  } || {
    alias ls='ls -lar --color --group-directories-first'
  }
  [[ "$(uname)" == "Linux" ]] && {
    alias sudo='sudo -i'
  }
  alias ccat='pygmentize -g'

  # Check that homebrew is installed.
  # ==================================
  [ "$(uname)" == "Darwin" ] && {
    which brew > /dev/null || {
      echo "Installing homebrew."
      /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    }
  }

  # Load bash submodules, unless the submodule already indicated that it's been
  # fully loaded.
  # ===========================================================================
  for file in $(find $HOME -maxdepth 1 \
    -regextype posix-extended \
    -regex '.*\/.bash.*$' \
    -not -regex '.*\/.bash_(profile|custom_profile|history)$' \
    -not -regex '.*.swp$' )
  do
    printf "${BGreen}INFO${NC}: Loading ${BYellow}$file${NC}\n"
    source $file
    printf "\n"
  done

  # Load SSH keys into ssh-agent
  # ============================
  killall ssh-agent
  eval $(ssh-agent -s) > /dev/null
  grep -HR "RSA" $HOME/.ssh | cut -f1 -d: | sort -u | while read file; do
  ssh-add $file
  done


  # ============
  # emacs keybindings
  # ==============
  set -o emacs

  # ===============
  # Set default editor for Git and default git options
  # ===============
  export GIT_EDITOR=vim
  git config --global user.name "Carlos Nunez"
  git config --global user.email "dev@carlosnunez.me"

  # ===========================================
  # Display last error code, when applicable
  # ===========================================
  PROMPT_COMMAND='e=$?; set_bash_prompt $e'

  [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
fi
