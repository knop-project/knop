How to install and configure the EGit plugin for Eclipse (and LassoLab) to work with the Knop Project on GitHub
===============================================================================================================
EGit is a plugin to use git within any Eclipse-based IDE, including LassoLab.  This document covers the process to install and configure the EGit plugin for LassoLab/Eclipse.  In addition, you can use the EGit plugin to work with GitHub Issues (a public bug tracker) and Gists (a code snippet sharing tool).  We'll use the Knop Project on GitHub for this document.

In LassoLab/Eclipse, there are many ways of doing the same thing.  You can use menus, CTRL-click or right-click on an item to get a contextual menu, click on buttons in toolbars, or map keyboard shortcuts to specific functions.  We'll use menus as they tend to be the easiest to locate.  We will also use the internal web browser in LassoLab/Eclipse for browsing the web, and maximize and minimize that view as needed.

Pre-requisites
--------------
Before you begin, you must do the following:

* install and set up git
* create your own free GitHub account
* generate your SSH keys
* enter your public SSH key into your GitHub account

See [Git and GitHub Installation and Configuration Guide](git_install_guide.md) for complete instructions.

Install the EGit plugin
-----------------------
1. Select menu __Help > Install New Software...__.  A new window "Install" appears.
	- Work with: __http://download.eclipse.org/releases/indigo__.
	- Filter: __git__.
	- Check both items:
		- Eclipse Git Team Provider
		- JGit
	- Click button: __Next >__.
2. Click button: __Next >__.
3. Select "I accept the terms of the license agreement".
4. Click button: __Finish__.
5. Click button: __Restart Now__.  LassoLab will relaunch.

Fork the Knop Project
---------------------
Next we need to fork the Knop Project repository into our own account.

