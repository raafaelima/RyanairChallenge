# iOS Meetup Challenge App

## About the APP
The app is architected using the principles of SOLID and PACT, I believe that this is sufficient to get a clear understanding of the code and how to navigate through it. Also, the app is written in Swift 5.0 and iOS 13.0

In the app you will find the following structure:
* RyanairChallenge - All the app code is in there
* RyanairChallengeTests - All the Unit Tests
* RyanairChallengeUITests - All The UiTests

I'm using Fastlane to automate the tests and lint executions.
I use Carthage as a dependency manager and the following libraries are used to support:

3rd Party Libs
* FsCalendar

Tests
* Quick
* Nimble

## Getting Started
1. Mac OS X Sierra 10.12.6 or higher
2. Install [HomeBrew](http://brew.sh/)
3. Setup up the environment (be sure to fill the vars)
>
>```bash
># Needed for fastlane
>export LC_ALL=en_US.UTF-8
>export LANG=en_US.UTF-8
>```

4. make setup *
>
>```bash
>make setup
>```

  This will install the following tools (if not present)
  >
  >0. brew packages - python3, rbenv, carthage, python, git, swiftlint
  >0. ruby 2.4.2, bundler, gems referred in the Gemfile.lock
  >0. pip, xUnique


## Running

1. Run the tests

>
>```bash
>make test
>```

4. List all targets with documentation
>
>```bash
>make
>```

## References
[PACT](https://www.thoughtworks.com/pt/insights/blog/write-quality-mobile-apps-any-architecture)
