ROOT="$(
  cd -- "$(dirname "$0")" || exit 1 >/dev/null 2>&1
  pwd -P
)"

shaders=('Universe' 'Space')

for shader in "${shaders[@]}"; do
  /usr/lib/qt6/bin/qsb --qt6 -o "${ROOT}/${shader}.frag.qsb" "${ROOT}/${shader}.frag"
done
