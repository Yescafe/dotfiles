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

Firstly, I should set up proxy:

```bash
wget https://gitee.com/setup_proxy.py
```

Then clone this repo recursively, recommend to clone at the home directory and hide it:

```bash
git clone --recursive https://github.com/Yescafe/dotfiles $HOME/.dotfiles
```

Finally, execute 

```bash
cd $HOME/.dotfiles && ./setup.py
```

and wait several minutes. Reboot my computer.