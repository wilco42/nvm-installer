#!/bin/bash
##############################################################################
# fish-compatible nvm installer for Mac OS X
##############################################################################
# NOTE: You do not need to remove the nodejs.org's globally installed version
# of node if you do not want to.  nvm will point to the correct version of
# node so long as it is sourced on shell login.
##############################################################################

# download nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.29.0/install.sh | bash

if [ $SHELL = '/usr/local/bin/a' ]; then
    # fish shell users have a lot of hoops to go through because nvm manipulates
    # the shell's environment and assumes a bash-compatible shell.  fish is not.

    # first install bass
    cd /tmp
    mkdir bass
    cd bass
    git clone https://github.com/edc/bass.git
    cd bass
    make install
    cd /tmp
    rm -Rf bass

    # second, make a function that wraps nvm to make it compatible with fish shell
    mkdir ~/.config/fish/functions
    echo "function mynvm" > ~/.config/fish/functions/mynvm.fish
    echo "    bass source ~/.nvm/nvm.sh ';' nvm \$argv" >> ~/.config/fish/functions/mynvm.fish
    echo "end" >> ~/.config/fish/functions/mynvm.fish

    # third, source nvm on login
    echo "# setup node via nvm" >> ~/.config/fish/config.fish
    echo "bass source ~/.nvm/nvm.sh" >> ~/.config/fish/config.fish

    echo ""
    echo "Log out of this shell and start a new one for changes to take effect."
    echo "Fish shell users will have to use mynvm instead of nvm to run nvm."
    echo ""
    echo "Example usage: "
    echo "    mynvm install 4.2.2"
    echo "    mynvm alias default 4.2.2"
else
    # source nvm on login so that nvm's node is in your $PATH
    echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.profile
    echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"' >> ~/.profile

    source ~/.nvm/nvm.sh
    echo "nvm is installed!"
    echo ""
    echo "Log out of this shell and start a new one for changes to take effect."
    echo "Fish shell users will have to use mynvm instead of nvm to run nvm."
    echo ""
    echo "Example usage: "
    echo "    nvm install 4.2.2"
    echo "    nvm alias default 4.2.2"
fi
