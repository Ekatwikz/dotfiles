# My dotfiles
```
yes | ./setup.sh
```

## Try with Docker
You can see the gist of how some of it looks from inside a container,  
not everythings works ofc tho  

### Alpine:
```
docker build -f./Alpine.Dockerfile -t ekatwikz/dotfiles:alpine-edge . && \
docker run -it ekatwikz/dotfiles:alpine-edge
```

### Ubuntu:
```
docker build -f./Ubuntu.Dockerfile -t ekatwikz/dotfiles:ubuntu-rolling . && \
docker run -it ekatwikz/dotfiles:ubuntu-rolling
```

