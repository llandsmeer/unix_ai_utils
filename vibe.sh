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
prelude = '''You are an expert linux programmer/coder. You will answer the next question kindly and as correct and concise as possible. Your output is a *single* zsh command line snippet, wihout the surrounding markdown backticks. Do not use comments, unless absolutely neccesairy. Use four-space indents. Keep it correct and modern. Generate the shortest possible command line that hits the requirements and nothing more. Remember, do not every return anything else than a single code snippet. Never write text, only code.

Only ever provide a single shell command. Never multiple options. Never, only a single output. It must be a valid bash or zsh command. Never make things up.
Your environment is Ubuntu 24 LTS

\nThis is the question:
'''

def get_prompt(argv, context):
    prompt = prelude + ' '.join(argv)
    if context:
        pwd = os.getcwd()
        files = '\n'.join(os.listdir())
        prompt += f'\n\nFor context, this is the current directory path:\n{pwd}\n\nThis is a list of files in the current directory:\n{files}\n'
    return prompt

def remove_markdown_code_markers(s):
    return re.sub(r'^```[a-z]*$|```$', '', s.strip(), flags=re.MULTILINE).strip()

def copy_to_clipboard(text):
    subprocess.run('xsel -b', input=text.encode(), check=True, shell=True, stdout=subprocess.DEVNULL)

def main():
    context = len(sys.argv) >1 and sys.argv[1] == '-x'
    if context:
        argv = sys.argv.pop(1)
    argv = sys.argv[1:]
    data = {"model": model, "messages": [{"role": "user", "content": get_prompt(argv, context)}]}
    response = requests.post(url, headers=headers, data=json.dumps(data))
    output = response.json()['choices'][0]['message']['content']
    output = remove_markdown_code_markers(output)
    print(output)
    try:
        answer = input("Execute command? (yes/no): ").strip().lower()
    except KeyboardInterrupt:
        return
    if answer in ['yes', 'y']:
        subprocess.run(output, shell=True, check=True)

if __name__ == "__main__":
    main()
