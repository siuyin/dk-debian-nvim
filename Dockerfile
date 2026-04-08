FROM debian:13-slim AS unpacker
RUN apt update && apt install -y xz-utils
ADD https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz /usr/local/
ADD https://github.com/LuaLS/lua-language-server/releases/download/3.18.0/lua-language-server-3.18.0-linux-x64.tar.gz /usr/local
RUN tar -C /usr/local -xf /usr/local/nvim-linux-x86_64.tar.gz
RUN mkdir -p /usr/local/lua && tar -C /usr/local/lua -xf /usr/local/lua-language-server-3.18.0-linux-x64.tar.gz
RUN ls -l /usr/local
RUN ls -l /usr/local/lua

FROM debian:13-slim
RUN apt update && apt-get install -y sudo locales curl ripgrep tmux procps git xclip adduser && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen &&  adduser -uid 1000 siuyin  && adduser siuyin sudo &&  echo "siuyin ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/siuyin
COPY --from=unpacker /usr/local/nvim-linux-x86_64/ /usr/local/nvim
COPY --from=unpacker /usr/local/lua /usr/local/lua

USER siuyin
WORKDIR /home/siuyin
COPY --chown=siuyin:siuyin .config/nvim/init.lua .config/nvim/init.lua
COPY --chown=siuyin:siuyin tmux.conf profile_paths agent-startup-code .
RUN mkdir .ssh
RUN cat agent-startup-code >> .profile
RUN cat profile_paths >> .profile
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

ENTRYPOINT ["bash","--login"]
