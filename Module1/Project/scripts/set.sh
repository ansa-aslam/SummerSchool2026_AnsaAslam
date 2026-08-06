#!/bin/bash
echo "Making Directories"
mkdir -p raw
mkdir -p scripts
mkdir -p results
mkdir -p figures
touch README.md

echo "Downloading the Files"
cp /home/aaslam123/SummerSchool2026/Module1/data/* /home/aaslam123/SummerSchool2026/Module1/Project/raw

echo "Input Summary"
ls -lh raw

echo "Number of Files"
ls -l raw | wc -l

echo "Done"
