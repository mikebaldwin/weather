# Weather README
### Getting an API Key
* Visit [Dark Sky](https://darksky.net/dev)
* Click “Sign Up” button.
* Enter your email address and a new password.
* Once you’re logged in, click the “Console” button in the navigation, if you aren’t automatically directed there.
* Copy your secret key.

### Adding your secret key to the API router
* In Xcode, open Weather > API > ForecastRouter.swift
* The apiKey is defined on line 15. Replace the string literal with your secret key from your Dark Sky account. It should look something like this:
`static let apiKey = “2c8e2d3d4cf1360a04149677b746cb17”`

### Simulating a location in the simulator
Note that if you're launching the app from the simulator, you'll need to simulate a location. 

You'll know for sure that no location is set if the app launches to the main summary view is missing a large icon showing the weather conditions and the interface reads "It's sunny and 80º." 

To simulate a location, select Debug > Simulate Location to select a location.

Development note: If I were to continue developing this project, adding an informative empty state to the summary view would be my next priority.

### Attributions
* sun by asianson.design from the Noun Project
* Moon by asianson.design from the Noun Project
* weather by asianson.design from the Noun Project
* Cloud by asianson.design from the Noun Project
* Wind by Vitaliy Gorbachev from the Noun Project
