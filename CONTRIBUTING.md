# CONTRIBUTING

## Code

- Code should generally conform to the [GitHub Objective-C Style Guide](https://github.com/github/objective-c-style-guide) which is based on [Apple's guidelines for Cocoa](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CodingGuidelines/CodingGuidelines.html).
- Code should not contain tab characters.
- Function definitions should have the opening brace on its own line.

## Git

- Commits should generally correspond one-to-one with a particular feature or bugfix. The first line of a commit should summarize the purpose of the commit, and additional details such as new dependencies or changes in application behavior should be explained in a following paragraph.
- If significant time has passed since branching, the commits should be rebased on top of master.
- CocoaPods should be committed to ensure availability and use of proper versions for other developers.

## Pull Requests

Pull requests should address a single feature/bug. Multiple features should each be self-contained in their own pull requests.