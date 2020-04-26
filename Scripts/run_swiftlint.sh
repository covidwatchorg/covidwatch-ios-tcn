#!/bin/zsh

# check to make sure were in the right directory, print error if not found,
# this is intentionally not using any Xcode build variables
# so that it can be run locally for debugging from the repo root.
[ -d "CovidWatch iOS" ] || echo "error: No 'CovidWatch iOS' directory found. Are you running this from the repo root?"

# github actions are run as runner
if [[ "$USER" == "runner" ]]
then
    echo "warning: CI system detected - skipping swiftlint"
else
    Pods/SwiftLint/swiftlint --strict --config .swiftlint.yml
fi


