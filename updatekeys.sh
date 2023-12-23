#!/bin/bash
find -name 'values-secrets*.yaml' -exec sops updatekeys -y {} \;
