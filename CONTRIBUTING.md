# Contributing guidelines

We welcome any kind of contribution to our software, from simple comment or question to a full fledged [pull request](https://help.github.com/articles/about-pull-requests/). 

A contribution can be one of the following cases:

1. you have a question;
1. you think you may have found a bug (including unexpected behavior);
1. you want to make some kind of change to the code base (e.g. to fix a bug, to add a new feature, to update documentation);
1. you want to make a new release of the code base.

The sections below outline the steps in each case.

## You have a question

1. use the search functionality [here](https://github.com/mitigation-controller/mitc/issues) to see if someone already filed the same issue;
1. if your issue search did not yield any relevant results, make a new issue;
1. apply the "Question" label; apply other labels when relevant.

## You think you may have found a bug

1. use the search functionality [here](https://github.com/mitigation-controller/mitc/issues) to see if someone already filed the same issue;
1. if your issue search did not yield any relevant results, make a new issue, making sure to provide enough information to the rest of the community to understand the cause and context of the problem. Depending on the issue, you may want to include:
    - make use of the bug report template;
    - the [SHA hashcode](https://help.github.com/articles/autolinked-references-and-urls/#commit-shas) of the commit that is causing your problem;
    - some identifying information (name and version number) for dependencies you're using;
    - information about the operating system;
1. apply relevant labels to the newly created issue.

## You want to make some kind of change to the code base

1. (**important**) announce your plan to the rest of the community *before you start working*. This announcement should be in the form of a (new) issue;
1. (**important**) wait until some kind of consensus is reached about your idea being a good idea;
1. if needed, fork the repository to your own Github profile and create your own feature branch off of the latest dev commit. While working on your feature branch, make sure to stay up to date with the dev branch by pulling in changes, possibly from the 'upstream' repository (follow the instructions [here](https://help.github.com/articles/configuring-a-remote-for-a-fork/) and [here](https://help.github.com/articles/syncing-a-fork/));
1. we make use of the Gitflow branching method, see [here](https://github.com/mitigation-controller/mitc/wiki/Branch-Management)
1. make sure the existing tests still work by running `run_tests.m`;
1. add your own tests (if necessary);
1. update or expand the documentation;
1. update the `CHANGELOG.md` file with change;
1. [push](https://docs.github.com/en/github/using-git/pushing-commits-to-a-remote-repository#pushing-tags) your feature branch to (your fork of) the MitC repository on GitHub;
1. create the pull request to the `dev` branch, e.g. following the instructions [here](https://help.github.com/articles/creating-a-pull-request/).

In case you feel like you've made a valuable contribution, but you don't know how to write or run tests for it, or how to generate the documentation: don't let this discourage you from making the pull request; we can help you! Just go ahead and submit the pull request, but keep in mind that you might be asked to append additional commits to your pull request.

## You want to make a new release of the code base

To create release you need write permission on the repository.

1. Create a release branch from the dev branch.
1. Check author list in `citation.cff` and `.zenodo.json` files
1. Follow the compiling and packaging steps described [here](https://github.com/mitigation-controller/mitc/wiki/Compile-and-package)
1. Update the `CHANGELOG.md` to include changes made
1. Follow the steps [here](https://github.com/mitigation-controller/mitc/wiki/Compile-and-package) to package and compile the application.
1. Goto [GitHub release page](https://github.com/mitigation-controller/mitc/releases)
1. Press draft a new release button
1. Fill version, title and description field
1. Press the Publish Release button

A Zenodo entry will be made for the release with its own DOI.

These contributing guidelines are based on the description in this [repository](https://github.com/matchms/matchms/blob/master/CONTRIBUTING.md)
