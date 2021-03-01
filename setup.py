#!/usr/bin/env python

import os
import platform
import sys

ERR = 0
DEBUG = 10

def description(info):
  if info != '':
    print('--- ' + info + ' ---')

def cmd(command, info=''):
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
    if DEBUG == 1:
      print(c)
    else:
      ERR = os.system(c)

if __name__ == '__main__':
  description('dotfiles setup.py')

  system = platform.system().lower()
  print('Get platform system: {}'.format(system))
  if system != 'darwin':
    print('dotfiles is only for macOS now.')
    exit(-1)
  
  print('Hand over to .setup.sh')
  cmd("""
    SETUPPY=1 SYS={} ./.setup.sh
  """.format(system))

  if ERR == 0:
    description('Finish. Please reboot.')
  else:
    print('errno: {}'.format(ERR // 256))
    exit(ERR // 256)
  