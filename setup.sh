#!/usr/bin/env bash
################################################################################
#    Author: Wenxuan Zhang                                                     #
#     Email: wenxuangm@gmail.com                                               #
#   Created: 2019-12-03 18:51                                                  #
################################################################################
set -euo pipefail
IFS=$'\n\t'

info() { printf "%b[info]%b %s\n" '\e[0;32m' '\e[0m' "$@" >&2; }
warn() { printf "%b[warn]%b %s\n" '\e[0;33m' '\e[0m' "$@" >&2; }
error() { printf "%b[error]%b %s\n" '\e[0;31m' '\e[0m' "$@" >&2; }

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd) && cd "$SCRIPT_DIR" || exit 1

info 'Init submodule...'
git submodule update --init --recursive

info 'Install double-pinyin...'
rime_dir=. ./plum/rime-install double-pinyin

info 'Relink config directory...'
rm -rf ~/.config/fcitx/rime && mkdir -p ~/.config/fcitx
ln -sf "$SCRIPT_DIR" ~/.config/fcitx/rime

info 'Clone directory repo...'
rm -rf tmp && git clone --depth=1 https://github.com/wfxr/pinyin-dicts tmp

info 'Transform directory...'
./transform.sh ./tmp/*.scel

info 'Clean up...'
rm -rf tmp

info 'Finished.'
