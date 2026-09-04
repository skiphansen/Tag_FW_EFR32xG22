#!/bin/sh

VPJ_FILE=../vs/Tag_FW_EFR32xG22.vpj

dot_d_2vs.sh ${VPJ_FILE} out/build/debug
cat ${VPJ_FILE} | \
sed -e 's!<F N="../firmware/gecko_sdk_4.4.1/\([^.]\)!<F N="../firmware/out/gecko_sdk_4.4.1/\1!g' | \
sed -e 's!<F N="../firmware/config/\([^.]\)!<F N="../firmware/out/config/\1!g' | \
sed -e 's!<F N="../firmware/autogen/\([^.]\)!<F N="../firmware/out/autogen/\1!g' \
> e.vpj
mv e.vpj ${VPJ_FILE}

