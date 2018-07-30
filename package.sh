#!/bin/bash

zip -r9 apidemo80.zip ./* -x tmp/\* models/\*.pyc .DS_Store \*.log \*.zip \*.old \*.out
