git diff --cached --name-only | while read filename; do
    swiftlint autocorrect --path "$filename";
done