1. While logged into your GitHub account, go to the following URL:

	[https://github.com/knop-project/knop](https://github.com/knop-project/knop)

2. Click the __Fork__ button. GitHub indicates "hard core forking action" takes place, then takes your to your fork in your account.

Clone your fork
---------------
After you have forked the Knop Project repository, you will have your own copy under your account.  Now we're going to take your fork and clone it to your local computer.  First we need to copy the URI of your fork.

1. Click on the __SSH button__ in your GitHub fork.
2. Copy the URI to the clipboard.
3. Select __Window > Open Perspective > Other...__.  A slide-down pane appears.
4. Select __Git Repository Exploring__
5. Click button: __OK__. The Git Repository perspective opens.
6. Select the Git Repositories view to make it active.
7. Paste the URI you copied from Git.  A new wizard "Clone Git Repository" appears with most of the information auto-populated.  Complete required information for __Source Git Repository__.
	- URI: __git@github.com:MYACCOUNT/knop.git__
	- Host: __github.com__
	- Repository path: __MYACCOUNT/knop.git__
	- Connection > Protocol, select: __ssh__.
	- User: __git__.
	- Password: __enter your password__.
	- Check: __Store in Secure Store__.
	- Click button: __Next >__. The next step "Branch Selection" appears.
8. Select the master branch.
9. Click button: __Next >__. The next step "Local Destination" appears.
10. Now you can browse to put the project anywhere on the file system.  You can put it in your web root, your user directory, whatever is most familiar and convenient for you and your workflow.  For the purpose of this tutorial, we will put it in the web root for Mac OS X and give it a unique name.

		/Library/WebServer/Documents/knop-project

11. Click button: __Finish >__. Your fork will be cloned to your local computer, and will appear as a repository.

Configure remotes for your clone
--------------------------------
Next we need to configure remotes to pull down upstream changes from the Knop Project's repo.  EGit's UI is overly complex for this step, so we'll bypass it and directly edit the repository's configuration file.

1. In the __Git Repository__ view, navigate to __knop-project > Working Directory > .git__.
2. Open the file __config__.
3. Copy and paste the following three lines of code into the end of your git config file.

		[remote "upstream"]
			url = git@github.com:knop-project/knop.git
			fetch = +refs/heads/*:refs/remotes/upstream/*

4. Save and close the file.

Create a new project in LassoLab/Eclipse for your clone
-------------------------------------------------------
Finally we need to add the cloned local git repository into a new project in our workspace.  Let's create a new Lasso project.

1. Switch to the Lasso perspective
2. Select __File > New... > Lasso Project__.
	- Project name: knop-project
	- Contents: Create project at existing location (from existing source).  This is where you cloned your fork to your local computer.
	- Click button: __Next >__.
3. Click button: __Finish__.

Now you're ready to start doing some work.

Modifying and contributing to the Knop Project
----------------------------------------------
You can use EGit essentially as you would use git from the command line, but using a graphical user interface.  The process is similar to that in the guide [Using git with the Knop Project](using_git_with_the_knop_project.md#modifying-and-contributing-to-the-knop-project).

1. Update your local repo.

	Before you start working on your local files, you should pull down all updates from the upstream repo to your local repo, and merge any changes into your working files.
	
	- Fetch any new changes from the original repo. Select __Git > Fetch from Upstream__.
	- Merge any changes fetched into your working files. Select __Git > Pull__.

2. Create a branch.

	Branching allows you to test an idea or add new features to the project.  Let's create a branch (MYBRANCH or whatever you like) and begin working in it.

	- Select __Git > Switch to...__.  A new window "Branches" appears.
	- Click button __New branch...__.  A new window "Create Branch" appears.
	- Select Source ref: __refs/remotes/origin/master__.
	- Branch name: __MYBRANCH__
	- Select Pull strategy: __Merge__.
	- Check __Checkout new branch__.

3. You can __switch between branches__ at any time and determine on which branch you are currently working.

	- Select __Git > Switch to...__.  A new window "Branches" appears.  The current branch is indicated with a white checkmark in a tiny black square.
	- Select a branch without the white checkmark.  The button "Checkout" is enabled.
	- Click button: __Checkout__.
	
	When you edit files, changes are tracked according to whichever branch is current at that time.  Thus you should always switch to the branch where you want to do your code editing before editing code.

4. Once you are done editing files, you need to __stage__ them (add them to the index) and __commit__ them with a message.

	- Select __Git > Commit...__.  A new window "Commit Changes" appears.
	- Enter a __Commit message__.
	- Click button: __Commit__.

5. Next, push your branch from your clone up to your fork on GitHub.

	- Select __Git > Push to Upstream__.  A new window "Push Results: knop-project - origin" appears.  It displays information about what will be pushed.
	- Click button: __OK__.

6. Finally, to contribute your changes to the Knop Project, submit a __pull request__ through the GitHub website.  The project administrators will review your request.  Read details of [how to use pull requests](https://help.github.com/articles/using-pull-requests).

If you like to write documentation or produce demo videos, then you can contribute your work to the Knop Project.  The Knop Project's documentation uses the Markdown syntax, which GitHub supports.

Steve Piercy produced a brief video of how to configure BBEdit to do syntax highlighting for the Markdown markup language and how to preview your changes in real-time.

<iframe width="560" height="315" src="https://www.youtube.com/embed/XgCq_6xKLAc" frameborder="0" allowfullscreen></iframe>

GitHub Issues
-------------
You have already installed this component when you installed the EGit plugin.  First let's configure our GitHub Issues Repository.

1. Select __Window > Open Perspective > Other...__.
2. Select __Window > Show View > Other...__.
3. Filter: __task r__.
4. Select __Mylyn > Task Repositories__.
5. Click button: __OK__. A new view "Task Repositories" appears.
6. CTRL-click or right-click in the Task Repositories view, and select __Add Task Repository...__. A new wizard "Add Task Repository..." appears, with the initial step "Select a task repository type".
7. Select: __GitHub Issues__.
8. Click button: __Next >__. The next step "GitHub Issue Repository Settings" appears.
9. Configure settings for the GitHub Issue repository:
	- Server: __http://github.com/knop-project/knop__.
	- Label: __knop-project/knop issues__ (auto-entered, but you can change it).
	- User ID: enter your __GitHub account__.
	- Password: enter your __GitHub password__.
	- Optionally check __Save Password__.
	- Click button: __Validate Settings__. Either an error or success message will appear at the top of the wizard.
	- If successful, click button: __Finish__.  A new window "Add new query" appears.
10. To display and work with the issues in the task repository, we need to create a query to find the issues.  When you first create a task repository, you will be prompted to create a query, so let's do that now.  Click the button __Yes__.  A new window "Edit Query" appears.
11. Configure your query.  __Note:__ the UI to the filters is misleading.  The checkboxes for labels actually perform an AND search, not an OR search.  Therefore to view all items, select no labels.
	- Title: __All Knop Project Issues__.
	- Click button: __Finish__.
12. Select __Window > Show View > Other...__.
13. Filter: __task l__.
14. Select __Mylyn > Task List__.  The view "Task List" appears with your recently created query.

From this point you can now view and work with the Knop Project Issues in LassoLab/Eclipse or through the GitHub website.  Depending on your permissions, you will have different features enabled.

GitHub Gists
------------
A Gist is a simple way to share snippets and pastes with others. All gists are git repositories, so they are automatically versioned, forkable and usable as a git repository.

To configure a GitHub Gist repository, follow steps 1-6 for GitHub Issues above, then proceed as follows.

1. Select: __GitHub Gists__.
2. Click button: __Next >__. The next step "GitHub repository settings" appears.
3. Configure settings for the GitHub Gist repository:
	- Server: __https://gist.github.com__ (auto-entered).
	- Label: __Gists__ (auto-entered, but you can change it).
	- User ID: enter your __GitHub account__.
	- Password: enter your __GitHub password__.
	- Optionally check __Save Password__.
	- Click button: __Validate Settings__. Either an error or success message will appear at the top of the wizard.
	- If successful, click button: __Finish__.  A new window "Add new query" appears.
4. To display and work with the Gists in the task repository, we need to create a query to find the issues.  When you first create a task repository, you will be prompted to create a query, so let's do that now.  Click the button __Yes__.  A new window "Edit Query" appears.
5. Configure your query.
	- Title: __My Gists__.
	- User: enter your __GitHub account__.
6. Select __Window > Show View > Other...__.
7. Filter: __task l__.
8. Select __Mylyn > Task List__.  The view "Task List" appears with your recently created query.
9. To create a Gist:
	- Open or create a new file in the project.
	- Select either the file itself or a section of code in the file.
	- CTRL-click or right-click on the selection, and select either __GitHub > Create Public Gist__ or __GitHub > Create Private Gist__.   A new Gist is created in the Task List.
10. To open a Gist, double-click it.  Its repository appears.
11. Under Files > Name, double-click the name of the file to open it.

From this point you can now view and work with all of your Gists in LassoLab/Eclipse or through the GitHub website.

GitHub Pull Requests
--------------------
A Pull Request is a notification you send to a project maintainer to update their repository.  EGit supports the display and opening of Pull Requests.  As of this writing, EGit does not support the creation of Pull Requests.  However you can use GitHub's website through the internal web browser of LassoLab/Eclipse to submit a Pull Request.

To configure a GitHub Pull Request repository, follow steps 1-6 for GitHub Issues above, then proceed as follows.

1. Select: __GitHub Pull Requests__.
2. Click button: __Next >__. The next step "Pull Request Repository" appears.
3. Configure settings for the GitHub Pull Request repository:
	- Server: __http://github.com/knop-project/knop__.
	- Label: __knop-project/knop issues__ (auto-entered, but you can change it).
	- User ID: enter your __GitHub account__.
	- Password: enter your __GitHub password__.
	- Optionally check __Save Password__.
	- Click button: __Validate Settings__. Either an error or success message will appear at the top of the wizard.
	- If successful, click button: __Finish__.  A new window "Add new query" appears.
4. To display and work with the Pull Requests in the task repository, we need to create a query to find the issues.  When you first create a task repository, you will be prompted to create a query, so let's do that now.  Click the button __Yes__.  A new window "Edit Query" appears.
5. Configure your query.
	- Title: __Knop Project Pull Requests__.
	- Status: check both __Open__ and __Closed__.
	- Click button: __Finish__.
6. Select __Window > Show View > Other...__.
7. Filter: __task l__.
8. Select __Mylyn > Task List__.  The view "Task List" appears with your recently created query.
9. To open a Pull Request, double-click it in the Task List.

More Information
----------------
* [How to download and install EGit](http://www.eclipse.org/egit/download/)
* [EGit User Guide](http://wiki.eclipse.org/EGit/User_Guide)
* [EGit Tutorial for Beginners](http://unicase.blogspot.com/2011/01/egit-tutorial-for-beginners.html)
* [EGit Tutorials](http://wiki.eclipse.org/EGit/Learning_Material)
* [EGit/GitHub User Guide](http://wiki.eclipse.org/EGit/GitHub/UserGuide)
