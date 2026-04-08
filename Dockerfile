FROM debian:13-slim AS unpacker
RUN apt update && apt install -y xz-utils
ADD https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz /usr/local/
RUN tar -C /usr/local -xf /usr/local/nvim-linux-x86_64.tar.gz
RUN ls -l /usr/local

FROM debian:13-slim
RUN apt update && apt-get install -y sudo curl ripgrep tmux procps git xclip adduser &&  adduser -uid 1000 siuyin  && adduser siuyin sudo &&  echo "siuyin ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/siuyin
COPY --from=unpacker /usr/local/nvim-linux-x86_64/ /usr/local/nvim

USER siuyin
WORKDIR /home/siuyin
COPY --chown=siuyin:siuyin .config/nvim/init.lua .config/nvim/init.lua
COPY --chown=siuyin:siuyin tmux.conf profile_paths agent-startup-code .
RUN mkdir .ssh
RUN cat agent-startup-code >> .profile
RUN cat profile_paths >> .profile

ENTRYPOINT ["bash","--login"]
