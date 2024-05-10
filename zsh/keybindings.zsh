# up
	function goto_parent_dir() {
		BUFFER="cd .."
		zle accept-line
	}
	zle -N goto_parent_dir
	bindkey "^k" goto_parent_dir

# git
	function git_add_commit_push() {
		if [ -n "$BUFFER" ];
			then
				BUFFER="git add -A; git commit -m \"$BUFFER\" && git push"
		fi

		if [ -z "$BUFFER" ];
			then
				BUFFER="git add -A; git commit -v && git push"
		fi
				
		zle accept-line
	}
	zle -N git_add_commit_push
	bindkey "^g" git_add_commit_push

# home
	function goto_home_dir() { 
		BUFFER="cd ~/"$BUFFER
		zle end-of-line
		zle accept-line
	}
	zle -N goto_home_dir
	bindkey "^h" goto_home_dir

# Edit and rerun
	function edit_and_run() {
		BUFFER="fc"
		zle accept-line
	}
	zle -N edit_and_run
	bindkey "^v" edit_and_run

# LS
	function ls_current_dir() {
		BUFFER="ls -lh"
		zle accept-line
	}
	zle -N ls_current_dir
	bindkey "^l" ls_current_dir

# re-claiming ctrl-s keybinding
setopt noflowcontrol

# Sudo
	function add_sudo() {
		BUFFER="sudo "$BUFFER
		zle end-of-line
	}
	zle -N add_sudo
	bindkey "^s" add_sudo
	
