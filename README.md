# hugo-templates
create skeleton of hugo presentations

```bash
./create.sh -h 

Usage: ./create.sh -p NAME_PRESENTATION -c CODE_DIR

    -p - Name of the presentation you want to create

    -c - Directory to store it, defaults to $HOME/Documents/code/, this will place -p there 


```

1. Git init
2. Creates Hugo site -p 
3. Downloads Reveal theme from github
4. Adds reveal theme to the config.toml
5. Downloads makefile for building sites

Uses the [Reveal theme]( https://github.com/dzello/reveal-hugo) by default 