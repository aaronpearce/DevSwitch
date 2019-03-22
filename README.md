<p align="center">
    <img src="https://github.com/aaronpearce/DevSwitch-Private/blob/master/app-icon.png?raw=true" alt="Sublime's custom image"/>
</p>


DevSwitch for iOS
===============

DevSwitch is a developer utility that allows developers to switch their storefront to easily check their app's rankings, features and more. With a list of every storefront available, DevSwitch is the ultimate storefront switching app. Bookmark your apps to easily change a store then check their localisations, reviews and features.

Key Features:
- Siri Shortcuts
- Quick Actions
- Favoriting Storefronts
- URL Schemes for inter-app integration
- App Bookmarking

Follow me on Twitter at [@aaron_pearce](https://twitter.com/aaron_pearce).

Getting involved
----------------

Please feel free to participate in this open source project. I'd love to see Pull Requests, Bug Reports, ideas and any other positive contributions from the community!

Building the code
-----------------

1. Clone the repository:
    ```shell
    git clone https://github.com/aaronpearce/DevSwitch.git
    ```
2. Pull in the project dependencies:
    ```shell
    cd DevSwitch
    sh ./bootstrap.sh
    ```
3. Open `DevSwitch.xcworkspace` in Xcode.
4. Build the `DevSwitch` scheme in Xcode.

## Code Signing

1. After running the *bootstrap.sh* script in the setup instructions navigate to:
<br>`DevSwitch/Configuration/Local/DevTeam.xcconfig`
1. Add your *Apple Team ID* in this file:
<br>`LOCAL_DEVELOPMENT_TEAM = KL8N8XSYF4`

>Team IDs look identical to provisioning profile UUIDs, so make sure this is the correct one.

The entire `Local` directory is included in the `.gitignore`, so these changes are not tracked by source control. This allows code signing without making tracked changes. Updating this file will only sign the `DevSwitch` target for local builds.

### Finding Team IDs

The easiest known way to find your team ID is to log into your [Apple Developer](https://developer.apple.com) account. After logging in, the team ID is currently shown at the end of the URL:
<br>`https://developer.apple.com/account/<TEAM ID>`

Use this string literal in the above, `DevTeam.xcconfig` file to code sign

## Thanks

Thanks to everyone for their support in development and throughout the initial review process that failed and a particular thanks to [@kylehickinson](https://github.com/kylehickinson) for the suggestion to use Brave/Firefox's `.xcconfig` based setup for local development signing.

## Open Source & Copying

DevSwitch is licensed under MIT so that you can use any code in your own apps, if you choose.

However, **please do not ship this app** under your own account. Paid or free. Not that Apple will accept it.
