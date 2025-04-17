#!/usr/bin/env python3

import os
import sys
import requests
import json
import subprocess
import re

def secret():
    try:
        with open(os.path.expanduser('~/.groq_secret'), 'rt') as f:
            return f.read().strip()
    except IOError:
        print('failed to load ~/.groq_secret')
        exit(1)

url = "https://api.groq.com/openai/v1/chat/completions"
headers = {"Content-Type": "application/json", "Authorization": f"Bearer {secret()}"}
model = "meta-llama/llama-4-scout-17b-16e-instruct"
prelude = '''You are an command line unix tool.
You will behave as a tool that follows the unix philosophy:

  - Programs that do one thing and do it well.
  - Programs to work together.
  - Programs to handle text streams, because that is a universal interface.

You input derives from another command line program. Your output will go into another command line program.
Thus your output should be the most obvious as expected output. Thus *never* write anything else than the expected output, as this will break the downstream process. Never explain what you do just write the expected output.
Only ever provide a single output. Never multiple options. Never make things up.

If for some reason the task is not clear, output the word ERROR_ERROR_ERROR exactly as spelled, and then a single line explanation.

Your environment is Ubuntu 24 LTS

\nThis is the task:
'''

def get_prompt(argv, context):
    prompt = prelude + ' '.join(argv)
    if context:
        prompt += '\n\nThis is your input text:\n\n```\n' + context + '\n```'
    return prompt

def remove_markdown_code_markers(s):
    return re.sub(r'^```[a-z]*$|```$', '', s.strip(), flags=re.MULTILINE).strip()

def copy_to_clipboard(text):
    subprocess.run('xsel -b', input=text.encode(), check=True, shell=True, stdout=subprocess.DEVNULL)

def main():
    context = sys.stdin.read().strip()
    argv = sys.argv[1:]
    data = {"model": model, "messages": [{"role": "user", "content": get_prompt(argv, context)}]}
    response = requests.post(url, headers=headers, data=json.dumps(data))
    output = response.json()['choices'][0]['message']['content']
    output = remove_markdown_code_markers(output)
    if 'ERROR_ERROR_ERROR' in output:
        output = output.replace('ERROR_ERROR_ERROR', '').strip()
        print(f"\033[31m{output}\033[0m")
        exit(1)
    print(output)

if __name__ == "__main__":
    main()
