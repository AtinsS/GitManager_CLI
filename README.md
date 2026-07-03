# 🚀 Git Manager CLI

> **Git without pain. Without commands. Without extra steps.**

**Platform:** Windows · **Language:** Batch Script · **Version:** 2.0

[**Russian README**](https://github.com/AtinsS/GitManager/blob/main/README.ru.md)

---

## 📖 About

**Git Manager CLI** is an interactive shell over Git that turns the terminal into an intuitive menu.

All repositories — GitHub, GitLab, Bitbucket, Azure DevOps, Codeberg, Gitea — in one place.

```diff
- git add .
- git commit -m "fix"
- git push origin main

+ Just pick an action → the tool handles the rest
```

---

## ✨ Why it's handy

| | |
|---|---|
| ⚡ **Fast** | Routine operations in a couple of clicks |
| 🧠 **Simple** | No need to remember where each repo lives |
| 📦 **Convenient** | All projects from different hosts in one menu |
| 🎯 **Practical** | Launch it from anywhere via CLI |

---

## 🧰 Features

### 📁 Repository Management
- ✅ Multiple repositories from different hosts in one window
- ✅ Organize projects into groups
- ✅ Auto-detect host by URL
- ✅ View status and current branch right from the main menu

### ⚡ Git Operations
- `Git status` — check state
- `Git pull` — update
- `Git add + commit + push` — commit with a message in one action
- `Git merge` / `merge --abort` — branch merging and rollback
- Create and switch branches
- List branches available for merge

### ⏪ Rollback Changes
- `reset` — roll back to a specific commit (soft / mixed / hard)
- `revert` — undo a commit while preserving history

### 🤖 Automation
- **Auto-commits** — commit on a timer (every N minutes) with optional push
- **Mass update** — `git pull` for all repositories with one button

### 🌐 Localization
- Auto-detect system language
- Two sets of scripts: `ru/` and `en/`

---

## 🚀 Quick Start

**1.** Install [Git](https://git-scm.com/)

**2.** Download the project:
```batch
git clone https://github.com/AtinsS/GitManager.git
```

**3.** Run `GIT-MANAGER.BAT`

**4.** *(Optional)* Run `install.bat` — after that, you can call `gitmanager` from any folder.

---

## 🖥️ Interface

### Main Menu
```
═════════════════════════════════════════════════════════════
             GIT-MANAGER          by AtinsS
═════════════════════════════════════════════════════════════
▸ REPOSITORIES
  ▸ Group: Homework
 1.  DataInApp              [dev]    [GitLab]      ● changes
  ▸ Group: Pet-projects
 2.  GIT-MANAGER-REPO       [main]   [GitHub]      ● changes
 3.  MySITE                 [dev]    [GitHub]      ● clean
═════════════════════════════════════════════════════════════
▸ ACTIONS
  [1-3]  Select repository
  [C] Clone        [A] Add
  [G] Groups       [U] Update all
  [S] Settings     [D] Remove from manager
  [X] Exit
  →
```

### Repository Menu
```
  Repository: DataInApp  Host: [GitLab]  Branch: dev
  Status: ⚠ has changes
  ════════════════════════════════════════════════════════════
  1. Git status              6. Git merge
  2. Git pull                7. Git merge --abort
  3. Add + Commit + Push     8. Show branches for merge
  4. Rollback menu           9. Create branch
  5. View history            10. Switch branch
                             11. Auto-commits (every N minutes)
   0. Back to main menu
  →
```

---

## 🌐 Supported Hosts

- 🟦 **GitHub** · **Azure DevOps** · **Bitbucket**
- 🟪 **GitLab**
- 🟩 **Codeberg** · **Gitea** · **Gitee**
- 🟨 **Local** (local repositories)

---

## 📂 Project Structure

<details>
<summary><b>Show structure</b></summary>

```
GitManager/
├── GIT-MANAGER.BAT        # Entry point (auto-detect language)
├── gitmanager.bat         # Wrapper for PATH launch
├── install.bat            # Add to PATH
├── uninstall.bat          # Remove from PATH
├── cfg/
│   ├── git_repos.cfg      # Repository list (Name;Path;URL;Host)
│   └── groups.cfg         # Groups (GroupName;repo1;repo2;...)
├── ru/
│   ├── GIT-MANAGER-RU.bat # Main menu (Russian)
│   └── git-scripts/       # Git operation scripts
└── en/
    ├── GIT-MANAGER-EN.bat # Main menu (English)
    └── git-scripts/       # Git operation scripts
```

</details>

---

## ☕ Support the Developer

If **Git Manager** saved you time:

- ⭐ Star the repository
- ☕ [Buy me coffee with a bun](https://pay.cloudtips.ru/p/cbaa3c81)

Any support = more time for new projects 💜