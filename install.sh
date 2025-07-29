#!/bin/bash
set -e

INSTALL_DIR="/usr/local/bin"
SHARE_DIR="/usr/local/share/toby"
SCRIPT_NAME="toby-find"

# Determine user shell and set appropriate rc file
USER_SHELL=$(getent passwd "$USER" | awk -F: '{print $7}')
if [[ "$USER_SHELL" == */zsh ]]; then
    SHELL_RC="$HOME/.zshrc"
else
    SHELL_RC="$HOME/.bashrc"
fi

echo "[+] Installing $SCRIPT_NAME...Your Forensic Consulting Companion"

# Install main script
sudo cp "$SCRIPT_NAME.sh" "$INSTALL_DIR/$SCRIPT_NAME"
sudo chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

# Add alias 'tf'
if ! grep -q "alias tf=" "$SHELL_RC"; then
    echo "alias tf='$SCRIPT_NAME'" >> "$SHELL_RC"
    echo "[+] Alias 'tf' added to $SHELL_RC"
fi

# Add alias 'toby-find' (redundant but for robustness)
if ! grep -q "alias toby-find=" "$SHELL_RC"; then
    echo "alias toby-find='$SCRIPT_NAME'" >> "$SHELL_RC"
    echo "[+] Alias 'toby-find' added to $SHELL_RC"
fi

# Prompt for help file selection
echo "[?] Which help file do you want to install?"
select choice in "Kali" "REMnux"; do
  case $choice in
    "Kali")
      HELP_FILE="help_files/toby-cli-help-kali.txt"
      break
      ;;
    "REMnux")
      HELP_FILE="help_files/toby-cli-help-remnux.txt"
      break
      ;;
    *)
      echo "Invalid choice. Please select 1 or 2."
      ;;
  esac
done

# Install CLI help
sudo mkdir -p "$SHARE_DIR"
sudo cp "$HELP_FILE" "$SHARE_DIR/toby-cli-help.txt"
echo "[+] CLI help reference installed to $SHARE_DIR"

# Install ASCII easter egg
cp help_files/ascii/toby.ascii "$HOME/.ascii"

# Add alias for help
if ! grep -q "alias tf-help=" "$SHELL_RC"; then
    echo "alias tf-help='cat $SHARE_DIR/toby-cli-help.txt'" >> "$SHELL_RC"
    echo "[+] Alias 'tf-help' added to $SHELL_RC"
fi

echo "[✔] Installation complete."
echo "[ℹ] Run 'source $SHELL_RC' or open a new terminal to activate aliases."
