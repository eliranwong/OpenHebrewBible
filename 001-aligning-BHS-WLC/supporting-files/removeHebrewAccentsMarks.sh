#! /usr/bin/sed -E -i .bak -f
#deal with Hebrew characters in A materials
s/[\֑\֒\֓\֔\֕\֖\֗\֘\֙\֚\֛\֜\֝\֞\֟\֠\֡\֣\֤\֥\֦\֧\֨\֩\֪\֫\֬\֭\֮\ֽ\ׄ\ׅ\‍\‪\‬\̣\ְ\ֱ\ֲ\ֳ\ִ\ֵ\ֶ\ַ\ָ\ֹ\ֺ\ֻ\ׂ\ׁ\ּ\ֿ\ \(\)\[\]\*\־\׀\׃\׆]//g
#check the following line, use it only if necessary
#s/[שׂשׁ]/ש/g
