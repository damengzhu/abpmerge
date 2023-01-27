#!/bin/sh

# 下载规则
curl -o i-1.txt https://raw.githubusercontent.com/damengzhu/banad/main/jiekouAD.txt
curl -o i-2.txt https://filters.adtidy.org/extension/ublock/filters/224.txt
curl -o i-3.txt https://raw.githubusercontent.com/o0HalfLife0o/list/master/ad.txt
curl -o i-4.txt https://code.gitlink.org.cn/damengzhu/filelink/raw/branch/master/easylistnocssrule.txt
curl -o i-5.txt https://raw.githubusercontent.com/o0HalfLife0o/list/master/ad-edentw.txt

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
echo "! Description: 该规则合并自jiekouAD，AdGuard中文语言规则，easylistnocssrule，乘风视频广告过滤规则、EasylistChina、EasylistLite、CJX'sAnnoyance，以及补充的一些规则，Adblock Warning Removal List、ABP filters、anti-adblock-killer-filters" >> i-tpdate.txt
echo "! Version: `date +"%Y-%m-%d %H:%M:%S"`" >> i-tpdate.txt
echo "! Total count: $num" >> i-tpdate.txt
cat i-tpdate.txt i-tmp.txt > abpmerge.txt

cat "abpmerge.txt" | grep \
-e "\(^\|\w\)#@\?#" \
-e "\(^\|\w\)#@\??#" \
-e "\(^\|\w\)#@\?\$#" \
-e "\(^\|\w\)#@\?\$?#" \
> "CSSRule.txt"

# 删除缓存
rm i-*.txt

#退出程序
exit
