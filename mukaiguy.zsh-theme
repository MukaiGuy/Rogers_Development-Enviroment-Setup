echo " "
PROMPT=$'%{$FG[184]%}| %{$reset_color%}%{$FG[220]%}%n %{$reset_color%}@ %{$reset_color%}%{$FG[044]%}%m%{$reset_color%} %{$FG[076]%}%t %{$reset_color%}⟫ %{$FG[211]%} %~ %{$reset_color%} $(git_prompt_info)\
%{$FG[184]%}|➜ %{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX="| %{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} |"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DELETED=" %{$FG[197]%}⚑%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED=" %{$fg[white]%}◒%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_MODIFIED=" %{$fg[yellow]%}⚑%{$reset_color%}"
# link for color info https://plumbum.readthedocs.io/en/latest/colors.html
