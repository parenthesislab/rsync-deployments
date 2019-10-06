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
sh -c "rsync -atu -e 'ssh -p 5956 -i $SSH_PATH/deploy_key -o StrictHostKeyChecking=no' --progress --delete --exclude=/_btcpayserver $GITHUB_WORKSPACE/container_build/. $LINODE_SRV_USER@$LINODE_SRV_HOST:$LINODE_SRV_PATH"
