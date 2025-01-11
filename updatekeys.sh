#!/bin/bash
find \( -name 'values*-secrets.yaml' -o -name '*.enc.yaml' \) -exec sops updatekeys -y {} \;
