#!/bin/sh

# 下载规则
curl -o i-1.txt https://raw.githubusercontent.com/damengzhu/banad/main/jiekouAD.txt
curl -o i-2.txt https://filters.adtidy.org/extension/ublock/filters/224.txt
curl -o i-3.txt https://raw.githubusercontent.com/o0HalfLife0o/list/master/ad.txt
curl -o i-4.txt https://raw.githubusercontent.com/damengzhu/abpmerge/main/easylistnocssrule.txt

# 合并规则并去除重复项
cat i*.txt > i-mergd.txt
cat i-mergd.txt | grep -v '^!' | grep -v '^！' | grep -v '^# ' | grep -v '^# ' | grep -v '^\[' | grep -v '^\【' > i-tmpp.txt
sort -n i-tmpp.txt | uniq > i-tmp.txt

python rule.py i-tmp.txt

# 计算规则数
num=`cat i-tmp.txt | wc -l`

# 添加标题和时间
echo "[Adblock Plus 2.0]" >> i-tpdate.txt
echo "! Title: ABP Merge Rules" >> i-tpdate.txt
echo "! Description: 该规则合并自jiekouAD，AdGuard中文语言规则，easylistnocssrule，乘风视频广告过滤规则、EasylistChina、EasylistLite、CJX'sAnnoyance，以及补充的一些规则" >> i-tpdate.txt
echo "! Version: `date +"%Y-%m-%d %H:%M:%S"`" >> i-tpdate.txt
echo "! Total count: $num" >> i-tpdate.txt
echo "! home page: https://github.com/damengzhu/abpmerge" >> i-tpdate.txt
cat i-tpdate.txt i-tmp.txt > abpmerge.txt

cat "abpmerge.txt" | grep \
-e "\(^\|\w\)#@\?#" \
-e "\(^\|\w\)#@\??#" \
-e "\(^\|\w\)#@\?\$#" \
-e "\(^\|\w\)#@\?\$?#" \
> "CSSRule.txt"

# 从 https://easylist-downloads.adblockplus.org/easylist.txt 下载 easylist.txt 文件
# 移除包含 # 或 generichide 的行，然后生成 easylistnocssrule.txt 的修改版本到当前工作目录。

# 获取 easylist.txt 文件并将其存储在内存中
EASYLIST=$(wget -q -O - https://easylist-downloads.adblockplus.org/easylist.txt)

# 移除包含 # 或 generichide 的行
echo "$EASYLIST" | grep -v "#" | grep -v "generichide" | grep -v "domain" > easylistnocssrule.txt

# 将 easylistnocssrule.txt 复制到存储库中
cp easylistnocssrule.txt /path/to/repository/


# 删除缓存
rm i-*.txt

#退出程序
exit
