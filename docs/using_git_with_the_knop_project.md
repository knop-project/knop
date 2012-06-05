Using git with the Knop Project
===============================
This article assumes that you have a GitHub account, set up your SSH keys to work with GitHub, and installed git.  If not, please refer to the [Git and GitHub Installation and Configuration Guide](git_install_guide.md).

The Knop Project uses the "fork and pull" model for collaboration.  This article provides explicit instructions to developers so they can follow this model and be effective collaborators in the project.

Fork and clone the Knop repo
----------------------------
1. While logged into your GitHub account, navigate to the Knop Project on GitHub.

	<https://github.com/knop-project/knop>

	We strongly recommend that you __click the Watch button__ so that you can follow progress of the project.

2. __Fork the Knop Project repository__ to your GitHub account by clicking the "Fork" button.  At the time of this writing, the Fork button appeared in the upper-right corner beneath your account name.

3. __Clone your fork__ of Knop from your GitHub account to your local computer.  The URL to use in the command will be the SSH option, and appears like this:

		git@github.com:USERNAME/knop.git
	
	In your Terminal application, enter the following command, substituting your account username as noted.

		git clone git@github.com:USERNAME/knop.git

4. __Configure remotes__ such that you can pull changes from the Knop Project repository into your local repository.

	In your Terminal application, enter the following commands:

		cd knop
		# Changes the active directory to the newly cloned "knop" directory

		git remote add upstream git@github.com:knop-project/knop.git
		# Assigns the original repo to a remote called "upstream"

		git fetch upstream
		# Pulls in changes not present in your local repository, without modifying your files

Now you're ready to start doing some work.

###Updating your local repo

Before you start working on your local files, you should pull down all updates from the upstream repo to your local repo, and merge any changes into your working files.

	git fetch upstream
	# Fetches any new changes from the original repo

	git merge upstream/master
	# Merges any changes fetched into your working files

###Create a branch

Branching allows you to test an idea or add new features to the project.  To create a branch and begin working in it, run these commands:

	git branch mybranch
	# Creates a new branch called "mybranch"

	git checkout mybranch
	# Makes "mybranch" the active branch

You can switch between branches at any time using git checkout.

	git checkout master
	# Makes "master" the active branch

	git switch mybranch
	# Makes "mybranch" the active branch

Determine which branch you are currently on, and the status of files in your local repository.

	git status

When you edit files, changes are tracked according to whichever branch is current at that time.  Thus you should always switch to the branch where you want to do your code editing before editing code.

Once you are done editing files, you need to stage them (add them to the index) and commit them with a message.  This shortcut does it all in one swoop:

	git commit -a -m "commit_message"



###Updating your fork on GitHub

	git fetch upstream
	git merge upstream/master
	git push



For more information
====================
The following article provides a tutorial and overview for a non-existent project called "Spoon-Knife", but you can merely substitute the following commands for your account.

[Fork a repo](https://help.github.com/articles/fork-a-repo)

