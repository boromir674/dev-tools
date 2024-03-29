#!/usr/bin/sh

remind () {
  COUNT="$#"
  COMMAND="$1"
  MESSAGE="$1"
  OP="$2"
  shift 2
  WHEN="$@"

  # Display help if no parameters or help command
  if [ "$COUNT" -eq 0 ] || [ "$COMMAND" = "help" ] || [ "$COMMAND" = "--help" ] || [ "$COMMAND" = "-h" ]; then
    echo "COMMAND"
    echo "    remind <message> <time>"
    echo "    remind <command>"
    echo
    echo "DESCRIPTION"
    echo "    Displays notification at specified time"
    echo
    echo "EXAMPLES"
    echo '    remind "Hi there" now'
    echo '    remind "Time to wake up" in 5 minutes'
    echo '    remind "Dinner" in 1 hour'
    echo '    remind "Take a break" at noon'
    echo '    remind "Are you ready?" at 13:00'
    echo '    remind list'
    echo '    remind clear'
    echo '    remind help'
    echo
    return
  fi

  # Check presence of AT command
  if ! command -v at >/dev/null; then
    echo "remind: AT utility is required but not installed on your system. Install it with your package manager of choice, for example 'sudo apt install at'."
    return
  fi

  # Run commands: list, clear
  if [ "$COUNT" -eq 1 ]; then
    if [ "$COMMAND" = "list" ]; then
      at -l
    elif [ "$COMMAND" = "clear" ]; then
      at -r "$(atq | cut -f1)"
    else
      echo "remind: unknown command $COMMAND. Type 'remind' without any parameters to see syntax."
    fi
    return
  fi

  # Determine time of notification
  if [ "$OP" = "in" ]; then
    # now + count time-units, where the time-units can be minutes, hours, days, or weeks
    TIME="now + $WHEN"
  elif [ "$OP" = "at" ]; then
    TIME="$WHEN"
  elif [ "$OP" = "now" ]; then
    TIME="now"
  else
    echo "remind: invalid time operator $OP"
    return
  fi

  # Schedule the notification
  echo "notify-send '$MESSAGE' 'Reminder'" | at "$TIME" 2>/dev/null
  echo "Notification scheduled at $TIME"
}
