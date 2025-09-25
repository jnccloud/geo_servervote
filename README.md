# geo_servervote

This script provides an optimized and easy way for your players to support your server. All logic is handled on the server to mitigate the risk of abuse, and is limited to one reward per FiveM license. Otherwise, you can customize `giveReward` for your framework as needed.

It was built for qbx_core, but supports license and license2. I am open to PRs building a bridge for nd-core, esx or other frameworks, but I am not interested in creating it myself.

Please don't change the name of the script so I can see how many people actually use it. :)

## Demo 

[![Demo](http://img.youtube.com/vi/I5X_LwFdKYg/0.jpg)](http://www.youtube.com/watch?v=I5X_LwFdKYg "geo_servervote demo")

## Dependencies
- qbx_core
- ox_lib
- oxmysql

## Installation
1. Ensure after all dependencies above
2. Sign up for an account at trackyserver.com
3. Create your server profile
4. Go to Account > My Servers > Edit
5. Copy your Tracky Server ID and secret key to `config/server.lua` in the specified areas
6. Start script and the database tables will be created automatically on first run

## Usage
- Players can use the `/vote` command to check if they have voted and claim their rewards.
- When a player votes, the script makes an API call to TrackyServer to verify the vote.
- If the vote is valid, the player receives a reward based on their license.
- The rewards are calculated based on the number of votes the player has made.
- The script also inserts the vote into the MySQL database for bonus tracking.

## Customization
- You can customize the rewards and bonus amounts in the `config/server.lua` file.
- You can modify the notification messages in the `notify` function.
- You can change the API endpoints and URLs in the `buildUrl` function. (don't touch)

## Credits
- This script was created by Castar and Geo City Roleplay.
- For support and more information, visit the [Geo City Roleplay Discord server](https://discord.gg/geocityrp).
- The idea for the script came from Murgator's `FiveM-vote-script`. But it is no longer maintained and I wanted a safer and modern vote script for TrackyServer.
- TrackyServer for providing a developer API

## License
This script is released under the [MIT License](https://opensource.org/licenses/MIT).
