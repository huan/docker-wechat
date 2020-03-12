# 1.2.3
# 2.3.4
function isRelease () {
  minor=$(echo $1 | cut -d. -f2)
  mod2=$((minor%2))

  # echo "isRelease: $1 minor $minor release $release"
  return "$mod2"
}
