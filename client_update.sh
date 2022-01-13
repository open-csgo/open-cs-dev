#!/usr/bin/zsh

cd ./client_build

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

cmake . -DRUN_IN_PLACE=TRUE
make -j$(nproc)