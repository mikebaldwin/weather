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

### Attributions
* sun by asianson.design from the Noun Project
* Moon by asianson.design from the Noun Project
* weather by asianson.design from the Noun Project
* Cloud by asianson.design from the Noun Project
* Wind by Vitaliy Gorbachev from the Noun Project
