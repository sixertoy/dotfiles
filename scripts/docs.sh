# ##############################
#
# Markdown
#
# ##############################
rm -rf ./build/guidelines
# @see https://www.npmjs.com/package/gh-markdown-cli
# npm install gh-markdown-cli -g
mdown --input "./src/**/*.md" --output "./build/" --header "./assets/md_header.html" --footer "./assets/md_footer.html"

# @see https://www.npmjs.com/package/generate-github-markdown-css
cp ./assets/github-markdown.css ./build/github-markdown.css
cp ./assets/styles.css ./build/styles.css

exit 0
