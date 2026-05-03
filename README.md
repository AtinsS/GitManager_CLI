# 🚀 Git Manager

**Platform:** Windows only  

**Language:** Batch Script
[**Russian README**](https://github.com/AtinsS/GitManager/blob/main/README.ru.md)

---

## 🚀 What is this?

**Git Manager** is an interactive wrapper around Git that turns the complex CLI into a simple menu.

Forget about:

```
git add .
git commit -m "fix"
git push origin main
```

Now — just pick an action.  
**The tool does the rest.**

---

## ⁉️ Why it’s convenient

- ⚡ **Faster** — routine operations in a few clicks
- 🧠 **Simpler** — no need to remember which hosting your repository is on
- 📦 **More organized** — all repositories from different hostings in one place
- 🎯 **More practical** — focus on code, not on pushing repos

---

## 🧰 Features

- 📁 Manage multiple repositories from different hostings
- 📦 Group projects by categories
- ⬆️ Commit + Push in a single action
- 🆒 Mass update of all repositories with one button
- 📊 View repository **status** and **hosting** right from the main menu
- 🌿 Full branch management (create, switch)
- 💘 Clone, create, or even initialize directly on GITHUB / GITLAB
- 📜 View commit history (git log)
- 🤖 Automatic commits on a timer
- 🌐 Automatic language detection (currently 2 languages: Russian and English)

---

## 🧑‍💻 Who is this for?

- Developers with multiple projects on different hostings
- Those tired of the Git CLI
- Beginners who want to quickly get up to speed with Git
- Anyone who values their time

---

## ⚙️ Quick start

1. Install [Git](https://git-scm.com/)
2. Download the project or clone the repository
3. Run: `GIT-MANAGER.BAT`
4. Enjoy

---

## 🖥️ What it looks like

### Main menu

```batch
═════════════════════════════════════════════════════════════
             GIT-MANAGER 🚀         by AtinsS
═════════════════════════════════════════════════════════════

▸ REPOSITORIES

  ▸ Group: Homework
 1.  DataInApp              [dev]    [GitLab]      ● changes

  ▸ Group: Pet projects
 2.  GIT-MANAGER-REPO       [main]   [GitHub]      ● changes
 3.  MySITE                 [dev]    [GitHub]      ● clean

  ▸ Group: Tests (private)
 4.  FirsPrivateRepo        [main]   [GitHub]      ● clean
 5.  ForTests               [dev]    [GitLab]      ● clean  

════════════════════════════════════════════════════════════
▸ ACTIONS
  [1-4]  Select
════════════════════════════════════════════════════════════
  [C] Clone repository
  [A] Add repository

  [G] Manage groups
  [U] Update all repositories

  [S] Settings
  [D] Delete (repo will only be removed from manager)
════════════════════════════════════════════════════════════
  [X] Exit
════════════════════════════════════════════════════════════

  →
```

---

### Actions inside a repository

```batch

  Repository: DataInApp  Hosting: [GitLab]  Branch: dev
  Status: ⚠️ changes present
  ═══════════════════════════════════════════════════════════

  1. Git status (check state)
  2. Git pull (update)
  3. Git add + commit + push (with comment)
  4. Go to undo changes menu
  5. View history (git log)
  6. Git merge (merge branches)
  7. Git merge --abort (cancel merge)
  8. Show branches for merging
  9. Create branch
  10. Switch branch
  11. Auto-commits (every N minutes)
   0. Back to main menu

 →
```

---

## ☕ Support the developer

If **Git Manager** saved you time and proved useful, you can support the project's development:

- ⭐ Star the repository
- ☕ [Buy me a coffee and a bun](https://pay.cloudtips.ru/p/cbaa3c81)

Any support = more time for new projects.