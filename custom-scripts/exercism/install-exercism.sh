#! /bin/bash
# Syntax: ./install-clojure.sh [username]

USERNAME=${1:-"automatic"}

# If in automatic mode, determine if a user already exists, if not use vscode
if [ "${USERNAME}" = "auto" ] || [ "${USERNAME}" = "automatic" ]; then
    USERNAME=""
    POSSIBLE_USERS=("vscode" "node" "codespace" "$(awk -v val=1000 -F ":" '$3==val{print $1}' /etc/passwd)")
    for CURRENT_USER in ${POSSIBLE_USERS[@]}; do
        if id -u ${CURRENT_USER} >/dev/null 2>&1; then
            USERNAME=${CURRENT_USER}
            break
        fi
    done
    if [ "${USERNAME}" = "" ]; then
        USERNAME=vscode
    fi
elif [ "${USERNAME}" = "none" ]; then
    USERNAME=root
    USER_UID=0
    USER_GID=0
fi

# ** Shell customization section **
if [ "${USERNAME}" = "root" ]; then
    USER_RC_PATH="/root"
else
    USER_RC_PATH="/home/${USERNAME}"
fi

sudo wget https://github.com/exercism/cli/releases/download/v3.0.13/exercism-3.0.13-linux-x86_64.tar.gz
sudo tar -xf exercism-3.0.13-linux-x86_64.tar.gz
chmod +x exercism-3.0.13-linux-x86_64.tar.gz
sudo mkdir "${USER_RC_PATH}/bin"
sudo mv exercism "${USER_RC_PATH}/bin/"

# sudo apt-get update
# sudo DEBIAN_FRONTEND=noninteractive apt-get install -y snapd
# sudo snap install exercism
