Git and GitHub Installation and Configuration Guide
===================================================

Introduction
------------
The Knop Project relies upon git and GitHub for version control of source files and collaboration amongst its contributors.  Although one could merely download the files as a zip archive, one would lose any advantages of version control, specifically to be able to roll back or forward to any point in their repository.  This is especially useful when, for example, a new version of Knop is released and the developer wants to test it out, only to find that there is a bug in Knop or it breaks other components of their system.

The Knop Project uses the "fork and pull" model for collaboration.  Developers should fork the Knop Project into their own repository under their GitHub account, then clone their GitHub repository to their local development machine.  From there, the developer can make changes to the files, test, and, when satisfactory, push the changes to their GitHub repository.  At this point, the developer can submit a pull request to the Knop Project to review.

Installation and configuration
==============================
This section provides guidance for installing and configuring git, GitHub, and desktop git clients to work with *your* repository on GitHub.

If you already have installed and configured these items, then read the instructions on [how to use git and GitHub with the Knop Project repository](using_git_with_the_knop_project.md).

Requirements
------------
* GitHub account
* git
* git clients

Sign up for a free GitHub account
---------------------------------
[Sign up at GitHub](https://github.com/signup/free)

How to install and set up git with GitHub
-----------------------------------------
For information of how to install and set up git to work with GitHub, please visit the following link.

[set up git](https://help.github.com/articles/set-up-git)

After you have created a GitHub account, installed git, and optionally installed a git GUI client, you are ready to [work with the Knop Project](using_git_with_the_knop_project.md).

More information
----------------
GitHub provides some nifty tutorials to become familiar with their system and git.

[Create a repo](https://help.github.com/articles/create-a-repo)

[Using pull requests](https://help.github.com/articles/using-pull-requests)

Git Immersion is an excellent tutorial with more detail.

[Git Immersion](http://gitimmersion.com/)

###How to install and set up git in general

For extremely detailed information of installing git for various environments, the book Pro Git is an excellent resource and contains the following chapter.

[Pro Git: Getting Started Installing Git](http://git-scm.com/book/en/Getting-Started-Installing-Git)

This book also covers usage via the command line.

###git clients

There are dozens of git clients available to manage your git repositories, both commercial and open source.  When you install git, you have a command line client available.

Alternatively you may prefer a desktop GUI client.  Be advised that GUI clients may not have all the features provided by the command line git client.

For purely commercial licenses of desktop GUI clients for git, try searching the Internet and trying them out.  The Knop Project does not endorse or evaluate purely commercial products.

The following desktop clients have been used by Knop Project contributors.

####SourceTree

Atlassian provides SourceTree, a free Mac client for Git, Mercurial and SVN version control systems.  Requires Mac OS X 10.6+.

[SourceTree](http://www.sourcetreeapp.com/)

####SmartGit

Syntevo provides SmartGit with either a commercial or an open source license depending on your usage.  Since Knop is an open source project, you may use SmartGit to contribute to the project at no cost.

[SmartGit](http://www.syntevo.com/smartgit/)

####EGit

EGit is a plugin for Eclipse and Eclipse-based products, including [LassoLab from LassoSoft](http://www.lassosoft.com/LassoLab).  Eclipse, LassoLab, and EGit are all available at no cost.  Eclipse and LassoLab are both integrated development environments (IDE) for writing, testing, and debugging code.  In addition plugins can be installed to add features and improve your project workflow.

Please see the Knop Project documentation [How to install and configure the EGit plugin for Eclipse (and LassoLab) to work with the Knop Project on GitHub](using_egit_with_the_knop_project.md).

####Other desktop clients

[Other desktop clients](http://git-scm.com/downloads/guis)

Conclusion
==========
Now that you have a GitHub account, installed git, and optionally installed a git GUI client, you are ready to work with the Knop Project, either by using [git](using_git_with_the_knop_project.md) or [EGit in Eclipse/LassoLab](using_egit_with_the_knop_project.md).