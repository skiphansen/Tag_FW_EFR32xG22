#!/bin/bash

set -x
log=flash.log
#device=EFR32FG22C121F256GM40
device=EFR32BG22C222F352GM40
commander=~/.local/bin/commander/commander
version=43
image=full_binaries/v${version}/SOLUM_AUTODETECT_FULL_v${version}.s37

echo "----" >> ${log}
${commander} device unlock -d ${device} 2>&1 | tee -a ${log}
${commander} device info -d ${device} 2>&1 | tee -a ${log}
${commander} readmem -d ${device} --region "@userdata" 2>&1 | tee -a ${log}
${commander} flash -d ${device} ${image} 2>&1 | tee -a ${log}



