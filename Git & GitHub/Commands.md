# Essential Git Commands for Cloud and DevOps Roles

🧩 1. Git Configuration
```bash
# Set global username and email (used for commits)
git config --global user.name "Your Name"
git config --global user.email "youremail@example.com"

# Check all global configurations
git config --global --list

# Set default branch name (main instead of master)
git config --global init.defaultBranch main
```
📁 2. Initialize and Clone Repositories
```bash
# Initialize a new Git repository in current folder
git init

# Clone a remote repository
git clone https://github.com/username/repo-name.git

# Clone with SSH (preferred for DevOps)
git clone git@github.com:username/repo-name.git
```
📄 3. Basic File Operations
```bash
# Check the current status of files
git status

# Add a single file to staging area
git add filename.txt

# Add all files to staging
git add .

# Commit changes with a message
git commit -m "Meaningful commit message"

# Skip staging and directly commit tracked files
git commit -am "Quick commit message"

# Remove file from staging (unstage)
git reset HEAD filename.txt
```

🌿 4. Branch Management
```bash
# List all branches
git branch

# Create a new branch
git branch feature-branch

# Switch to a branch
git checkout feature-branch

# Create and switch to a new branch
git checkout -b dev

# Merge a branch into current branch
git merge feature-branch

# Delete a local branch
git branch -d branch-name

# Force delete branch
git branch -D branch-name
```
☁️ 5. Remote Repository Operations (Essential for Cloud/DevOps)
```bash
# Add a remote repository (link local repo to GitHub)
git remote add origin https://github.com/username/repo.git

# Verify the remote URL
git remote -v

# Push local commits to remote
git push origin main

# Push and set default upstream (first-time push)
git push -u origin main

# Pull latest changes from remote
git pull origin main

# Fetch all branches from remote
git fetch --all
```
🔄 6. Sync and Collaboration
```bash
# Pull updates from remote and rebase instead of merge
git pull --rebase origin main

# Stash temporary changes
git stash

# View list of stashed changes
git stash list

# Apply last stashed changes
git stash apply

# Drop (delete) stash
git stash drop
```
🧹 7. Undo / Rollback Operations
```bash
# Undo last commit but keep changes staged
git reset --soft HEAD~1

# Undo last commit and unstage changes
git reset --mixed HEAD~1

# Undo last commit and discard all changes
git reset --hard HEAD~1

# Restore a specific file from last commit
git restore filename.txt

# Revert a specific commit safely (for public branches)
git revert <commit-hash>
```
🧭 8. View and Inspect
```bash
# Show commit history
git log

# Compact log (one-line)
git log --oneline

# See who changed what in a file
git blame filename.txt

# Compare working directory with last commit
git diff

# Compare between branches
git diff main dev
```
🧱 9. Tagging (For Release Versions in DevOps)
```bash
# Create lightweight tag
git tag v1.0

# Create annotated tag (recommended)
git tag -a v1.0 -m "Version 1.0 release"

# List all tags
git tag

# Push tags to remote
git push origin --tags

# Delete tag locally
git tag -d v1.0

# Delete tag remotely
git push origin --delete tag v1.0
```
⚙️ 10. GitHub Workflow (Typical DevOps Flow)
```bash
# 1. Fork repository (on GitHub UI)
# 2. Clone your fork
git clone https://github.com/yourname/repo.git

# 3. Create a new branch
git checkout -b feature-xyz

# 4. Add and commit changes
git add .
git commit -m "Added feature xyz"

# 5. Push to your fork
git push origin feature-xyz

# 6. Create Pull Request (PR) from GitHub UI
```
🔐 11. SSH Key Setup for GitHub (Secure Cloud Access)
```bash
# Generate new SSH key
ssh-keygen -t ed25519 -C "youremail@example.com"

# Start ssh-agent and add key
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Copy SSH key to clipboard (Linux/Mac)
cat ~/.ssh/id_ed25519.pub

# Then add it to GitHub → Settings → SSH and GPG keys
```
🧰 12. Advanced / Useful Commands
```bash
# View remote branches
git branch -r

# View all branches (local + remote)
git branch -a

# Remove untracked files (careful)
git clean -f

# Rebase a branch (linear commit history)
git rebase main

# Squash multiple commits into one
git rebase -i HEAD~3

# Rename a branch
git branch -m old-name new-name
```
