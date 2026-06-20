# AI Agent Rules

## 1. Purpose

This file defines rules for AI coding agents working in this project.

The purpose is to record that this project is developed by the human developer with support from AI tools. AI is used as a coding assistant, not as an outsourced developer or external person doing the work.

AI may assist with code suggestions, debugging, refactoring, UI improvements, documentation, and testing support. The human developer must review, understand, test, and take final responsibility for the code.

## 2. Critical Rules

- Before modifying code, read this `AGENTS.md` file.
- Every time AI writes, edits, refactors, debugs, generates, or deletes code, update `docs/AI_USAGE_LOG.md`.
- Every meaningful AI-assisted coding session must have a log entry.
- Do not commit, amend, push, create pull requests, delete files, or run destructive commands unless the developer explicitly confirms.
- The human developer is responsible for final code review, testing, and commits.
- Do not print, store, copy, or commit secrets, including:
  - API keys
  - Access tokens
  - Passwords
  - Connection strings
  - Private credentials
  - Sensitive local configuration

## 3. AI Usage Evidence Rule

After each code-related task, update:

`docs/AI_USAGE_LOG.md`

Each log entry must include:

- Date and time
- AI tool/model used
- User request/prompt
- Task name
- AI assistance summary
- Estimated AI support level
- Files created, modified, or deleted
- Commands run
- Test/build result
- Git status summary
- Human developer review note

## 4. Responsibility Rule

AI can assist with implementation, but the developer must:

- Review the generated code
- Understand the logic
- Check business requirements
- Run the project
- Run tests if available
- Confirm before commit or push

AI must not claim the code is production-ready unless it has been built, tested, and reviewed.

## 5. Git Rules

Before ending a task, run or ask the developer to run:

```powershell
git status --short --branch --untracked-files=all
```

Then summarize the result in `docs/AI_USAGE_LOG.md`.

AI must not run these actions without explicit developer confirmation:

```bash
git commit
git push
git reset --hard
git clean
git rebase
git merge
git branch -D
```

## 6. Safety Rules

Before risky operations, ask the developer first.

Risky operations include:

- Deleting files or folders
- Dropping database tables
- Running destructive migrations
- Overwriting user changes
- Force pushing
- Resetting branches
- Removing untracked files

## 7. Workflow For Every Coding Task

1. Read `AGENTS.md`.
2. Understand the user request.
3. Inspect only relevant files first.
4. Make focused changes.
5. Run or suggest verification commands.
6. Update `docs/AI_USAGE_LOG.md`.
7. Show a short summary of what changed.

## 8. Productivity Guidance

- Prefer small, focused edits.
- Do not refactor unrelated code.
- Do not change backend/API contracts unless requested.
- For UI tasks, edit only the relevant component/CSS first.
- For debugging, record the error and attempted fix in the log.
