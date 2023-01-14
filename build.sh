#!/bin/bash
CUR_DIR=$(dirname $(readlink -f $0))
# 保证你的build.sh脚本有任何错误就退出
set -e
# 保证你的字符集正确，如果是英文写en_US.UTF-8，如果是中文写zh_CN.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
# NODEJS_BIN_LATEST: 最新版本，建议使用它。
# NODEJS_BIN_V{majer}: 我们会在该版本退出Node的LTS维护期时进行删除。
# 目前有: NODEJS_BIN_V6, NODEJS_BIN_V8, NODEJS_BIN_V10
#
# 添加下一行保证能够找到正确的Node和npm，以及yarn命令。
export PATH=$NODEJS_BIN_LATEST:$YARN_BIN_LATEST:$PATH
# 添加下一行保证能够找到你使用npm install安装的工具（当然你如果使用npx，就不需要这一行）
export PATH=$(npm bin):$PATH
# 编译日志中打印Node和npm的版本。
echo "node: $(node -v)"
echo "npm: v$(npm -v)"
# 如果NODE_ENV为production, npm5以上版本就不会安装devDependencies。
# 所以，你先把它设置为development，保证你的devDependencies依赖也会被安装。
NODE_ENV=development npm install
# 为生产环境构建加NODE_ENV=production.
# webpack, babel等工具会使用这个环境变量来决定会不会优化，所以再设置成production。
NODE_ENV=production npm run build
#export http_proxy=cq02-spi-junheng2-bak121.cq02:8012
#export https_proxy=cq02-spi-junheng2-bak121.cq02:8012
#npm config set registry http://registry.npm.baidu.com
#npm config set proxy http://cq02-spi-junheng2-bak121.cq02:8012
#npm config set https-proxy http://cq02-spi-junheng2-bak121.cq02:8012
npm config set registry http://registry.npm.baidu-int.com
npm install
NODE_ENV=development npm run build
tar czf dist.tar.gz dist/
mkdir output
cp dist.tar.gz output