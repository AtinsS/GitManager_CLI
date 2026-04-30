Here's the English translation of your README:

---

# 🚀 Git Manager

> A simple tool for managing multiple Git repositories without unnecessary commands

**Platform:** Windows  
**Language:** Batch Script

[**Russian README**](https://github.com/AtinsS/GitManager/blob/main/README.ru.md)

---

## 💭 Why I made it

I have several repositories, and I got tired of typing the same Git commands over and over:
```
git add .
git commit -m "fix"
git push origin main
```

I wanted something simple: open it, choose an action, and it just works.
That's how **🚀 Git Manager** was born.

---

### 🧑‍💻 This is for you if:

- 📦 you have multiple repositories across different hosting platforms
- 😵 you're tired of typing the same Git commands
- ⚡ you want to quickly commit + push with one click
- 🔘 you need to quickly update all projects with a single button

---

## 🧰 What can the project do?

- 📁 Manage multiple repositories
- 📦 Organize projects into groups
- 📚 Initialize a repository on GitHub/GitLab
- ⬆️ Commit + Push in a single action
- ⬇️ Mass update of all repositories with one button
- 📊 Repository status displayed directly in the menu
- 🌿 Work with branches
- 🔄 Clone / Pull / Push without CLI
- 📜 Change history (git log)
- 🤖 Auto-commits on a timer
- 🌐 Language support with auto-detection at startup (RU / EN)

---

## ⚙️ Quick Start

1. Install [Git](https://git-scm.com/)
2. Download the project, or clone the repository
3. Run: `GIT-MANAGER.BAT`
4. Enjoy 🚀

---

## 🖥️ Interface

### Main Menu

```batch
═══════════════════════════════════════════════════════════════════════════════
       ███  ███ █████    █   █  ███  █   █  ███   ███  █████ ████
      █      █    █      ██ ██ █   █ ██  █ █   █ █     █     █   █
      █  ██  █    █      █ █ █ █████ █ █ █ █████ █  ██ ████  ████
      █   █  █    █      █   █ █   █ █  ██ █   █ █   █ █     █  █
       ███  ███   █      █   █ █   █ █   █ █   █  ███  █████ █   █  by AtinsS
══════════════════════════════════════════════════════════════════════════════

▸ REPOSITORIES

▸ Group: Group1
  1. Repo1  [dev] ● clean

▸ Group: Group2
  2. Repo2  [main] ● changes
  3. Repo3  [main] ● clean

════════════════════════════════════════════════════════════
▸ ACTIONS
  [1-3]  Select
════════════════════════════════════════════════════════════
  [C] Clone repository
  [A] Add repository

  [G] Manage groups
  [U] Update all repositories

  [S] Settings
  [D] Delete (repo will only be removed from the manager)
════════════════════════════════════════════════════════════
  [X] Exit
════════════════════════════════════════════════════════════

  →
```

---

### Repository Actions Menu

```batch
  ════════════════════════════════════════════════════════════
  Repository: Repo1  Branch: dev
  Status: ✅ clean
  ════════════════════════════════════════════════════════════

  1. Git status (check state)
  2. Git pull (update)
  3. Git add + commit + push (with comment)
  4. Go to undo changes menu
  5. View history (git log)
  6. Git merge (merge branches)
  7. Git merge --abort (cancel merge)
  8. Show branches available for merge
  9. Create branch
  10. Switch branch
  11. Auto-commits (every N minutes)
  0. Return to main menu

 →
```

---

### ❓ Why Batch Script?

- No installation required
- Works out of the box
- Lightweight and fast

---

## ☕ Support the Developer

If **Git Manager** saved you time or proved useful,  
if you'd like, you can support my development:

- ⭐ Star the repository
- ☕ [Buy me a coffee](https://pay.cloudtips.ru/p/cbaa3c81)

---
