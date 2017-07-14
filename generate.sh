#!/bin/bash

git clone https://github.com/SoftwareDefinedBuildings/XBOS _src
pushd _src/interfaces/genmd ; go build ; popd

cat <<EOF > driver_interfaces.md
# Driver Interfaces

> These are currently [under development](https://github.com/SoftwareDefinedBuildings/XBOS/tree/master/interfaces)
>
> Discussion of these interfaces is taking place on the [XBOS issue tracker](https://github.com/SoftwareDefinedBuildings/XBOS/issues/1)
EOF
for i in $(ls _src/interfaces/xbos*.yaml) ; do
    filename=$(basename $i)
    _src/interfaces/genmd/genmd $i > driver_${filename%.*}.md
done

rm -rf _src
