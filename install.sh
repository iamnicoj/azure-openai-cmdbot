# Simple installer for cmdbot in the user's home directory

echo "Hello. Installing cmdbot..."
echo "- Creating cmdbot-ai-cmdbot in home directory..."
TARGET_DIR=~/cmdbot-ai-cmdbot
TARGET_FULLPATH=$TARGET_DIR/cmdbot.py
mkdir -p $TARGET_DIR

echo "- Copying files..."
cp cmdbot.py prompt.txt cmdbot.yaml $TARGET_DIR
chmod +x $TARGET_FULLPATH

# Creates two aliases for use
echo "- Creating cmdbot and computer aliases..."
alias cmdbot=$TARGET_FULLPATH
alias computer=$TARGET_FULLPATH

# Add the aliases to the logon scripts
# Depends on your shell
if [[ "$SHELL" == "/bin/bash" ]]; then
  echo "- Adding aliases to ~/.bash_aliases"
  [ "$(grep '^alias cmdbot=' ~/.bash_aliases)" ]     && echo "alias cmdbot already created"     || echo "alias cmdbot=$TARGET_FULLPATH"     >> ~/.bash_aliases 
  [ "$(grep '^alias computer=' ~/.bash_aliases)" ] && echo "alias computer already created" || echo "alias computer=$TARGET_FULLPATH" >> ~/.bash_aliases
elif [[ "$SHELL" == "/bin/zsh" ]]; then
  echo "- Adding aliases to ~/.zshrc"
  [ "$(grep '^alias cmdbot=' ~/.zshrc)" ]     && echo "alias cmdbot already created"     || echo "alias cmdbot=$TARGET_FULLPATH"     >> ~/.zshrc 
  [ "$(grep '^alias computer=' ~/.zshrc)" ] && echo "alias computer already created" || echo "alias computer=$TARGET_FULLPATH" >> ~/.zshrc
else
  echo "Note: Shell was not bash or zsh."
  echo "      Consider configuring aliases (like cmdbot and/or computer) manually by adding them to your login script, e.g:"
  echo "      alias cmdbot=$TARGET_FULLPATH     >> <your_logon_file>"
fi

echo
echo "Done."
echo
echo "Make sure you have the OpenAI API key set via one of these options:"
echo "  - environment variable"
echo "  - .env
echo
echo "Have fun!"
