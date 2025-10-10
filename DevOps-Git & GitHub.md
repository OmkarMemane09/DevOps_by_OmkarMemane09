## 🧩 Version Control

**Definition:**  
Version Control is a system that helps track and manage changes to files or code over time. It allows multiple developers to collaborate, view history, and revert to previous versions if needed.

**Use:**  
- Keeps track of code changes  
- Enables team collaboration  
- Helps restore older versions  
- Prevents conflicts during development  

**Example:**  
- **Git** → A distributed version control system used for managing source code.  
- **GitHub** → A cloud platform to host Git repositories for collaboration.

## ⚙️ Types of Version Control Systems

1. **Local VCS** – Stores versions on a local system.  
   *Example:* RCS (Revision Control System)

   <img width="524" height="264" alt="image" src="https://github.com/user-attachments/assets/e57c3cbf-209f-4a35-aaa7-bfd2dd78c1ec" />

3. **Centralized VCS (CVCS)** – Uses a central server to store all files and versions.  
   *Example:* SVN, Perforce
  <img width="991" height="506" alt="image" src="https://github.com/user-attachments/assets/146e9e1f-6bcd-481c-b4da-c640ad6b7845" />

   

5. **Distributed VCS (DVCS)** – Every user has a local copy of the entire repository.  
   *Example:* Git, Mercurial
   <img width="979" height="489" alt="image" src="https://github.com/user-attachments/assets/effc3b4a-7f8a-4d8c-80c9-dc9351ccdaa3" />

---

### 🔁 Difference Between Centralized and Distributed VCS

| Feature | Centralized VCS | Distributed VCS |
|----------|-----------------|-----------------|
| **Repository** | Single central server | Each user has full copy |
| **Offline Work** | Not possible | Possible |
| **Speed** | Slower (depends on server) | Faster (local operations) |
| **Data Loss Risk** | High (if server fails) | Low (copies on all systems) |
| **Examples** | SVN, CVS | Git, Mercurial |

## 📘 Version Control System Terminologies

| Term | Description |
|------|--------------|
| **Repository (Repo)** | A storage location where all project files and history are kept. |
| **Commit** | A snapshot of your changes saved in the repository. |
| **Branch** | A separate line of development allowing parallel work. |
| **Merge** | Combines changes from one branch into another. |
| **Clone** | Creates a local copy of a remote repository. |
| **Push** | Uploads local commits to a remote repository. |
| **Pull** | Fetches and integrates changes from remote to local. |
| **Fork** | A personal copy of someone else's repository on your account. |
| **Remote** | The version of the repository hosted online (like on GitHub). |
| **Checkout** | Switches between branches or versions in a repository. |
| **HEAD** | A pointer that shows the current branch or commit you’re working on. |

---------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
# 🧠 What is Git?

**Git** is a **Distributed Version Control System (DVCS)** that helps developers track changes in code, collaborate efficiently, and maintain version history.  
Each developer has a **complete local copy** of the repository, including all branches and commits, enabling offline work and faster operations.

Git records snapshots of your project, allowing you to easily move between different versions or collaborate with others through branching and merging.

---

## ⚙️ Key Git Concepts & Terminologies

| Term | Description |
|------|--------------|
| **Working Directory** | The local folder on your system where project files are created and modified. |
| **Staging Area (Index)** | A temporary area where changes are added (`git add`) before committing. It acts as a preparation zone. |
| **Local Repository** | The `.git` folder on your system that stores all commit history, branches, and configuration. |
| **Remote Repository** | A version of your project hosted on a remote server (e.g., GitHub, GitLab, Bitbucket). |
| **Commit ID / SHA** | A unique hash (like `a3f5c9d...`) assigned to every commit to identify it uniquely. |
| **Tag** | A label used to mark specific commits as important — often used for version releases (e.g., `v1.0`, `v2.5`). |
| **Stash** | Temporarily saves uncommitted changes without committing them, allowing you to switch branches safely. |
| **Fetch** | Downloads new data (commits, branches) from the remote repository but doesn’t merge them automatically. |
| **Rebase** | Reapplies commits on top of another branch’s history — helps maintain a clean, linear commit history. |
| **Cherry-pick** | Applies a specific commit from one branch to another without merging the entire branch. |
| **Blame** | Shows which user made changes to each line of a file — useful for tracking edits. |
| **Revert** | Creates a new commit that undoes the effects of a previous commit. |
| **Reset** | Moves the HEAD to a specific commit, discarding or keeping changes depending on the mode (`--soft`, `--mixed`, `--hard`). |
| **HEAD** | A pointer to the latest commit in your current branch. Moving HEAD changes your current working state. |
| **Origin** | The default name given to the remote repository when it’s first cloned. |
| **.gitignore** | A file that tells Git which files or folders to ignore (e.g., logs, temporary files). |

---

## 🧩 How Git Works (Simplified Flow)

```bash
# 1️⃣ Create or initialize repository
git init

# 2️⃣ Check status of files
git status

# 3️⃣ Add files to staging area
git add <filename>

# 4️⃣ Commit staged changes
git commit -m "Your message"

# 5️⃣ Connect to remote repository
git remote add origin <repo-URL>

# 6️⃣ Push changes to remote
git push origin main
