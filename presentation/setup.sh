#!/bin/bash

# view output file
alias v="bash scripts/view.sh"

# remove rubbr files
alias clean="bash scripts/clean.sh"

# total rebuild
alias r="clean; rubbr; v"

# quick rebuild
alias q="rubbr; v"

# use ruby-1.8
rvm use system

# perform clean run on setup
bash scripts/clean.sh
rubbr
