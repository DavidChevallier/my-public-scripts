# OhMyDahal OSX Bootstraper Beispiel Skripte

- [OhMyDahal OSX Bootstraper Beispiel Skripte](#ohmydahal-osx-bootstraper-beispiel-skripte)
  - [sshkey gen script](#sshkey-gen-script)
  - [Port Knocking](#port-knocking)
    - [Bash Port Knocking](#bash-port-knocking)
    - [ZSH Alias Port Knocking](#zsh-alias-port-knocking)
      - [Bashscript als Alias](#bashscript-als-alias)
  - [Dokumentationen](#dokumentationen)

## sshkey gen script

Dieses Skript generiert SSH-Schlüssel auf deinem Mac(Book) und fügt das Key Passwort der Apple Keychain hinzu. Damit ist die andauernde password abfrage nötig.

```bash
./ssh-keygen.sh
```

## Port Knocking

### Bash Port Knocking

Das Bash-Skript führt ein Port-Knocking-Schema aus, bevor es eine SSH-Verbindung aufbaut. Du musst das Skript ausführen, bevor du eine SSH-Verbindung zu deinem Server herstellst.

```bash
./knockknock.sh
```

### ZSH Alias Port Knocking

Das Alias Skript hat die gleiche Funktion wie das Bash-Skript, wird aber über das ZSH Alias gesteuert.
Es erkennt, wenn der Befehl 'ssh' ausgeführt wird und führt automatisch das Port-Knocking-Schema aus, bevor eine SSH-Verbindung aufgebaut wird, wenn der subcommand "server" verwendet wird (z. B. 'ssh server').

#### Bashscript als Alias

```bash
echo 'alias ssh="source ~/{{_PATH-TO-SCRIPT_}}/knockknock.sh"' >> ~/.zshrc
zsh
```

## Dokumentationen

- [ssh-keygen](<https://man.openbsd.org/ssh-keygen.1>)
- [Apple developer keychain](<https://developer.apple.com/documentation/security/keychain_services>)
- [Archlinux Port_knocking](<https://wiki.archlinux.org/title/Port_knocking>)
- [shellcheck](<https://www.shellcheck.net/>)
- [ZSH Docu](<https://zsh.sourceforge.io/Doc/>)
- [sshd_config](<https://man.openbsd.org/sshd_config>)
