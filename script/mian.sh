#!/bin/sh

# 下载规则
curl -o i-1.txt https://raw.githubusercontent.com/damengzhu/banad/refs/heads/main/jiekouAD.txt
curl -o i-2.txt https://raw.githubusercontent.com/AdguardTeam/FiltersRegistry/master/filters/filter_224_Chinese/filter.txt
curl -o i-3.txt https://raw.githubusercontent.com/damengzhu/abpmerge/main/EasyListnoElementRules.txt
curl -o i-4.txt https://raw.githubusercontent.com/lingeringsound/adblock_auto/main/base/%E5%85%B6%E4%BB%96.prop
curl -o i-5.txt https://raw.githubusercontent.com/lingeringsound/adblock_auto/main/base/%E5%8F%8DAdblock.prop
curl -o i-6.txt https://raw.githubusercontent.com/cjx82630/cjxlist/master/cjx-annoyance.txt
curl -o i-7.txt https://easylist-downloads.adblockplus.org/easylistchina.txt
curl -o i-8.txt https://easylist-downloads.adblockplus.org/antiadblockfilters.txt

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
echo "! Description: 该规则合并自jiekouAD，AdGuard中文语言规则，10007自用规则，EasyList no Element Rules，EasylistChina，CJX'sAnnoyance，Adblock Warning Removal List" >> i-tpdate.txt
echo "! Homepage: https://github.com/damengzhu/abpmerge" >> i-tpdate.txt
echo "! Version: `TZ=UTC-8 date +"%Y-%m-%d %H:%M:%S"`" >> i-tpdate.txt
echo "! Total count: $num" >> i-tpdate.txt
cat i-tpdate.txt i-tmp.txt > abpmerge.txt

cat "abpmerge.txt" | grep \
-e "\(^\|\w\)#@\?#" \
-e "\(^\|\w\)#@\??#" \
-e "\(^\|\w\)#@\?\$#" \
-e "\(^\|\w\)#@\?\$?#" \
> "CSSRule.txt"


# 获取规则文件并将其存储在内存中
EASYLIST=$(wget -q -O - https://easylist-downloads.adblockplus.org/easylist.txt)

# 移除包含 # 或 generichide 的行
echo "$EASYLIST" | grep -v "#" | grep -v "generichide" > EasyListnoElementRules.txt

# 将 EasyListnoElementRules.txt 复制到存储库中
cp EasyListnoElementRules.txt /path/to/repository/


# 删除缓存
rm i-*.txt

#退出程序
exit

