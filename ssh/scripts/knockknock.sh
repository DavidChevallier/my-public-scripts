#!/usr/bin/env bash
#shellcheck shell=bash
#export DEV=true
[ "${DEV}" ] && set -x || set +x

# ---------------------------------------------------------------------------------------------------
#                                               /\_/\
#                                              ( o.o )
#                                               > ^ <
#                                   _SSH Port knockknock script_
#
# MAINTAINER:.................. <David Chevallier>
# MAIL:........................ <huegelig.gelehrten-0y@icloud.com>
# _________________________ (☞ﾟヮﾟ)☞ _List of Documentations_ ☜(ﾟヮﾟ☜) _______________________________
# Docu:........................ <https://zsh.sourceforge.io/Doc/>
#                               <http://zsh.sourceforge.net/Doc/Release/Shell-Builtin-Commands.html>
#                               <https://man.openbsd.org/sshd_config>
#                               <https://github.com/reyjrar/sshlint>
#                               <https://wiki.archlinux.org/title/Port_knocking>
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
HOST="xxxxxxxx"
SEQUENCE="9,2,8,4,22,...."

for PORT in $SEQUENCE; do
    nmap -Pn --host-timeout 201 --max-retries 0 -p "$PORT" "$HOST"
done

ssh -p 3535 david@$HOST