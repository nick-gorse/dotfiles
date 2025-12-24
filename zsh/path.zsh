export PATH="$HOME/.config/JetBrains:/usr/local/opt/grep/libexec/gnubin/:$HOME/.rvm/bin:$HOME/local/bin:$HOME/local/sbin:$HOME/.local/bin:$HOME/bin:$PATH"
echo $PATH | grep -q "$HOME/.dotfiles/bin" || export PATH="$HOME/.dotfiles/bin:$PATH"
