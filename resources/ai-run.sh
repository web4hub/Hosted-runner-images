# 1. Create a persistent window called 'ai-run'
screen -S ai-run

# 2. Fire up the script inside the screen window
~/self_learning_ai/venv/bin/python3 /mnt/data/my-ai/ai_main.py --core /mnt/data/my-ai/core.json --module /mnt/data/my-ai/module.json
