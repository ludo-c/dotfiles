""""""""""""""""""""""""""""""""""""""""""""""""""
" Fichier .vimrc de Nicolas Gressier
" Créé le 11 mai 2006
" Yoshidu62@gmail.com
" Mise à jour : 14/05/2010
" Version 2.7
""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""
"Diverses options
""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible                                  " désactivation de la compatibilité avec vi
"colorscheme desert                                " couleur
set background=dark                               " fond sombre
syntax enable                                     " activation de la coloration syntaxique
set number                                        " numérotation des lignes
set autoindent                                    " indentation automatique avancée
set smartindent                                   " indentation plus intelligente
set laststatus=2                                  " ajoute une barre de status
set backspace=indent,eol,start                    " autorisation du retour arrière
set history=50                                    " historique de 50 commandes
set ruler                                         " affiche la position courante au sein du fichier
set showcmd                                       " affiche la commande en cours
set shiftwidth=8                                  " nombre de tabulation pour l'indentation
set tabstop=8									  " nombre d'espace pour une tabulation
set showmatch                                     " vérification présence ([ ou { à la frappe de )] ou }
filetype plugin indent on                         " détection automatique du type de fichier
"autocmd FileType text setlocal textwidth=72       " les fichiers de type .txt sont limites à 72 caractères par ligne
set fileformats=unix,mac,dos                      " gestion des retours chariot en fonction du type de fichier
"set viewdir=/home/ngressier/.vim/saveview/        " répertoire pour sauvegarder les vues, utiles pour les replis manuels
set foldcolumn=2                                  " repère visuel pour les folds
let Tlist_Ctags_Cmd = '/usr/bin/ctags'			  " implémentation de ctags, nécessaire pour le plugin 'taglist'
set incsearch                                     " recherche incrémentale
set hlsearch                                      " surligne les résultats de la recherche
set ignorecase                                    " ne pas prendre en compte la casse pour les recherches
set nolist										  " on n'affiche pas les caractères non imprimables
set listchars=eol:¶,tab:..,trail:~				  " paramétrage des caractères non imprimables au cas où l'on souhaiterait les afficher
set backupdir=~/.vimtmp                            " do not store ~ files in current directory
set directory=~/.vimtmp

set smartcase                                     " recherche avec case intelligente
highlight Normal ctermfg=grey ctermbg=black
highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
match ExtraWhitespace /\s\+$\| \+\ze\t/
autocmd BufWritePre * %s/\s\+$//e                 " Automatically removing all trailing whitespace

""""""""""""""""""""""""""""""""""""""""""""""""""
"Mapping pour naviguer dans les lignes coupées
""""""""""""""""""""""""""""""""""""""""""""""""""
map <A-DOWN> gj
map <A-UP> gk
imap <A-UP> <ESC>gki
imap <A-DOWN> <ESC>gkj

""""""""""""""""""""""""""""""""""""""""""""""""""
"Repositionner le curseur à l'emplacement de la
"dernière édition
""""""""""""""""""""""""""""""""""""""""""""""""""
set viminfo='10,\"100,:20,%,n~/.viminfo
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

""""""""""""""""""""""""""""""""""""""""""""""""""
"Chargement des types de fichiers
""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd BufEnter *.txt set filetype=text             " chargement du type de fichier pour le format txt

""""""""""""""""""""""""""""""""""""""""""""""""""
"Omni-completion par CTRL-X_CTRL-O
""""""""""""""""""""""""""""""""""""""""""""""""""
au filetype html        set omnifunc=htmlcomplete#CompleteTags
au filetype css         set omnifunc=csscomplete#CompleteCSS
au filetype javascript  set omnifunc=javascriptcomplete#CompleteJS
au filetype c           set omnifunc=ccomplete#Complete
au filetype php         set omnifunc=phpcomplete#CompletePHP
au filetype ruby        set omnifunc=rubycomplete#Complete
au filetype sql         set omnifunc=sqlcomplete#Complete
au filetype python      set omnifunc=pythoncomplete#Complete
au filetype xml         set omnifunc=xmlcomplete#CompleteTags

""""""""""""""""""""""""""""""""""""""""""""""""""
"Map pour se déplacer dans les onglets
""""""""""""""""""""""""""""""""""""""""""""""""""
map <tab> gt

""""""""""""""""""""""""""""""""""""""""""""""""""
"Mapping pour copier, couper, coller
"et sélectionner
""""""""""""""""""""""""""""""""""""""""""""""""""
"map <C-x> "+x
map <C-c> "+y
map <C-p> "+gP
"map <C-a> ggVG

""""""""""""""""""""""""""""""""""""""""""""""""""
"Dictionnaire français
"Liste des propositions par CTRL-X_CTRL-K
""""""""""""""""""""""""""""""""""""""""""""""""""
set dictionary+=/usr/share/dict/french

""""""""""""""""""""""""""""""""""""""""""""""""""
"Couleur pour les templates
""""""""""""""""""""""""""""""""""""""""""""""""""
hi def link Todo TODO
syn keyword Todo TODO FIXME XXX DEBUG
