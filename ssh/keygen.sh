#!/usr/bin/env bash
#shellcheck shell=bash
#export DEV=true
[ "${DEV}" ] && set -x || set +x

# ---------------------------------------------------------------------------------------------------
#                                               /\_/\
#                                              ( o.o )
#                                               > ^ <
#                                  _SSH Key Management for Macbook_
#
# MAINTAINER:.................. <David Chevallier>
# MAIL:........................ <huegelig.gelehrten-0y@icloud.com>
# _________________________ (☞ﾟヮﾟ)☞ _List of Documentations_ ☜(ﾟヮﾟ☜) _______________________________
# Docu:........................ <https://man.openbsd.org/ssh-keygen.1>
#                               <https://developer.apple.com/documentation/security/keychain_services>
# Validator:................... <https://www.shellcheck.net/>
# Copyright:................... <2023, David Chevallier>
# License:..................... <MIT>
# ---------------------------------------------------------------------------------------------------
#
#                                           MIT License
#
# Copyright (c) 2023 David Chevallier
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# ---------------------------------------------------------------------------------------------------

# Variablen
SSHHOME="$HOME/.ssh/"
STRUCK="$HOME/.ssh/keys"

# Ordner für die SSH-Schlüssel erstellen
checkdir() {
  # Prüfg der Verzeichniesse
  if [ -d "$STRUCK" ]; then
    printf "%s\n ${STRUCK} ist angelegt"
  else
    printf "%s\n ${STRUCK} wird angelegt"
    # gen dirs
    mkdir -p "${STRUCK}"/privat
    mkdir -p "${STRUCK}"/public
    mkdir -p "${STRUCK}"/tmp
  fi
  # Gen Key
  genkey
}

# Generate SSH keys
genkey() {
  printf "\n keys werden generiert"
  ssh-keygen -t ed25519 -a 100 -C "sigma_molar01@icloud.com - Zweck: Gitlab zugriff" -f "${STRUCK}"/tmp/gitlab -q -N ""
  ssh-keygen -t ed25519 -a 100 -C "sigma_molar01@icloud.com - Zweck: Github zugriff" -f "${STRUCK}"/tmp/github -q -N ""
  # Adding to the Apple keychain / Hinzufügen in dien Apple Keychain
  ssh-add --apple-use-keychain "${STRUCK}"/tmp/gitlab
  ssh-add --apple-use-keychain "${STRUCK}"/tmp/github
  # Sorting keys / Sorting der Keys
  sorting
}

sorting() {
  printf "\n keys werden umsortiert"
  mv "${STRUCK}"/tmp/*.pub "${STRUCK}"/public/
  mv "${STRUCK}"/tmp/* "${STRUCK}"/privat/
  # Adaptation of permissions / Anpassung der Berechtigungen
  permissions
}

permissions() {
  printf "\n fix permissions"
  find "${STRUCK}" -type f -name "*.pub" -exec chmod 644 {} \;
  chmod 600 "${STRUCK}/privat/*"
  cleanup
}

cleanup() {
  printf "\n Cleanup"
  rm -rf "${STRUCK}/tmp"
}

# gen ssh conf / Erstellen der SSH-Comf
genconfig() {
  printf "\n Gen der SSH-Conf"
  cat <<EOF >"${SSHHOME}"/config
Host *
  UseKeychain yes
  AddKeysToAgent yes

# Home Server
Host server
  HostName xxxxx.xxx
  IdentityFile ~/.ssh/keys/privat/xy
  Port xxxxx
  User xxxxx
  IdentitiesOnly yes
  ServerAliveInterval 60
  ServerAliveCountMax 3
  Compression yes
  LogLevel VERBOSE

# Home Server Rescue
Host server-rsg
  HostName xxxxx.xxx
  IdentityFile ~/.ssh/keys/privat/xy
  Port xxxxx
  User xxxxx
  ServerAliveInterval 60
  ServerAliveCountMax 3
  Compression yes
  LogLevel VERBOSE

# Swiss server
  Host server-ex
  IdentityFile ~/.ssh/keys/privat/xy
  HostName xxx.xxx.xxx.xxx
  Port xxxxx
  User xxxxx
  ServerAliveInterval 60
  ServerAliveCountMax 3
  Compression yes
  LogLevel VERBOSE

# Public Git
Host gitlab.com
  HostName gitlab.com
  IdentityFile ~/.ssh/keys/privat/gitlab
  User git
  IdentitiesOnly yes
  ServerAliveInterval 60
  ServerAliveCountMax 3
  Compression yes
  LogLevel VERBOSE

Host github.com
  HostName github.com
  IdentityFile ~/.ssh/keys/privat/github
  User git
  IdentitiesOnly yes
  ServerAliveInterval 60
  ServerAliveCountMax 3
  Compression yes
  LogLevel VERBOSE

Match all
  Include ~/.fig/ssh
  TCPKeepAlive yes
  ConnectTimeout 10
  IPQoS lowdelay throughput
  HashKnownHosts yes
  Protocol 2
  ControlMaster auto
  ControlPath ~/.ssh/controlmasters/%r@%h:%p
  ControlPersist 10m
  ForwardX11 no
  ForwardX11Trusted no
EOF
  # Setze die Berechtigungen für die config
  chmod 600 "${SSHHOME}/config"
}

checkdir
genconfig
