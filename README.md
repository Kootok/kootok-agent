# Куток для агентов: плагин Claude Code и скилл для Codex и Kimi

[Куток](https://kootok.app) — журнал работы: люди ставят задачи, агенты
выполняют их через MCP-сервер Кутка, люди принимают результат.

Правила работы агента (как брать задачи, отчитываться, проходить ревью) живут
**на сервере Кутка** и отдаются агенту инструментом `skill_get`. В этом
репозитории их нет — здесь только **заглушка**: короткий скилл «ты работаешь
через Куток: вызови `skill_get`, передавай `skill_version`, при `outdated`
перечитай». Ему нечему устаревать, поэтому обновлять его не нужно.

## Что внутри

| Путь | Что это |
| --- | --- |
| `.claude-plugin/marketplace.json` | маркетплейс Claude Code с одним плагином `kootok` |
| `plugins/kootok/.claude-plugin/plugin.json` | манифест плагина: спрашивает адрес сервера и ключ, подключает MCP-сервер Кутка |
| `plugins/kootok/skills/kootok-skill/SKILL.md` | заглушка-скилл плагина |
| `standalone-skill/kootok-skill/SKILL.md` | та же заглушка для Codex и Kimi |
| `check.sh` | проверка без сети: заглушка ведёт к `skill_get`, не копирует правила, копии совпадают, ключей нет |

## Claude Code

```sh
claude plugin marketplace add Kootok/kootok-agent
claude plugin install kootok@kootok
```

То же внутри Claude Code: `/plugin marketplace add Kootok/kootok-agent`,
затем `/plugin install kootok@kootok`.

При включении плагин спросит два значения:

- адрес MCP-сервера вашей организации, например `https://<организация>.kootok.app/mcp`;
- ключ агента из экрана «Агенты» в Кутке.

Ключ вводите сами: в файлах плагина его нет, Claude Code хранит его в
защищённом хранилище. В новой сессии скилл виден как `kootok:kootok-skill`, и
агент сам начинает с `skill_get`.

Если MCP-сервер Кутка у вас уже подключён вручную (`claude mcp add`), второй
сервер из плагина не нужен — оставьте один. Удалить плагин:
`claude plugin uninstall kootok@kootok` и `claude plugin marketplace remove kootok`.

## Codex и Kimi Code CLI

Скопируйте папку `standalone-skill/kootok-skill/` целиком:

| Клиент | Для одного проекта | Для пользователя |
| --- | --- | --- |
| Codex | `<проект>/.agents/skills/kootok-skill/` | `~/.agents/skills/kootok-skill/` |
| Kimi Code CLI | `<проект>/.agents/skills/kootok-skill/` (также `.kimi/skills`, `.claude/skills`, `.codex/skills`) | `~/.config/agents/skills/kootok-skill/` (рекомендуется) или `~/.agents/skills/…`, `~/.kimi/skills/…` |

MCP-сервер Кутка эти клиенты подключают своими средствами (Kimi —
`~/.kimi/mcp.json`, Codex — `config.toml`). Скиллы подхватываются при запуске:
после копирования перезапустите клиент.

## Проверка

```sh
./check.sh
```

Если установлен CLI `claude`, скрипт дополнительно выполняет
`claude plugin validate --strict` для маркетплейса и плагина.

## Источники (14.11.2026)

- Манифест плагина и `userConfig`: https://code.claude.com/docs/en/plugins/manifest-reference
- Маркетплейс: https://code.claude.com/docs/en/plugins/create-marketplace
- Команды `claude plugin …`: https://code.claude.com/docs/en/plugins/cli-reference
- MCP в плагинах: https://code.claude.com/docs/en/mcp
- Скиллы Codex: https://learn.chatgpt.com/docs/build-skills
- Скиллы Kimi Code CLI: https://moonshotai.github.io/kimi-cli/en/customization/skills.html
