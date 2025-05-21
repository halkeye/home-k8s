#!/bin/bash
find charts \( -name 'values*-secrets.yaml' -o -name '*.enc.yaml' -o -name '*.sops.yaml'  \) -exec sops updatekeys -y {} \;
