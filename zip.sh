#!/bin/bash

# 默认压缩包名称
zip_name="build"

# 询问用户是否自定义压缩包名称
read -p "（´・ω・） 是否需要自定义压缩包名称？(y/n，默认n)：" custom_name
if [[ "$custom_name" == "y" || "$custom_name" == "Y" ]]; then
    read -p "（｡◕‿◕｡） 请输入自定义压缩包名称（无需后缀）：" input_name
    # 若用户输入不为空，则使用自定义名称
    if [[ -n "$input_name" ]]; then
        zip_name="$input_name"
    fi
fi

# 拼接完整压缩包文件名（带.zip后缀）
full_zip_name="${zip_name}.zip"

# 递归高压缩比打包，排除指定文件/目录（排除列表保持不变）
zip -r9 "$full_zip_name" * -x .git README.md *placeholder  *.bak *.zip zip.sh search.sh

echo -e "\n（ﾉ>ω<）ﾉ 打包完成！生成文件：$full_zip_name"
