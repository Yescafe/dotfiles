#!/usr/bin/env python3

import os
import platform
import sys

if sys.version_info.major != 3:
  print('Please use Python3!')
  exit(-1)

ERR = 0

def description(info):
  if info != '':
    print('--- ' + info + ' ---')

def cmd(command, env=dict(), info=''):
  """
  Execute and output a command
  """
  global ERR
  global DEBUG
  if ERR != 0:
    return
  description(info)
  command = command.split('\n')
  for c in command:
    if ERR != 0:
      break
    for k, v in env.items():
      c = "{}={} ".format(k, v) + c
    print('@' + c)
    ERR = os.system(c)

if __name__ == '__main__':
  description('dotfiles setup.py')

  system = platform.system().lower()
  distro_pm = '0'
  print('Get platform system: {}'.format(system))
  if system != 'darwin' and system != 'linux':
    print('dotfiles is only for macOS and linux now.')
    exit(0)
  if system == 'linux':
    distro_pm = input('Which is your package manager?(1=apt,2=dnf,3=pacman,4=others): ')
    if distro_pm not in ('1', '2', '3'):
      print('Your distro is not supported now.')
      exit(0)
  
  print('Hand over to .setup.sh')
  cmd("./.setup.sh", {
    'SETUPPY': 1,
    'SYS': system,
    'DISTRO_PM': distro_pm,
  })

  print('errno: {}, return: {}'.format(ERR, ERR // 256))
  if ERR == 0:
    description('Finish.')
  exit(ERR // 256)

print('Reboot now?[Y/n] ', end='')
yn = input()
if yn == 'y' or yn == 'Y':
  cmd('sudo reboot')
else:
  print('Do with yourself, enjoy!')
