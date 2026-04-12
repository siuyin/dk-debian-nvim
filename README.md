# Generic nvim install
Basic .config/nvim/init.lua installed.

Format with gg=G .

## Run
```
docker run --rm -it -v $HOME:/h -u $UID <docker_image>
```

## Optional Runtimes (eg. nodejs/npm)

First install nvm with:
```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
```

Then `nvm install 24.14.0` to install node v24 and its associated npm.

Note: nodejs v25 required libatomic1
```
sudo apt update
sudo apt install libatomic1
```

### uv, ruff and ty for python
install uv:
```
curl -LsSf https://astral.sh/uv/install.sh | sh
```

install ruff and ty:
```
uv tool install ruff@latest
uv tool install ty@latest
```

## Triggering Completions
`Ctrl-x Ctrl-o` followed by space for snippet completion.
