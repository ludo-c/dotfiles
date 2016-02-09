# dotfiles
using stow

## zsh
Using zprezto. Install with stow first then read the instructions in order to install it.
https://github.com/ludo-c/prezto.git

## awesome
require :
- vicious (awesome-extra for debian)
- lua-filesystem (run_once)
- acpi (for laptop, battery state)
- pavucontrol
- uses clementine-player for music, xscreensaver-command, thunar, firefox (with default and proxy profile), nm-applet, blueman-applet, redshift-gtk

In order to have the battery plugin, add a file "~/.laptop".

