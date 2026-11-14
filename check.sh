#!/usr/bin/env bash
# Проверка заглушки без сети и без установки: заглушка ссылается на skill_get и
# skill_version, не копирует правила (короткая, без ссылок на references/),
# обе копии одинаковы; если есть CLI claude — ещё и claude plugin validate.
set -euo pipefail
cd "$(dirname "$0")"
A=plugins/kootok/skills/kootok-skill/SKILL.md
B=standalone-skill/kootok-skill/SKILL.md
fail() { echo "FAIL: $*" >&2; exit 1; }
cmp -s "$A" "$B" || fail "копии заглушки разошлись: $A и $B"
grep -q 'skill_get' "$A" || fail "заглушка не называет skill_get"
grep -q 'skill_version' "$A" || fail "заглушка не называет skill_version"
grep -q 'outdated' "$A" || fail "заглушка не говорит про outdated"
grep -q 'references/' "$A" && fail "заглушка ссылается на references/ — это копия правил"
[ "$(wc -l < "$A")" -le 30 ] || fail "заглушка длиннее 30 строк — похоже на копию правил"
if grep -rIE 'Bearer [A-Za-z0-9_-]{16,}|kootok_[a-z]+_[A-Za-z0-9]{16,}' . >/dev/null; then fail "в папке похоже на ключ"; fi
if command -v claude >/dev/null 2>&1; then
  claude plugin validate . --strict
  claude plugin validate plugins/kootok --strict
else
  echo "claude не найден: claude plugin validate пропущен"
fi
echo "OK"
