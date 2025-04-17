# unix.ai

This repository containing command line programs that bring the 'power' of LLMs to the shell.



>  - Write programs that do one thing and do it well.
>  - Write programs to work together.
>  - Write programs to handle text streams, because that is a universal interface.
>
> Salus, Peter H. A quarter century of UNIX. ACM Press/Addison-Wesley Publishing Co., 1994.

## Installation

Get an API key from groq cloud and store in `~/.groq_secret`.
Run `bash install.sh`

## Usage


**vibe**: generate python programs

```
$ vibe fibonacci recursive
def fib(n):
    if n == 0:
        return 0
    elif n == 1:
        return 1
    return fib(n-1) + fib(n-2)
```

**pipe | vibe**: refactoring

```
$ vibe fibonacci recursive | vibe single line
def fib(n): return 0 if n == 0 else 1 if n == 1 else fib(n-1) + fib(n-2)
```

**tool**: generic command line tool

```
$ seq 5 | tool number as text and add .txt
one.txt
two.txt
three.txt
four.txt
five.txt
```

**vibe.sh**: command line generation

```
$ vibe.sh git new dev branch
git checkout -b dev
Execute command? (yes/no):
```

**prompt**: ask questions

```
$ prompt what are the downsides of ai as a coding tool
The downsides of using AI as a coding tool include reliability issues, as the generated code may have errors or not fully understand the project's context. It can create a learning curve, making developers reliant on AI and potentially hindering their ability to troubleshoot independently. Security risks arise as AI-generated code might introduce vulnerabilities. Intellectual property concerns emerge regarding ownership of AI-produced code. Maintainability issues occur if the code is non-standard or hard to understand. Bias in AI training data can lead to discriminatory outcomes. Lastly, over-reliance on AI might cause job displacement, particularly affecting entry-level developers.
```

Some more **tool** examples:

```
file * | xargs tool mime content type | tool align columns
install.sh     text/x-shellscript
README.md      text/markdown
tool           text/x-python
vibe           text/x-python
vibe.sh        text/x-shellscript
```

```
$ ls -alh * | tool markdown table just size date time na
me aligned
| Size | Date    | Time  | Name      |
|------|---------|-------|-----------|
| 178  | apr 17  | 11:14 | install.sh|
| 2.2K | apr 17  | 10:02 | prompt    |
| 2.0K | apr 17  | 11:26 | README.md |
| 2.4K | apr 17  | 11:13 | tool      |
| 2.4K | apr 17  | 11:13 | vibe      |
| 2.5K | apr 17  | 10:05 | vibe.sh   |
```

