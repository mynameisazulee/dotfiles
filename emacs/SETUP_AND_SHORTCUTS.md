# EMACS

## Initial Setup
1. download emacs
1. cleanup: `rm -rf ~/.emacs* ~/.spacemacs`
1. install spacemacs: `git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d`
1. select vim style, heavy with full features
1. go to dotfile: `<SPC> f e d`
1. then enable layers: (ex. org, org-agenda)
1. add zsh to shell: `shell-default-term-shell "/bin/zsh"`
1. default font size : `15`
1. dotspacemacs-auto-resume-layouts : `t`
1. dotspacemacs-line-numbers : `t`
1. dotspacemacs-whitespace-cleanup : `t`
1. update to development branch to get latest release: `cd ~/.emacs.d && git checkout develop && git pull` then reload `<SPC> f e R`
1. add `(load-library "~/dotfiles/emacs/FILE1.el") (load-library "~/dotfiles/emacs/FILE2.el")` to function: `dotspacemacs/user-config` in `.spacemacs` file, then `<SPC> q r` to restart


## Useful Shortcuts
- major mode commands: `,` instead of `<SPC> m`
- insert snippet: `<SPC> i s`
- select around object: `v a e`
- select around subtree: `v a r`
- after visual selection, fix indentation: `=`
- indent entire subtree: `= a r`
- narrow on subtree: `, s n`
- text related formatting options: `<SPC> x`
- replace text in selection: `:s/FIND/REPLACE`
- buffer related: `<SPC> b`
- new buffer: `<SPC> b N n`
- sort time in selection: `, s S`
- search : `, s s`
- make tables of the list: `C-c C-x C-c`
- 



### Snippets
highlight piece of code that will be used as snippet, then run `<SPC> <SPC> helm-yas-create-snippet-on-region`.
