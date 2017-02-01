#!/bin/sh


RANDVAR=$(echo $RANDOM)
GEMENVIRNOM=""
ANSWER=""
PROMPT=""

defaultInstallRuby()
{
	printf "Performing default installation using system ruby\n"
	echo "Default location on MacOSX is /Library/Ruby/Gems/2.0.0"
	echo "gems will be installed at"
	GEMENVIRNOM=$(gem environment | sed -n '/GEM PATHS/{n;p;}' | cut -d'-' -f2)
	if [[ "$GEMENVIRNOM" = "" ]] ; then
		printf "\nIt looks like there is a nonstandard ruby configuration.\n"
		printf "Unfortunately, you will need to restart the jekyll installer,\n"
		printf "and select the customized install setup to install jekyll.\n"
		exit
	else
		echo $GEMENVIRNOM
		printf "\nYour password is now required to install the jekyll gem\n"
		sudo gem install jekyll bundler
	fi

}

setupAndInstallRBENV()
{
	echo "Ran RBENV Installer"
	brew update
	sleep 1
	brew install rbenv
	sleep 1
	rbenv install 2.2.6
	sleep 1
	rbenv init
	sleep 1
}

configureRBENV()
{
	if [[ -e ~/.bash_profile ]] ; then
		echo "Found .bash_profile, appending rbenv configuration to end of file"
	else
		echo "could not find .bash_profile"
		echo "creating new bash_profile file in home directory with" 
		echo "rbenv configuration appended to the end.  If you have a different"
		echo "configuration and do not use .bash_profile, "
		echo "delete this newly created file to undo changes" 
	fi
	echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
	echo "export RBENV_VERSION=2.2.6" >> ~/.bash_profile
	echo "export RBENV_ROOT=~/.rbenv" >> ~/.bash_profile
	echo "export RBENV_DIR=~/.rbenv/versions" >> ~/.bash_profile
}

customInstallRBENVandGems()
{
	echo "Testing Brew Installation"
	BREWTEST=$(which brew)
	if [[ "$BREWTEST" = "" ]] ; then 
		echo "It looks like homebrew is not installed."
		echo "You can install it from the website http://brew.sh"
		echo "If you are positive that it is installed and would like to continue,"
		read -p "press y, otherwise press n " USERPROMPT
		if [[ "$USERPROMPT" = "y" || "$USERPROMPT" = "Y" ]] ; then
			echo "Continuing installation"
			setupAndInstallRBENV
			configureRBENV
			source ~/.bash_profile
			sleep 1
			gem install jekyll bundler
			echo "Setup complete"
			echo "gem executables are at"
			which gem
			echo "gem home is"
			gem env home
			echo "jekyll help can be found at http://jekyllrb.com/docs/quickstart/"
			echo ""
			echo "Be sure to open a New terminal window, or type"
			echo "source ~/.bash_profile"
			echo "Exiting"
		else 
			echo "Exiting"
		fi
	else
		echo "Proceeding with installation"
		setupAndInstallRBENV
		configureRBENV
		source ~/.bash_profile
		RBCHK=$(which gem | cut -d'/' -f2) ; 
		if [[ "$RBCHK" = "usr" ]] ; then 
			echo "It looks like there may be an error in the installation,"
			echo "or a problem with the PATH.  Please check before proceeding" 
			echo "PATH is"
			echo $PATH
			echo "gems are currently seen at "
			which gem
			gem env home
		else
			gem install jekyll bundler
			echo "Finished Installation and Setup."
			echo "gems are installed at"
			gem env home
			echo "jekyll help can be found at "
			echo "http://jekyllrb.com/docs/quickstart/"
			echo "Remember to run source ~/.bash_profile"
			echo "or close and reopen the Terminal window"
			echo "Exiting"
		fi
	fi
}


echo "#####################"
echo "Welcome to Jekyll setup"
CUSTOMINSTALL="FALSE"
while [[ "$CUSTOMINSTALL" != "TRUE" ]] ; do
	printf "Would you like to do a default installation, or a custom installation?\n"
	printf "The default installation will use the system ruby, while a custom installation\nwill create a customized ruby setup with rbenv\n\n"
	printf "If you are not sure, it is STRONGLY recommended \nthat you select a default installation\n"
	read -p "Perform default installation? Y/n " ANSWER
	case "$ANSWER" in
		[Yy]) defaultInstallRuby
		exit
		;;
		[Nn]) read -p "Perform custom install? N/y " PROMPT
			if [[ "$PROMPT" = "Y" || "$PROMPT" = "y" ]] ; then CUSTOMINSTALL="TRUE" ; fi
			echo ""
		;;
		*) printf "Sorry, I did not recognize that.  Please try again"
		;;
	esac
done

customInstallRBENVandGems