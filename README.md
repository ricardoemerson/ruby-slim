# Ruby (2.3.1) and Rails (5.0.0.1) base installation.

This is an image is based on official Ruby 2.3.1-slim and has the Rails 5.0.0.1 installed.

Also was included in this image, ZSH, Vim and Midnight Commander (MC).

```sh
docker run -it -d -v $(PWD):/project/web-app \
                  -p 3000:3000 \
                  ricardoemerson/ruby-slim \
                  [ruby on rails command]
```

if no command is informed, ZSH will be executed automatically.
