# dotfiles
Using stow.

git clone --recursive https://github.com/ludo-c/dotfiles.git

update submodules:

git submodule update --init --recursive

If you did not clone this repos in ~/dotfiles, use this to install files:
``` shell
stow --target=$HOME <dir>
```

## zsh
Using zprezto. Install with stow first then read the instructions in order to install it.

https://github.com/ludo-c/prezto.git

## awesome
require :
- vicious (awesome-extra for debian)
- lua-filesystem (run_once)
- acpi (for laptop, battery state)
- pavucontrol
- compton (dim unfocused windows)
- uses clementine-player for music, xscreensaver-command, thunar, firefox (with default and proxy profile), nm-applet, blueman-applet, redshift-gtk

In order to have the battery plugin, add a file "~/.laptop".

## urxvt
Don't forget to update submodules for extensions

## tmux
Uses 'vlock'

