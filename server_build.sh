#!/usr/bin/zsh

cd ./server_build

echo "------------------------"
echo "---Removing old Files---"
echo "------------------------"

rm -rf ./minetest

echo "-----------------------"
echo "---Cloning Minetest---"
echo "-----------------------"

git clone --depth 1 git@github.com:minetest/minetest.git

echo "-------------------------"
echo "---Cloning IrrlichtMt---"
echo "-------------------------"

git clone --depth 1 git@github.com:minetest/irrlicht.git minetest/lib/irrlichtmt && cd minetest

echo "-----------------------"
echo "---Building Minetest---"
echo "-----------------------"

cd minetest

cmake . -DRUN_IN_PLACE=TRUE -DBUILD_SERVER=TRUE -DBUILD_CLIENT=FALSE
make -j$(nproc)