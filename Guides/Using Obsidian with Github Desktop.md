## Introduction
Obsidian is a powerful knowledge base that works on top of a local folder of plain text Markdown files. GitHub is a web-based platform used for version control and collaborative coding. Combining Obsidian with GitHub allows you to back up your notes, collaborate with others, and track changes over time.

## Prerequisites
1. **Obsidian**: Download and install [Obsidian](https://obsidian.md/downloads).
2. **GitHub Account**: Create an account on [GitHub](https://github.com/).
3. **Git**: Install Git on your computer. Follow the instructions [here](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).

## Setting Up Your Repository
1. **Create a New Repository on GitHub**:
   - Go to GitHub and log in.
   - Click on the `+` icon in the top right corner and select `New repository`.
   - Name your repository and add a description.
   - Choose to make the repository public or private.
   - Click `Create repository`.

2. **Clone the Repository to Your Local Machine**:
   - Open your terminal or Git Bash.
   - Navigate to the directory where you want to store your Obsidian notes.
   - Run the following command, replacing `<username>` and `<repository>` with your GitHub username and repository name:
     ```bash
     git clone https://github.com/<username>/<repository>.git
     ```

## Setting Up Obsidian
1. **Create a New Vault**:
   - Open Obsidian.
   - Click on `Create new vault`.
   - Name your vault and choose the location where you cloned your GitHub repository.
   - Click `Create`.

2. **Organize Your Notes**:
   - Start creating and organizing your Markdown notes within Obsidian.
   - Obsidian will save your notes in the local folder linked to your GitHub repository.

## Syncing Notes with GitHub
1. **Add and Commit Changes**:
   - Open your terminal or Git Bash.
   - Navigate to your repository directory.
   - Add all changes to Git:
     ```bash
     git add .
     ```
   - Commit the changes:
     ```bash
     git commit -m "Add notes"
     ```

2. **Push Changes to GitHub**:
   - Push your changes to the remote repository:
     ```bash
     git push origin main
     ```

## Automating Sync with GitHub Desktop (Optional)
1. **Install GitHub Desktop**:
   - Download and install [GitHub Desktop](https://desktop.github.com/).

2. **Set Up Repository in GitHub Desktop**:
   - Open GitHub Desktop.
   - Click on `File` > `Add Local Repository`.
   - Select the folder of your Obsidian vault.
   - Click `Add Repository`.

3. **Commit and Push Changes**:
   - In GitHub Desktop, you can see the changes made to your notes.
   - Write a summary of the changes and click `Commit to main`.
   - Click `Push origin` to sync your changes with GitHub.

## Conclusion
By following this guide, you can effectively use Obsidian Markdown with GitHub to manage and back up your notes. This setup ensures that your notes are version-controlled and safely stored in the cloud, providing an efficient way to collaborate and track changes over time.

