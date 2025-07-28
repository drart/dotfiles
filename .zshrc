alias ls='ls -aFG'
alias du='du -kH'
alias ping='ping -c 3'
alias top='top -d -ocpu'

# http://www.commandlinefu.com/commands/view/24210/show-the-path-one-directory-per-line-part-2
# alias lss="tr : \\n <<<$PATH"

alias pyserver='python3 -m http.server --cgi 8080'

## https://www.reddit.com/r/youtubedl/comments/otjtex/ytdlp_beginner_how_to_download_mp4_instead_of/
alias yt-dlp='yt-dlp -S vcodec:mp4 -f mp4 -o "%(channel)s - %(title)s.%(ext)s"'
alias ytdl-fzf='f(){ local fmt=$(command yt-dlp --list-formats "$1" | grep -E "^[0-9]+" | grep -i mp4 | grep "video only" | fzf --height=50% --border --prompt="Select video quality: " | awk "{print \$1}"); [[ -n "$fmt" ]] && command yt-dlp -S vcodec:mp4 -f "$fmt+bestaudio" --merge-output-format mp4 -o "%(channel)s - %(title)s.%(ext)s" "$1"; }; f'

# https://apple.stackexchange.com/questions/30552/os-x-computer-name-not-matching-what-shows-on-terminal
# scutil --get ComputerName #sometimes $HOSTNAME is set to something weird...


# http://www.commandlinefu.com/commands/view/24264/get-all-documents-docdocxxlsxlsxpdfpptpptx...-linked-in-a-webpage
# curl https://www.domain.com/ | grep -Eo "(http|https)://[a-zA-Z0-9./?=_-]*.*(doc|docx|xls|xlsx|ppt|pptx|pdf)" | sort | uniq > list.txt | wget list.txt

# find network and external ip address
alias myip='ipconfig getifaddr en0'
alias extip=' curl ifconfig.me'


# Obsidian plugin rest api for interacting with neovim
export OBSIDIAN_REST_API_KEY=3fd76bd65505f75dcf484a8aa62511faeb08936148e74694b094401072cb106b

alias oo='cd  /Users/adamtindale/Library/Mobile\ Documents/iCloud~md~obsidian/Documents/Main/'
alias od='cd  /Users/adamtindale/Library/Mobile\ Documents/iCloud~md~obsidian/Documents/Main/Daily'

alias gc='git status'
alias gc='git diff'

# vi mode for zsh
bindkey -v
# fzf has to be sourced after setting vi mode to have ** work properly
source /opt/homebrew/Cellar/fzf/0.62.0/shell/key-bindings.zsh
source /opt/homebrew/Cellar/fzf/0.62.0/shell/completion.zsh
alias fzp='fzf --preview="cat {}"'

eval "$(zoxide init zsh)"
