#!/bin/bash

STATUS=$(defaults read com.apple.finder | grep CreateDesktop | sed 's/[^0-9]//g')

if [ $STATUS == 0 ]
then
	defaults write com.apple.finder CreateDesktop -bool true
	killall Finder
else
	defaults write com.apple.finder CreateDesktop -bool false
	killall Finder
fi

