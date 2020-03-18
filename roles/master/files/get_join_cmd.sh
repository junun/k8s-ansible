#!/bin/bash
case "$1" in
    master)
      cat /tmp/kubeadm-init.log  | sed -n  '/control-plane node/,/Please note that/p' | grep -v the | grep -v "^$" | xargs | xargs
    ;;
    node)
      cat /tmp/kubeadm-init.log | tail -n 2 | xargs | xargs
esac