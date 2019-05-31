#!/usr/bin/env bash
set -euo pipefail

exec ~/.cargo/bin/cargo build --target x86_64-unknown-linux-musl --release
