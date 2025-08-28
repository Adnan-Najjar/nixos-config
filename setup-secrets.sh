#!/usr/bin/env bash

set -e

set_private_key() {
	# Prompt for private key
	PRIVATE_KEY=$(zenity --file-selection --title="Select Private Key")

	# Make sure private key is not empty
	if [ -z "$PRIVATE_KEY" ]; then
		echo "No private key selected, aborting."
		exit 1
	fi

	gpg --import "$PRIVATE_KEY"
}

get_password-store() {
	# Decrypt using password
	GH_TOKEN=$(echo "jA0ECQMKIkZtNTt40J//0pMBQLd03ThKm8RQZwN3X2IVjs/yoZTmarQhGKdTxNxp8xG96F9aAmm7xQ1yvykwXbrsnqaqiZSl6zplsejfP5/ZkvXXc0X0Om46aHAeEQGkEDwEnFCW4jvLZ0jR72dLKGarogmtTJSvzzFAWkJpK34gruF2KlT+5ByNPlfIz30isHTHfBXMtvuyaSoNuf2ysA4b1oA=" |
		base64 --decode |
		gpg --decrypt 2>/dev/null)

	# Check if password is correct
	if [ -z "$GH_TOKEN" ]; then
		echo "Wrong password, aborting."
		exit 1
	fi

	GIT_URL="https://$GH_TOKEN@github.com/Adnan-Najjar/password-store.git"

	git clone "$GIT_URL" ~/.password-store
	pass init "$(cat ~/.password-store/.gpg-id)"
	mv ~/.password-store/.git* ~/.local/share/password-store
	pass git reset --hard origin/main
}

setup_gh() {
	pass api/git | gh auth login --with-token
}

# if private key is not set, set it
if ! gpg --list-secret-keys adnan; then
	set_private_key
fi
# if password-store is empty or passwords are not set, download and set it up
if [ ! -d ~/.password-store ]; then
	get_password-store
fi
# if gh not setup, set it up
if ! gh auth status 2>/dev/null && pass api/git 2>/dev/null; then
	setup_gh
fi
