#!/bin/bash
set -eux
/etc/eks/bootstrap.sh nonprod-eks --kubelet-extra-args '--node-labels=role=worker'
