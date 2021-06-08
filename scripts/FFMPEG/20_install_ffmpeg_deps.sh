###
# File: 20_install_ffmpeg_deps.sh
# Project: FFMPEG
# File Created: Tuesday, 8th June 2021 11:09:32 pm
# Author: Josh.5 (jsunnex@gmail.com)
# -----
# Last Modified: Wednesday, 9th June 2021 1:43:36 am
# Modified By: Josh.5 (jsunnex@gmail.com)
###

echo "**** installing ffmpeg deps ****"
for d in /tmp/*; do \
    if [ -d "${d}" ]; then \
        if ! ls -la "${d}/install-cmd.sh"; then
            echo "ERROR! Missing install-cmd.sh file '${d}/install-cmd.sh'"
            exit 1;
        fi
        echo "  - Running installation from commands in ${d}"
        echo
        echo
        cd ${d}
        cat ./install-cmd.sh
        echo
        echo
        source ./install-cmd.sh
        if [ $? -gt 0 ]; then 
            exit 1; 
        fi
        echo;
    fi
done
