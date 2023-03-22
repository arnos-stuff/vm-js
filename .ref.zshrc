skip_global_compinit=1
eval "$(oh-my-posh init zsh --config $BREWHOME/opt/oh-my-posh/themes/arno-pure-bayes.omp.json)"

if [[ ! -f $HOME/.zi/bin/zi.zsh ]]; then
  print -P "%F{33}▓▒░ %F{160}Installing (%F{33}z-shell/zi%F{160})…%f"
  command mkdir -p "$HOME/.zi" && command chmod go-rwX "$HOME/.zi"
  command git clone -q --depth=1 --branch "main" https://github.com/z-shell/zi "$HOME/.zi/bin" && \
    print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
    print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi
source "$HOME/.zi/bin/zi.zsh"
autoload -Uz _zi
(( ${+_comps} )) && _comps[zi]=_zi
# examples here -> https://wiki.zshell.dev/ecosystem/category/-annexes
zicompinit # <- https://wiki.zshell.dev/docs/guides/commands
zi light-mode for \
  jirutka/zsh-shift-select \
  olets/zsh-abbr \
  davidparsson/zsh-nvm-lazy \
  momo-lab/zsh-smartinput \
  Aloxaf/fzf-tab \
  z-shell/z-a-meta-plugins \
  @annexes # <- https://wiki.zshell.dev/ecosystem/category/-annexes
# examples here -> https://wiki.zshell.dev/community/gallery/collection
zicompinit # <- https://wiki.zshell.dev/docs/guides/commands
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

. /home/linuxbrew/.linuxbrew/etc/profile.d/z.sh

setopt histignorealldups sharehistory

setopt append_history         # Allow multiple sessions to append to one Zsh command history.
setopt extended_history       # Show timestamp in history.
setopt hist_expire_dups_first # Expire A duplicate event first when trimming history.
setopt hist_find_no_dups      # Do not display a previously found event.
setopt hist_ignore_all_dups   # Remove older duplicate entries from history.
setopt hist_ignore_dups       # Do not record an event that was just recorded again.
setopt hist_ignore_space      # Do not record an Event Starting With A Space.
setopt hist_reduce_blanks     # Remove superfluous blanks from history items.
setopt hist_save_no_dups      # Do not write a duplicate event to the history file.
setopt hist_verify            # Do not execute immediately upon history expansion.
setopt inc_append_history     # Write to the history file immediately, not when the shell exits.
setopt share_history          # Share history between different instances of the shell.
# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3>7?7:($#PREFIX+$#SUFFIX)/3))numeric)'


export NVM_DIR="$HOME/.nvm"

# ctrl+shift+arrow behavior
# bindkey "\e[1;6C" forward-word
# bindkey "\e[1;6D" backward-word
# ### ctrl+arrows
bindkey "\e[1;5C" forward-word
bindkey "\e[1;5D" backward-word
# # urxvt
bindkey "\eOc" forward-word
bindkey "\eOd" backward-word
# 
# ### ctrl+delete
bindkey "\e[3;5~" kill-word
# # urxvt
bindkey "\e[3^" kill-word
# 
### ctrl+backspace
bindkey '^H' backward-kill-word
# 
# ### ctrl+shift+delete
bindkey "\e[3;6~" kill-line
# # urxvt
bindkey "\e[3@" kill-line
