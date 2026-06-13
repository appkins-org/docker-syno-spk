#!/bin/sh

. "/var/packages/docker/target/app/source.sh"

cd "$HB_SERVICE_STORAGE_PATH"

# copy .bashrc to service user home
cp "/var/packages/docker/target/app/bashrc" "/var/packages/docker/home/.bashrc"

# copy .npmrc
cp "/var/packages/docker/target/app/npmrc" "$HB_SERVICE_STORAGE_PATH/.npmrc"

# remove the package-lock.json
if [ -e "$HB_SERVICE_STORAGE_PATH/package-lock.json" ]; then
  rm -rf "$HB_SERVICE_STORAGE_PATH/package-lock.json"
fi

# if coming from an old pnpm based install, delete plugins so they are freshly installed
if [ -e "$HB_SERVICE_STORAGE_PATH/pnpm-lock.yaml" ]; then
  rm -rf "$HB_SERVICE_STORAGE_PATH/node_modules"
  rm -rf "$HB_SERVICE_STORAGE_PATH/pnpm-lock.yaml"
fi

# remove docker-config-ui-x from the package.json
if [ -e "$HB_SERVICE_STORAGE_PATH/package.json" ]; then
  if [ "$(cat $HB_SERVICE_STORAGE_PATH/package.json | jq -r '.dependencies."docker-config-ui-x"')" != "null" ]; then
    packageJson="$(cat $HB_SERVICE_STORAGE_PATH/package.json | jq -rM 'del(."dependencies"."docker-config-ui-x")')"
    if [ "$?" = "0" ]; then
      printf "$packageJson" > "$HB_SERVICE_STORAGE_PATH/package.json"
      echo "Removed docker-config-ui-x from package.json"
    fi
  fi
fi

# setup initial package.json with docker
if [ ! -e "$HB_SERVICE_STORAGE_PATH/package.json" ]; then
  HOMEBRIDGE_VERSION="$(curl -sf https://registry.npmjs.org/docker/latest | jq -r '.version')"
  echo "{ \"dependencies\": { \"docker\": \"$HOMEBRIDGE_VERSION\" }}" | jq . > "$HB_SERVICE_STORAGE_PATH/package.json"
fi

# install plugins
echo "Installing plugins, please wait..."
npm --prefix "$HB_SERVICE_STORAGE_PATH" install
