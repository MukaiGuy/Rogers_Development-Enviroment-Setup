#!/bin/bash
if echo uname = 'Linux'; then
    echo 'The Linux script is starting please watch for prompts' && sleep 5 && ./devsetup.sh && ./personalize.sh
else
    echo 'The MacOS script is starting please watch for prompt' && sleep 5 && ./macsetup.sh && ./personalize.sh
fi
