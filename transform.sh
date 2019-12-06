#!/usr/bin/env bash
################################################################################
#    Author: Wenxuan Zhang                                                     #
#     Email: wenxuangm@gmail.com                                               #
#   Created: 2019-12-06 09:35                                                  #
################################################################################
set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd) && cd "$SCRIPT_DIR" || exit 1

usage() { echo "Usage: $(basename "$0") <scel_file1> [scel_file2]..." >&2; }

[[ $# -eq 0 ]] && usage && exit 1

scel_file=$1
dict_name=$(basename "$scel_file" .scel)
text_dict="/tmp/$dict_name.txt"

info() { printf "%b[info]%b %s\n" '\e[0;32m' '\e[0m' "$@" >&2; }
warn() { printf "%b[warn]%b %s\n" '\e[0;33m' '\e[0m' "$@" >&2; }
error() { printf "%b[error]%b %s\n" '\e[0;31m' '\e[0m' "$@" >&2; }

for scel_file in "$@"; do
    dict_name=$(basename "$scel_file" .scel)
    text_dict="/tmp/$dict_name.txt"
    target="ext.$dict_name.dict.yaml"

    info "$scel_file => $target..."
    imewlconverter -i:scel "$scel_file" -o:rime "$text_dict" -ct:pinyin -os:linux

    error=$( (cat <<-EOF | sed 's/\r//' > "$target"
# Rime dictionary
# $dict_name
# encoding: utf-8

---
name: ext.$dict_name
version: "$(date -I)"
sort: by_weight
use_preset_vocabulary: false
...
$(cat "$text_dict")
EOF
) 2>&1)

    [[ -z "$error" ]] || error "$error"

    rm -rf "$text_dict"
    echo
done
