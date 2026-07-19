#!/bin/bash

set -e

if [[ ${BASH_VERSINFO[0]} -lt 4 ]]
then
  echo "You need at least bash 4 to run this script."
  exit 1
fi

if [ $# -lt 2 ]; then
    echo "Usage: bash customizer.sh my.new.package MyNewDataModel [ApplicationName]" >&2
    exit 1
fi

PACKAGE=$1
APPNAME=$2

ls -la app/src/main/java/com/example/myapplication

OLD_PACKAGE="com.example.myapplication"

OLD_PATH=$(echo "$OLD_PACKAGE" | tr '.' '/')
NEW_PATH=$(echo "$PACKAGE" | tr '.' '/')

ls -la app/src/main/java/com/example/myapplication

OLD_PACKAGE="com.example.myapplication"

OLD_PATH=$(echo "$OLD_PACKAGE" | tr '.' '/')
NEW_PATH=$(echo "$PACKAGE" | tr '.' '/')

echo "OLD_PATH=$OLD_PATH"
echo "NEW_PATH=$NEW_PATH"

# přesun Java/Kotlin adresáře
mkdir -p app/src/main/java/$NEW_PATH

mv app/src/main/java/$OLD_PATH/* app/src/main/java/$NEW_PATH/
rm -rf app/src/main/java/$OLD_PATH

# změna package v Kotlin souborech
find . -name "*.kt" -exec sed -i \
"s/$OLD_PACKAGE/$PACKAGE/g" {} \;

# změna namespace a applicationId
find . -name "*.kts" -exec sed -i \
"s/$OLD_PACKAGE/$PACKAGE/g" {} \;

# změna názvu aplikace
find . -name "*.xml" -exec sed -i \
"s/My Application/$APPNAME/g" {} \;

# Rename project name in settings.gradle.kts
find . -name "settings.gradle.kts" -exec sed -i \
"s/rootProject.name = \"My Application\"/rootProject.name = \"$APPNAME\"/g" {} \;

# Vytvoření local.properties
echo "Vytvářím local.properties"
if [ -n "$ANDROID_HOME" ]; then
    SDK_PATH="$ANDROID_HOME"
else
    SDK_PATH="$HOME/Android/Sdk"
fi
echo "sdk.dir=$SDK_PATH" > local.properties

echo "Hotovo"
