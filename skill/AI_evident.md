# AI Evidence Setup Task

## Mục đích

Thiết lập cơ chế ghi nhận việc sử dụng AI trong quá trình phát triển project.

Mục tiêu chính:

- Chứng minh project có sự hỗ trợ của AI.
- Chứng minh Developer tự làm project, không nhờ người ngoài làm thay.
- Ghi lại AI đã hỗ trợ phần nào: viết code, sửa lỗi, refactor, UI, test, debug.
- Ghi lại file nào đã được AI hỗ trợ chỉnh sửa.
- Nhắc rõ Developer là người review, hiểu logic, chạy test và chịu trách nhiệm cuối cùng.

AI chỉ là công cụ hỗ trợ lập trình, không phải người làm thay project.

---

# Task cho AI Agent

Hãy thực hiện các việc sau trong project hiện tại.

## 1. Tạo hoặc cập nhật file `AGENTS.md`

Tạo file `AGENTS.md` ở thư mục gốc project nếu chưa có.

Nếu đã có rồi, hãy cập nhật thêm các rule bên dưới, không xóa nội dung quan trọng cũ nếu không cần thiết.

Nội dung cần có trong `AGENTS.md`:

````md
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
````

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

````

---

## 2. Tạo thư mục `docs`

Nếu chưa có thư mục `docs`, hãy tạo thư mục:

```txt
docs
````

---

## 3. Tạo hoặc cập nhật file `docs/AI_USAGE_LOG.md`

Tạo file `docs/AI_USAGE_LOG.md` nếu chưa có.

Nếu đã có rồi, giữ lại log cũ và chỉ bổ sung format/rule nếu còn thiếu.

Nội dung cần có:

````md
# AI Usage Log

Tài liệu này ghi lại lịch sử AI hỗ trợ viết, sửa, refactor, debug hoặc test code trong dự án.

## Purpose

This log is used as evidence that AI tools were used to assist the developer during project development.

AI assistance does not mean the project was completed by an external person. The developer remains the owner of the work, reviews the generated code, verifies the logic, runs tests, and takes final responsibility for all commits.

Mục đích:

- Chứng minh project có sử dụng AI hỗ trợ lập trình.
- Chứng minh Developer tự làm project, không nhờ người ngoài làm thay.
- Theo dõi AI đã hỗ trợ task nào.
- Ghi lại prompt, file thay đổi, lệnh test và kết quả.
- Nhắc rõ Developer là người review và chịu trách nhiệm cuối cùng.

## Logging Rules

- Thêm log mới lên đầu phần `Log History`.
- Không ghi API key, token, password, connection string hoặc thông tin nhạy cảm.
- Nếu không biết chính xác model AI, ghi `Unknown / Antigravity AI`.
- Mức độ hỗ trợ `%` là ước lượng, không phải số tuyệt đối.
- Mỗi task có sửa code nên có ít nhất một log.
- AI không được tự commit/push nếu Developer chưa xác nhận.

## Log Format

```md
## [YYYY-MM-DD HH:mm:ss] - [Task Name]

| Field                      | Content                                                                                                              |
| -------------------------- | -------------------------------------------------------------------------------------------------------------------- |
| AI Tool / Model            | [Ví dụ: Antigravity AI / Gemini / Claude / Unknown]                                                                  |
| Support Type               | [Generate code / Fix bug / Refactor / UI update / Test / Debug]                                                      |
| Estimated AI Support       | [Ví dụ: 70% AI suggestion, 30% developer review]                                                                     |
| Human Reviewer             | [Tên/Nickname dev review]                                                                                            |
| Development Responsibility | AI assisted with implementation, but the developer reviewed, tested, and accepted responsibility for the final code. |

### User Prompt

[Prompt hoặc yêu cầu chính người dùng đã đưa cho AI]

### AI Assistance Summary

- [AI đã phân tích gì]
- [AI đã sửa/gợi ý gì]
- [AI đã hỗ trợ test/debug gì]

### Files Created / Modified / Deleted

| File            | Action   | Summary          |
| --------------- | -------- | ---------------- |
| `path/to/file1` | Modified | [Sửa gì]         |
| `path/to/file2` | Created  | [Tạo gì]         |
| `path/to/file3` | Deleted  | [Xóa gì, nếu có] |

### Commands Run & Results

| Command                                             | Result                       |
| --------------------------------------------------- | ---------------------------- |
| `git status --short --branch --untracked-files=all` | [Kết quả]                    |
| `[build command]`                                   | [Success / Failed / Not run] |
| `[test command]`                                    | [Passed / Failed / Not run]  |

### Git Status Summary

[Ví dụ: Modified 2 files, created 1 file, no commit made]

### Developer Review Notes

- [Dev cần kiểm tra lại gì]
- [Phần nào chưa test]
- [Có cần commit/push không]

---
```
````

## Log History

<!-- Add newest AI usage log entries above this line -->

````

---

## 4. Sau khi tạo/cập nhật file

Sau khi hoàn tất, hãy chạy lệnh:

```powershell
git status --short --branch --untracked-files=all
````

Sau đó báo lại cho Developer:

- Đã tạo/sửa file nào.
- Có tạo thư mục `docs` không.
- Trạng thái git hiện tại.
- Có cần Developer review gì không.

---

## 5. Không được tự commit

Không được tự chạy:

```bash
git add .
git commit
git push
```

Trừ khi Developer yêu cầu rõ ràng.

---

# Definition of Done

Task này hoàn thành khi:

- Có file `AGENTS.md`.
- Có file `docs/AI_USAGE_LOG.md`.
- Nội dung có ghi rõ:
  - Project có AI hỗ trợ.
  - Developer không nhờ người ngoài làm thay.
  - Developer chịu trách nhiệm cuối cùng.
  - AI phải ghi log mỗi khi hỗ trợ code.
  - Không lưu secret.
  - Không tự commit/push.

- Đã chạy `git status`.
- Đã báo lại danh sách file đã tạo/sửa.
