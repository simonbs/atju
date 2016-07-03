# Atju

iOS app for viewing pollen readings from DMI. The application alerts the user whenever new pollen readings are available.

![](https://raw.githubusercontent.com/simonbs/atju/master/screenshot.jpg)

## Backend

The application depends on the [atju-backend](https://github.com/simonbs/atju-backend) to receive data.
The backend is a simple node application that polls for pollen readings from DMI every fifteen minute and stores the readings in a database.
Follow the instructions in the README of the [atju-backend](https://github.com/simonbs/atju-backend) repository to get started.

## Installation

There's a few simple configurations that must be made in order to run the app.

- Configure and run the [atju-backend](https://github.com/simonbs/atju-backend). See the README in the repository for more information.
- Copy `Atju/Config/AtjuConfig.example.plist` to `Atju/Config/AtjuConfig.plist` and enter the URL on which the backend can be reached.
- If you wish to receive a notification whenever new pollen readings are available, create and configure your application on Urban Airship and copy `Atju/Config/AirshipConfig.example.plist` to `Atju/Config/AirshipConfig.plist` and enter the necessary keys.

You'll also need to do whatever configurations you normally do when running an iOS app, e.g. configure bundle ID and whatever.
