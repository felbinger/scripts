#!/bin/bash

python -c "import base64; print(base64.b64decode(\""$1"\"))"
