this branch uses the dev branch of discordia

# deps

## lit
```
lit install SinisterRectus/discordia creationix/coro-fs creationix/coro-split
```
## git
```
rm -rf deps/discordia; git clone https://github.com/SinisterRectus/Discordia.git -b dev deps/discordia
cd deps/discordia; git revert 21eb55f96e3c1f4eabace5d97e403dff2237afab; cd ../..

git clone https://github.com/Bilal2453/lit-vips.git deps/vips
curl https://raw.githubusercontent.com/lzubiaur/ini.lua/master/ini.lua -o deps/ini.lua
```
## required libraries
[vips](https://repology.org/project/vips/versions)