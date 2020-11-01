#!/bin/bash
install_rustbuster() {
    echo "Installing latest version of Rustbuster"
    latest_version=`curl -s https://github.com/phra/rustbuster/releases | grep "rustbuster-v" | head -n1 | cut -d'/' -f6`
    echo "Latest release: $latest_version"
    mkdir -p /opt/rustbuster
    wget -qP /opt/rustbuster https://github.com/phra/rustbuster/releases/download/$latest_version/rustbuster-$latest_version-x86_64-unknown-linux-gnu
    ln -fs /opt/rustbuster/rustbuster-$latest_version-x86_64-unknown-linux-gnu /opt/rustbuster/rustbuster
    chmod +x /opt/rustbuster/rustbuster
    echo "Done! Try running"
    echo "/opt/rustbuster/rustbuster -h"
}

install_rustbuster
