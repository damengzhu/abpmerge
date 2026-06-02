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
cat i-mergd.txt | grep -v '^!' | grep -v '^！' | grep -v '^# ' | grep -v '^\[' | grep -v '^\【' > i-tmpp.txt
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

# --- 新增：合并三个中文规则为 chineseabpmerge.txt ---
curl -o chn-1.txt https://raw.githubusercontent.com/AdguardTeam/FiltersRegistry/master/filters/filter_224_Chinese/filter.txt
curl -o chn-2.txt https://raw.githubusercontent.com/lingeringsound/adblock_auto/main/base/%E5%85%B6%E4%BB%96.prop
curl -o chn-3.txt https://raw.githubusercontent.com/damengzhu/banad/refs/heads/main/jiekouAD.txt

# 合并中文规则并去除注释和空行
cat chn-*.txt | grep -v '^!' | grep -v '^！' | grep -v '^# ' | grep -v '^\[' | grep -v '^\【' | sort -n | uniq > chn-tmp.txt

# 计算中文规则数
chn_num=`cat chn-tmp.txt | wc -l`

# 添加标题头
echo "[Adblock Plus 2.0]" > chn-tpdate.txt
echo "! Title: Chinese ABP Merge Rules" >> chn-tpdate.txt
echo "! Description: 该规则合并自AdGuard中文语言规则、10007自用规则、jiekouAD规则" >> chn-tpdate.txt
echo "! Homepage: https://github.com/damengzhu/abpmerge" >> chn-tpdate.txt
echo "! Version: `TZ=UTC-8 date +"%Y-%m-%d %H:%M:%S"`" >> chn-tpdate.txt
echo "! Total count: $chn_num" >> chn-tpdate.txt

# 生成最终文件
cat chn-tpdate.txt chn-tmp.txt > chineseabpmerge.txt

# 清理中文规则临时文件
rm chn-*.txt chn-tmp.txt chn-tpdate.txt
# --- 中文规则合并结束 ---

# 获取规则文件并将其存储在内存中
EASYLIST=$(wget -q -O - https://easylist-downloads.adblockplus.org/easylist.txt)

# 移除包含 # 或 generichide 的行
echo "$EASYLIST" | grep -v "#" | grep -v "generichide" > EasyListnoElementRules.txt

# 将 EasyListnoElementRules.txt 复制到存储库中
cp EasyListnoElementRules.txt /path/to/repository/

# 删除缓存
rm i-*.txt

# 退出程序
exit
