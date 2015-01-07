[![Code Climate](https://codeclimate.com/github/tmecklem/shipmate.png)](https://codeclimate.com/github/tmecklem/shipmate) [![Build Status](https://travis-ci.org/tmecklem/shipmate.png?branch=develop)](https://travis-ci.org/tmecklem/shipmate)

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

Getting Started
===============

One click heroku deploy
-----------------------
[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

Manual setup
------------

* Check out the code from github
* run bundle install
* set up the import cron job: bundle exec whenever -w
* run rails s
* add your apk or ipa files to public/import/

How does Shipmate work?
=======================

Shipmate analyzes iOS ipa and Android apk files dropped into public/import by reading the application structure within the files. It uses the internal structure to build up a corresponding filesystem. When you load the shipmate webapp in a mobile browser, it identifies your platform and gives sideload access to imported apps.
