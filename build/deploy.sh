#!/bin/bash

#
# Manually runs a build operation to deploy Estrella on the Luxanna server.
# This can only run if you have SSH Keys setup to connect to the Luxanna server. This can only be granted / setup with
# Aiga! So check with him how to set it up. Continuous integration may be set up again in the future like it was on
# the Maidens, but for now this is not a priority.
#

# On Luxanna, stop any processes that are currently running Estrella.
echo "Stop any bot processes that may currently be running."
echo "--------------------------------------"
echo "pm2 stop estrella;"
ssh aigachu@aigachu.com 'pm2 stop estrella;'
echo "--------------------------------------"

# On Luxanna, clone repository if not present.
# Generate ssh key for aigachu user and put it in github.
echo "Clone repository if not present."
echo "--------------------------------------"
echo "cd apps; git clone git@github.com:Aigachu/Estrella.git"
ssh aigachu@aigachu.com 'cd apps; git clone git@github.com:Aigachu/Estrella.git'
echo "--------------------------------------"

# On Luxanna, prune origin first.
echo "Prune origin."
echo "--------------------------------------"
echo "cd apps/Estrella; git remote prune origin;"
ssh aigachu@aigachu.com 'cd apps/Estrella; git remote prune origin;'
echo "--------------------------------------"

# On Luxanna, perform a git reset to make sure we're working with a clean version of the repo.
echo "Reset codebase."
echo "--------------------------------------"
echo "cd apps/Estrella/; git reset --hard;"
ssh aigachu@aigachu.com 'cd apps/Estrella; git reset --hard;'
echo "--------------------------------------"

# On Luxanna, checkout the master branch.
echo "Checkout the master branch."
echo "--------------------------------------"
echo "cd apps/Estrella; git checkout master;"
ssh aigachu@aigachu.com 'cd apps/Estrella; git checkout master;'
echo "--------------------------------------"

# On Luxanna, pull latest changes.
echo "Pull latest changes."
echo "--------------------------------------"
echo "cd apps/Estrella; git pull;"
ssh aigachu@aigachu.com 'cd apps/Estrella; git pull;'
echo "--------------------------------------"

# On Luxanna, re-install node libraries.
echo "Re-install node libraries."
echo "--------------------------------------"
#echo "cd apps/Estrella/app; rm -rf node_modules;"
#ssh aigachu@aigachu.com 'cd apps/Estrella/app; rm -rf node_modules;'
echo "cd apps/Estrella/app; npm install;"
ssh aigachu@aigachu.com 'cd apps/Estrella/app; npm install;'
echo "--------------------------------------"

# Copy local bots folder to server.
echo "cd apps/Estrella/lavenza; rm -rf bots;"
ssh aigachu@aigachu.com 'cd apps/Estrella/lavenza; rm -rf bots;'
echo "scp -r ../lavenza/bots aigachu@aigachu.com:~/apps/Estrella/lavenza"
scp -r ../lavenza/bots aigachu@aigachu.com:~/apps/Estrella/lavenza
echo "--------------------------------------"

# Summon the bots using PM2.
# PM2 will automatically restart the bots if they crash, but only a maximum of 15 times.
echo "Summoning bots..."
echo "--------------------------------------"
echo "cd apps/Estrella; pm2 start summon.js --name=estrella;"
ssh aigachu@aigachu.com 'cd apps/Estrella/app; pm2 start summon.js --name=lavenza'
echo "--------------------------------------"
echo "Script is done executing!"