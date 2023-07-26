# Instructor Repos
This directory is used for cloning other repos as submodules. These repos will usually be ACG instructors that put some code on github to test with.

## Working with submodules
The other repos are cloned in using git's submodule function. The quick references below are from the [Git - Submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules#:~:text=Submodules%20allow%20you%20to%20keep,and%20keep%20your%20commits%20separate.) webpage. Refer to the webpage to understand better and see more commands than just the basics below.

- To add a repo/submodule:
    - `git submodule add [URL]`
    - Note when you go into the submodule git is acting like you are in that repo.
- Note there is a `.gitmodules` file in the main git repo's root
- If you clone the main repo, the submodules' code will not be added. Just a directory representing the repo/submodule.
- If you want the submodules too, do the following commands to download the repo/code
    - `git submodule init`
    - `git submodule update`