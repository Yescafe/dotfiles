# dotfiles - My personal environment profiles

*Thanks to my another repository [Yescafe/.whichrc](https://github.com/Yescafe/.whichrc), which is the origin of this repo.*

## What is this

This repo is a set of my personal software config, or some environment profiles.

And now this includes:

- reserved

## Why do this

In short, initializing a new machine or a VM is too troublesome. Now I can use this repo to one-click set my environments up.

## How to use

**DON'T CLOSE THE TERMINAL HALFWAY.**

Firstly, you should set up proxy:

```bash
# Do by yourself
```

~~Then clone this repo recursively, recommend to clone at the home directory and hide it:~~

```bash
git clone --recursive https://github.com/Yescafe/dotfiles $HOME/.dotfiles
```

I know you don't have git now, so you can get the archive by this link: [https://github.com/Yescafe/dotfiles/archive/main.zip](https://github.com/Yescafe/dotfiles/archive/main.zip).

If you have wget, you can:

```bash
wget https://github.com/Yescafe/dotfiles/archive/main.zip
```

then move it to your home, in file explorer or use shell:

```bash
mv /path/to/main.zip $HOME/main.zip
```

And unzip it:

```bash
cd $HOME && unzip ./main.zip
```

Or use file explorer to unzip it. Then rename it:

```bash
mv $HOME/dotfiles-main $HOME/.dotfiles
```

Finally, execute 

```bash
cd $HOME/.dotfiles && ./setup.py
```

and wait several minutes. Reboot your computer.

