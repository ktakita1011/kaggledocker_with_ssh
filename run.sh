#/bin/bash

/usr/sbin/sshd
jupyter lab --ip=0.0.0.0 --allow-root --no-browser --NotebookApp.token="salestech" --notebook-dir=/workdir
