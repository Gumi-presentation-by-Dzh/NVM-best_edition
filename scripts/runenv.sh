#!/bin/bash

_PREFIX=$(dirname $(pwd))

CORE_PMU_MODULE=${_PREFIX}/core.ko
UNCORE_PMU_MODULE=${_PREFIX}/uncore.ko

CORE_IOCTL=/proc/core_pmu
UNCORE_IOCTL=/proc/uncore_pmu

INSTALL_MOD="sudo numactl --physcpubind=12 --membind=1 insmod"
REMOVE_MOD="sudo rmmod uncore"

USE_MOD="numactl --physcpubind=0 --membind=1"

INPUT_COMMAND=$1

USE()
{
   ${USE_MOD} ${INPUT_COMMAND}
}
#echo $bw > /proc/uncore_pmu

Start()
{
    #${INSTALL_MOD} ${CORE_PMU_MODULE}
	${INSTALL_MOD} ${UNCORE_PMU_MODULE}
    echo "Emulation starts"
}

End()
{
    #${REMOVE_MOD} ${CORE_PMU_MODULE}
    #${REMOVE_MOD} ${UNCORE_PMU_MODULE}
    ${REMOVE_MOD}
    echo "Emulation ends"
}

Reset()
{
    ${REMOVE_MOD}
    echo "Reset online modules"
}

declare -i bw
declare -i latency

#lsmod | grep -c uncore
CHECK=`lsmod | grep -c uncore`
TEMP="0"

if [ "$CHECK" -ne "$TEMP" ]
then
    Reset
fi

Start
USE
End
