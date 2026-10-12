export PATH="$HOME/.config/JetBrains:$HOME/.local/bin:$HOME/bin:$PATH"
echo $PATH | grep -q "$HOME/.dotfiles/bin" || export PATH="$HOME/.dotfiles/bin:$PATH"
