[![Scope](https://app.scope.dev/api/badge/b1d15c58-ccd4-4370-8663-b943fcf7e7ad/default)](https://app.scope.dev/external/v1/inspect/f0a213f0-b550-4bb0-a651-c1d5b9eff041/b1d15c58-ccd4-4370-8663-b943fcf7e7ad/default)

# ios-demo-app

Demo project for an iOS application.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for developing and testing purposes.

### Prerequisites

1. Download and configure Scope for Mac [here](https://app.scope.dev/local-dev/instructions).
2. Install Carthage if not already in the system following these [instructions](https://github.com/Carthage/Carthage#installing-carthage)

### Building

1. Clone repository
```bash
> git clone https://github.com/scope-demo-app/ios-demo-app.git
```

2. Access to cloned repository folder
```bash
> cd ios-demo-app
```

3. Build dependencies

```bash
> carthage update
```

4. Open `Hambourgeoisie.xcodeproj` with Xcode

### Running the tests

This project is already configured with Scope. You just need to run the tests from Xcode as normal. Alternatively you can run the tests from the command line using xcodebuild:

```bash
> xcodebuild test -scheme Hambourgeoisie -destination 'platform=iOS Simulator,name=iPhone 11'
```

### Reviewing the tests

After the tests run, you'll get a URL in the console with a direct link to the test results:

```bash
** Scope Test Report **
Access the detailed test report for this build at:
   https://shared.scope.dev/external/v1/results/a88da6e8-c817-450f-8542-340aa3143d0a
```

Alternatively, the `Scope for Mac` and `Scope for Windows` applications will also show recent runs. Clicking on these will take you directly to the test reports. 

To access these results from Scope, simply click on the [Scratchpad](https://app.scope.dev/local-dev/) section in the left-hand menu. You'll get a time-ordered list of local test runs. 

When reviewing the tests in Scope, filter by `demo` in the search bar to find the most interesting tests. Other tests, particularly those tagged as `dummy` may not contain useful, nor interesting information.

### Manual testing

The Scope Swift agent allows you to perform manual tests on your application that will be recorded for later troubleshooting in Scope. The app is already configured for this functionality.

After the application launches, a floating Scope logo will appear in the screen over your application elements. When you want to start a test, click on the logo and provide the test with a name.

While the test is being recorded, the Scope logo will be glowing in red. To finish the test and stop the recording, click on the logo, and choose whether the test passed or failed. 

Manual tests will appear in your **Local Development** section.



