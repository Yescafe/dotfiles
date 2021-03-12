# dotfiles - 我的个人环境配置

中文 | [English](/readme.md)

*首先感谢本仓库的来源 [Yescafe/.whichrc](https://github.com/Yescafe/.whichrc)，虽然也是我的仓库。目前它已经被归档了。*

## 这是什么

这个仓库是我软件配置、环境配置等的一个小集合，并且搭配了一键配置环境的脚本。

现在这个仓库中包含：

- 预留

## 为什么要用这个

简而言之，初始化一台新的机器或者虚拟机或者是迁移自己的环境过于繁琐。如今我可以使用这个仓库一键搭建我的环境。

## 如何使用

**请不要中途关闭终端。**

首先，你需要设置好你的代理

```bash
# 自己动手做
```

~~然后递归克隆这个仓库, 推荐将它克隆到家目录然后隐藏起来:~~

```bash
git clone --recursive https://github.com/Yescafe/dotfiles $HOME/.dotfiles
```

啊，忘了你现在还没有 git。不过没关系，你可以直接使用这个链接下载仓库压缩包 [https://github.com/Yescafe/dotfiles/archive/main.zip](https://github.com/Yescafe/dotfiles/archive/main.zip)。

如果你的系统自带 wget 之类的软件，可以:

```bash
wget https://github.com/Yescafe/dotfiles/archive/main.zip
```

然后使用终端或者文件管理器将它移动到你的家目录下：

```bash
mv /path/to/main.zip $HOME/main.zip
```

再解压它。如果没有 `unzip` 指令，可以在文件管理器中解压：

```bash
cd $HOME && unzip ./main.zip
```

然后将它移动到下面指令中指定的位置：

```bash
mv $HOME/dotfiles-main $HOME/.dotfiles
```

最后，执行： 

```bash
cd $HOME/.dotfiles && ./setup.py
```

接着你就可以根据引导完成配置了。 
