#!/bin/bash

if [[ $# == 0 ]]; then
		echo "Please provide input file name!"
fi

CONTENT_BUFFER=""
while IFS= read -r LINE
do
		if [[ "${LINE}" == "--- Raw source ---" ]]; then
				NAME=""
				CONTENT_BUFFER="${LINE}"
				continue
		fi

		if [[ "${LINE:0:18}" == "optimization_id = " ]]; then
				OPTID=${LINE:18}
		fi

		if [[ "${LINE:0:7}" == "name = " ]]; then
				NAME=${LINE:7}
				NAME="${NAME// /_}.${OPTID}.txt"
				echo ${NAME}
				if [[ "${CONTENT_BUFFER}" != "" ]]; then
						echo -e "${CONTENT_BUFFER}" > ${NAME}
				fi
				CONTENT_BUFFER=""
		fi

		if [[ "${LINE}" == "--- End code ---" ]]; then
				NAME=""
				CONTENT_BUFFER=""
		fi
		
		if [[ "${CONTENT_BUFFER}" != "" ]]; then
				CONTENT_BUFFER="${CONTENT_BUFFER}\n${LINE}"
		fi
		
		if [[ "${NAME}" != "" ]]; then
				if [[ "${LINE:0:2}" == "0x" ]]; then
						echo "${LINE#* }" >> ${NAME}
				else
						echo "${LINE}" >> ${NAME}
				fi
		fi
		
done < $1

