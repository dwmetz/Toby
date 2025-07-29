#!/bin/bash

cat << "EOF"

████████╗ ██████╗ ██████╗ ██╗   ██╗
╚══██╔══╝██╔═══██╗██╔══██╗╚██╗ ██╔╝
   ██║   ██║   ██║██████╔╝ ╚████╔╝ 
   ██║   ██║   ██║██╔══██╗  ╚██╔╝  
   ██║   ╚██████╔╝██████╔╝   ██║   
   ╚═╝    ╚═════╝ ╚═════╝    ╚═╝   

Your Forensic Consulting Companion
https://bakerstreetforensics.com
v1.0 07.2025

🔍 Type `toby-find` (tf) for tools and examples.

EOF

HELP_FILE="/usr/local/share/toby/toby-cli-help.txt"

if [[ ! -f "$HELP_FILE" ]]; then
  echo "Missing help file: $HELP_FILE"
  exit 1
fi

if [[ -z "$1" ]]; then
  echo "Usage: toby-find [search term] or \"all\""
  echo "Try: toby-find all"
  exit 1
fi

# Easter Eggs 🥚
if [[ "$1" =~ ^(evil|sherlock|moriarty|42)$ ]]; then
  echo ""
  case "$1" in
    evil)
      echo "Unfortunately, the \"find evil\" button, is just a myth."
      echo "Try again."
      ;;
    sherlock)
      echo "\"When you have eliminated the impossible," 
      echo "whatever remains —however improbable—"
      echo "must be the truth.\" "
      ;;
    moriarty)
      echo "⚠️  Consulting criminal detected. Intelligence unmatched. Access denied."
      ;;
    42)
      echo "Answer: 42"
      echo "Now... what was the question?"
      ;;
  esac
  echo "________________________________________"
  exit 0
fi

# Category listing
if [[ "$1" == "--categories" ]]; then
  awk -F: '/^Category:/ { print $2 }' "$HELP_FILE" | sort -u
  exit 0
fi

#!/bin/bash

if [[ "$1" == "toby" ]]; then
  cat ~/.ascii
fi

# Brief tool list
if [[ "$1" == "--brief" ]]; then
  awk -F: '/^Tool:/ { print $2 }' "$HELP_FILE" | sort
  exit 0
fi

# Full help dump
if [[ "$1" == "all" ]]; then
  cat "$HELP_FILE"
  exit 0
fi

# Block-based search with clean leading separation
awk -v IGNORECASE=1 -v term="$1" '
BEGIN { block = ""; found = 0 }
/^--------------------------------------------------$/ {
  if (block ~ term) {
    if (found == 0) {
      print "";
      found = 1
    }
    print block "\n" $0;
  }
  block = ""; next
}
{
  block = block $0 "\n"
}
END {
  if (block ~ term) {
    if (found == 0) print "";
    print block
  }
}
' "$HELP_FILE"
