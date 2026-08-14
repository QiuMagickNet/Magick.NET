#!/bin/sh
set -e

version=`cat src/Magick.Native/Magick.Native.version`
architecture=$1
quantum=$2

downloadAsset() {
    local pattern=$1
    local targetFolder=$2

    echo "Downloading $1 ($version)"
    gh release download "$version" --repo "QiuMagickNet/Magick.Native" --pattern "$pattern" --dir "$targetFolder" --clobber

    local zipFile=$targetFolder/$1
    unzip -oq "$zipFile" -d $targetFolder
    rm -f "$zipFile"
}

mkdir -p src/Magick.Native/libraries/android
downloadAsset "android-$quantum-$architecture.zip" src/Magick.Native/libraries/android

mkdir -p src/Magick.Native/resources
downloadAsset "resources-$quantum-$architecture.zip" src/Magick.Native/resources

folder=src/Magick.Native/resources/Release$quantum/$architecture
mkdir -p $folder
mv src/Magick.Native/resources/*.xml $folder

mkdir -p src/Magick.Native/metadata
downloadAsset "metadata.zip" src/Magick.Native/metadata

noticeFile=src/Magick.Native/metadata/Notice.txt
printf '[ Magick.NET ] copyright:\n\n' > $noticeFile
cat src/Magick.NET/Copyright.txt >> $noticeFile 2>/dev/null || printf 'Copyright 2013-2026 Dirk Lemstra\n' >> $noticeFile
printf '\n' >> $noticeFile
cat src/Magick.Native/metadata/libraries.md >> $noticeFile 2>/dev/null || true