if [ -f ~/profile/.aliases ]; then
    . ~/profile/.aliases
fi

if [ -f ~/profile/.git-utils ]; then
    . ~/profile/.git-utils
fi

if [ -f ~/profile/.docker-utils ]; then
    . ~/profile/.docker-utils
fi

if [ -f ~/profile/.functions ]; then
    . ~/profile/.functions
fi

if [ -f ~/profile/.extras ]; then
    . ~/profile/.extras
fi

if [ -f ~/profile/.prompt ]; then
    . ~/profile/.prompt
fi
