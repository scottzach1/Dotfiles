# Catppuccin Mocha — fish syntax colours (replaces the Dracula theme).
set -l rosewater f5e0dc
set -l flamingo  f2cdcd
set -l pink      f5c2e7
set -l mauve     cba6f7
set -l red       f38ba8
set -l peach     fab387
set -l yellow    f9e2af
set -l green     a6e3a1
set -l teal      94e2d5
set -l blue      89b4fa
set -l text      cdd6f4
set -l overlay0  6c7086
set -l surface0  313244

set -g fish_color_normal        $text
set -g fish_color_command       $blue
set -g fish_color_keyword       $red
set -g fish_color_quote         $green
set -g fish_color_redirection   $pink
set -g fish_color_end           $peach
set -g fish_color_comment       $overlay0
set -g fish_color_error         $red
set -g fish_color_param         $flamingo
set -g fish_color_operator      $pink
set -g fish_color_escape        $pink
set -g fish_color_autosuggestion $overlay0
set -g fish_color_cancel        $red
set -g fish_color_search_match  --background=$surface0
set -g fish_color_selection     --background=$surface0

set -g fish_pager_color_prefix      $pink
set -g fish_pager_color_completion  $text
set -g fish_pager_color_description $overlay0
set -g fish_pager_color_progress    $overlay0
