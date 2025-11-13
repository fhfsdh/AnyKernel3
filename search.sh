#!/bin/bash
# ==========================================================
#  copy-kernel.sh  ——  一键复制内核镜像到 AnyKernel3
#  支持 Image / Image.gz / Image.gz-dtb
#  路径必须同时包含 out 与 boot 两段
# ==========================================================

set -euo pipefail

# 目标目录（不存在则自动创建）
TARGET_DIR="$HOME/AnyKernel3"
mkdir -p "$TARGET_DIR" || { echo "[错误] 无法创建目标目录 $TARGET_DIR"; exit 1; }

echo "[搜索中] 正在搜索 路径含 out + boot 的 Image / Image.gz / Image.gz-dtb …"
mapfile -t IMAGE_FILES < <(
  find "$HOME" -maxdepth 15 -type f \( \
      -name "Image" -o \
      -name "Image.gz" -o \
      -name "Image.gz-dtb" \) 2>/dev/null \
  | awk '/\/out\// && /\/boot\//'
)

# 检查搜索结果
if [ ${#IMAGE_FILES[@]} -eq 0 ]; then
  echo "[错误] 未找到符合条件的文件"
  exit 0
fi

# 列出文件，用颜文字隔开不同目录
echo -e "\n[搜索结果] 找到以下文件："
prev_dir=""
for i in "${!IMAGE_FILES[@]}"; do
  curr_dir=$(dirname "${IMAGE_FILES[$i]}")
  [ "$curr_dir" != "$prev_dir" ] && [ $i -ne 0 ] && echo -e " \033[36m(｡•̀ᴗ-)✧\033[0m "
  echo "$((i+1)). ${IMAGE_FILES[$i]}"
  prev_dir="$curr_dir"
done

# 询问用户选择
echo -e "\n[注意] 选中文件会强制覆盖 ${TARGET_DIR}/Image（保留原名称）"
echo "请输入要复制的文件序号（1-${#IMAGE_FILES[@]}）："
read -r CHOICE

# 验证选择有效性
if ! [[ "$CHOICE" =~ ^[0-9]+$ ]] || [ "$CHOICE" -lt 1 ] || [ "$CHOICE" -gt ${#IMAGE_FILES[@]} ]; then
  echo "[错误] 无效序号，请输入 1 到 ${#IMAGE_FILES[@]} 之间的数字"
  exit 1
fi

# 强制复制（保留原名、属性，并覆盖）
SELECTED_FILE="${IMAGE_FILES[$((CHOICE-1))]}"
TARGET_FILE="$TARGET_DIR/$(basename "$SELECTED_FILE")"
echo -e "\n[执行中] 正在强制复制 ${SELECTED_FILE} 到 ${TARGET_FILE} …"
cp -fp "$SELECTED_FILE" "$TARGET_FILE" || { echo "[错误] 复制失败（无权限等原因）"; exit 1; }

echo -e "\n[成功] 强制复制成功！目标路径：${TARGET_FILE}"
