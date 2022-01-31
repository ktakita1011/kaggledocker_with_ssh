FROM gcr.io/kaggle-gpu-images/python

ENV lang="ja_jp.utf-8" language="ja_jp:ja" lc_all="ja_jp.utf-8"

RUN apt-get update --fix-missing; exit 0
RUN apt-get install -y openssh-server

#libstdc++.so.6: version `GLIBCXX_3.4.22' not foundの対策
RUN add-apt-repository ppa:ubuntu-toolchain-r/test; exit 0
RUN apt update -y; exit 0
RUN apt upgrade -y; exit 0

RUN mkdir /root/.ssh /workdir /run/sshd && \
    chmod 700 /root/.ssh && \
    sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config

RUN jupyter notebook --generate-config && \
	sed -i 's/#c.NotebookApp.quit_button = True/c.NotebookApp.quit_button = False/' /root/.jupyter/jupyter_notebook_config.py

ADD run.sh /opt/run.sh
ADD authorized_keys /root/.ssh/authorized_keys
RUN chmod 700 /opt/run.sh && chmod 600 /root/.ssh/authorized_keys

WORKDIR /workdir
ADD requirements.txt /workdir/requirements.txt
RUN pip install -r requirements.txt

CMD /opt/run.sh