#!/usr/bin/zsh

cd ./server_build

echo "-----------------------"
echo "---Updating Minetest---"
echo "-----------------------"

cd minetest && git pull && cd ..

echo "-------------------------"
echo "---Updating IrrlichtMt---"
echo "-------------------------"

cd minetest/lib/irrlichtmt && git pull

cd ../..

echo "-----------------------"
echo "---Building Minetest---"
echo "-----------------------"

cmake . -DRUN_IN_PLACE=TRUE -DBUILD_SERVER=TRUE -DBUILD_CLIENT=FALSE
make -j$(nproc)