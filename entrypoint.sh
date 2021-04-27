#!/bin/sh

set -eu

# Set deploy key
SSH_PATH="$HOME/.ssh"
mkdir "$SSH_PATH"
echo "$DEPLOY_KEY" > "$SSH_PATH/deploy_key"
chmod 600 "$SSH_PATH/deploy_key"


# Move code to build folder
sh -c "rsync -avz --exclude-from rsync-exclude.txt --delete --delete-excluded . $GITHUB_WORKSPACE/container_build"

# Deploy to Linode Server
sh -c "rsync -atu -e 'ssh -p $APP_SRV_SSH_PORT -i $SSH_PATH/deploy_key -o StrictHostKeyChecking=no' --progress --delete --exclude=/.env.prod.local $GITHUB_WORKSPACE/container_build/. $APP_SRV_USER@$APP_SRV_HOST:$APP_SRV_PATH"
