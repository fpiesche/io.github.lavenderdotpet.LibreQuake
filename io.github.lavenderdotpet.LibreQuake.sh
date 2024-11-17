#!/bin/bash
ENGINE_CONFIG="${XDG_CONFIG_HOME}/lq_engine"
HIDE_LAUNCHER="${XDG_CONFIG_HOME}/lq_hide_launcher"

function write_engine_config {
    if [[ -f ${ENGINE_CONFIG} ]]; then
      rm "${ENGINE_CONFIG}"
    fi
    echo "$1" > "${ENGINE_CONFIG}"
}

if [[ ! -f "${HIDE_LAUNCHER}" ]]; then
#     FALSE "VkQuake (Vulkan renderer)" \
#     FALSE "fteqw (Multiplayer)" \
#     FALSE "qss-m (OpenGL 1.x/2.x for older hardware)" \
#     FALSE "TyrQuake (Software rendering)" \

  CHOICE=$(zenity --list --radiolist --hide-header --modal --width=600 --height=400 \
    --column="" --column="" \
    TRUE "QuakeSpasm (default)" \
    FALSE "Ironwail (High-performance)" \
    --title "LibreQuake Launcher" \
    --text "Select which engine to launch" \
    --extra-button "Open mod path" \
    --ok-label "Launch" \
    --cancel-label "Quit")

  case "$CHOICE" in
    "Open mod path")
      echo "Opening mod path $XDG_DATA_HOME..."
      xdg-open "$XDG_DATA_HOME"
      exit 2
      ;;
    "QuakeSpasm"*)
      write_engine_config "quakespasm"
      ;;
    "Ironwail"*)
      write_engine_config "ironwail"
      ;;
    "VkQuake"*)
      write_engine_config "vkquake"
      ;;
    "fteqw"*)
      write_engine_config "fteqw"
      ;;
    "qss-m"*)
      write_engine_config "qss-m"
      ;;
    "TyrQuake"*)
      write_engine_config "tyrquake"
      ;;
    *)
      exit 1
      ;;
  esac
  touch "${HIDE_LAUNCHER}"
fi

exitcode=$?
if [[ $exitcode -ne 0 ]]; then
  echo "Quitting..."
elif [[ $exitcode -eq 0 ]]; then
  echo "Launching LibreQuake using $(cat ${ENGINE_CONFIG})..."
  $(cat "${ENGINE_CONFIG}") -basedir /app/extra/librequake $@
fi
