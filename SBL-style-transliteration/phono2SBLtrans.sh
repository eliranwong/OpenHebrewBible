#! /usr/bin/sed -E -i .bak -f
s/ʔ/ʾ/g
s/(bb|b|v)/b/g
s/(gg|g|ḡ)/g/g
s/(dd|d|ḏ)/d/g
s/h/h/g
s/(ww|w)/w/g
s/(zz|z)/z/g
s/ḥ/ḥ/g
s/ṭ/ṭ/g
s/(yy|y)/y/g
s/(kk|k|ḵ)/k/g
s/(ll|l)/l/g
s/(mm|m)/m/g
s/(nn|n)/n/g
s/(ss|s)/s/g
s/ʕ/ʿ/g
s/(p|f)/p/g
s/(ṣṣ|ṣ)/ṣ/g
s/(qq|q)/q/g
s/(rr|r)/r/g
s/(šš|š|ŝ)/š/g
s/(śś|ś)/ś/g
s/(tt|t|ṯ)/t/g
s/(a|ₐ)/a/g
s/ᵃ/ă/g
s/ā/ā/g
s/āh/âh/g
s/o/o/g
s/ᵒ/ŏ/g
s/e/e/g
s/ê/êy/g
s/eʸ/êy/g
s/ē/ē/g
s/ᵉ/ĕ/g
s/î/î/g
s/i/i/g
s/ō/ō/g
s/ô/ô/g
s/u/u/g
s/ᵊ/ĕ/g
s/û/û/g
s/ʸ/y/g
# long hireq
s/iy/īy/g
# clear marks / accents
s/\-//g
s/ \. / /g
s/\[//g
s/\]//g
s/\*//g
s/\ˈ//g
s/\ˌ//g
# clear redundant space
s/    / /g
s/   / /g
s/  / /g
