#!/bin/sh
echo "Resetting directory permissions..."
find -type d -exec chmod 755 {} \;
echo "Resetting file permissions..."
find -type f -exec chmod 644 {} \;
