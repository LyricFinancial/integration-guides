# Lyric Integration Guides 

The project contains the documentation for the Lyric system as well as demo projects that utilize the Lyric APIs and services.  Documentation can be found [here](http://dev-docs.lyricfinancial.com/).

This project has a dev branch as well as a master branch.  Changes should be made in dev first, and then once approved, moved to the master branch.  The master branch will produce the documentation and client apps that vendors will be using.  The documentation and apps are deployed using codeship.

### Dev
* [Documentation](http://dev-docs.lyricfinancial.com/)
* [Client Apps](http://dev-vatm-demo.lyricfinancial.com/#/demo-server)

### Master
* [Documentation](http://docs.lyricfinancial.com/)
* [Client Apps](http://vatm-demo.lyricfinancial.com/#/demo-server)

## Documentation

The documentation is built using [daux.io](http://daux.io/index).  At the root of the documentation folder, run grunt and a new window will open with the site.  Any changes you make to the doc files will be visible in your browser once you refresh.

    grunt

## Angular Apps

At the root of the lyric-vendor-demo app, you'll need to install the dependencies and build dependencies.

    npm install
    bower install

To make it so changes will show up just by refreshing your browser, run

    grunt watch

In a new window, start the app by running

    fig up dev

Make changes then check them into the dev branch first.