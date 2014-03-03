[![Code Climate](https://codeclimate.com/github/tmecklem/shipmate.png)](https://codeclimate.com/github/tmecklem/shipmate)

Shipmate is a tool to provide dedicated developers and QA professionals access to over the air installation for iOS and Android alpha and beta apps. It is similar to TestFlight, but with less group and access ceremony, and similar to a HockeyKit standalone installation with the exception that it's built on Rails and aims to provide a bit more functionality.

Differences from TestFlight:

* It requires no teams or permissions structure.
* It has no manual step to release builds to teams. Once a build is imported, it's available.
* It is privately deployable.
* It can import App Store signed builds for end-to-end testing of the same binary deliverable.

Differences from HockeyKit

* It provides more structured mobile device navigation based on app->release->build.
* It provides the means to install older build versions of the same release with minimal little hassle.
* It's not PHP.