# Install Brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# Install Swiftlint
brew install swiftlint

git diff --cached --name-only | while read filename; do
    swiftlint autocorrect --path "$filename";
done