: "${PLUGIN_README:=README.md}"

plugin::help() {
  cat << 'EOF'
template:

  PLUGIN_NAME=plugin
  PLUGIN_README=README.md # default

usage:

  release   generate readme, merge changelog, commit, tag and push

EOF
}

plugin::release() {
  # shellcheck disable=SC1090
  source "${PLUGIN_NAME}.bash"
  cat <<EOF > "${PLUGIN_README}"
# ${PLUGIN_NAME}
$(jq -r '[.info, .homepage] | join("\n\n")' plugin.json)

\`\`\`
$("${PLUGIN_NAME}::help")
\`\`\`
EOF
  changelog::merge
  git add .
  local version
  version="$(semver::read)"
  git commit -m "Release ${version}"
  git push
  git tag "${version}"
  git push --tags
}
