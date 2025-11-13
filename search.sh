#!/bin/bash
set -euo pipefail

echo "[搜索中] 正在搜索 路径含 out + boot 的内核镜像…"
mapfile -t IMAGE_FILES < <(
  find "$HOME" -maxdepth 15 -type f \( -name "Image" -o -name "Image.gz" -o -name "Image.gz-dtb" \) 2>/dev/null \
  | awk '/\/out\// && /\/boot\//'
)

[ ${#IMAGE_FILES[@]} -eq 0 ] && { echo "[错误] 未找到符合条件的文件"; exit 0; }

echo -e "\n[搜索结果] 找到以下文件："
prev_dir=""
for i in "${!IMAGE_FILES[@]}"; do
  curr_dir=$(dirname "${IMAGE_FILES[$i]}")
  [ "$curr_dir" != "$prev_dir" ] && [ $i -ne 0 ] && echo -e " \033[36m(｡•̀ᴗ-)✧\033[0m "
  echo "$((i+1)). ${IMAGE_FILES[$i]}"
  prev_dir="$curr_dir"
done

echo -e "\n[注意] 选中文件会强制覆盖当前目录对应文件（保留原名称）"
echo "请输入要复制的文件序号（1-${#IMAGE_FILES[@]}）："
read -r CHOICE

if ! [[ "$CHOICE" =~ ^[0-9]+$ ]] || [ "$CHOICE" -lt 1 ] || [ "$CHOICE" -gt ${#IMAGE_FILES[@]} ]; then
  echo "[错误] 无效序号，请输入 1 到 ${#IMAGE_FILES[@]} 之间的数字"
  exit 1
fi

SELECTED_FILE="${IMAGE_FILES[$((CHOICE-1))]}"
echo -e "\n[执行中] 正在复制 ${SELECTED_FILE} 到当前目录…"
cp -fp "$SELECTED_FILE" "./" || { echo "[错误] 复制失败（无权限等原因）"; exit 1; }

echo -e "\n[成功] 复制完成！目标路径：$(pwd)/$(basename "$SELECTED_FILE")"
