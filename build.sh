#!/bin/env bash

sudo nix build .#nixosConfigurations.testvm-client.config.system.build.toplevel --store /dummynix --extra-substituters "auto?trusted=1" --no-eval-cache