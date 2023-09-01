# cmdbot Demo - aka as yolo

![Animated GIF](https://github.com/wunderwuzzi23/blog/raw/master/static/images/2023/yolo-shell-anim-gif.gif)

# cmdbot v0.3 - Support for Azure OpenAI Deployments

This update introduces the `cmdbot.yaml` configuration file. In this file you can specify which Azure OpenAI deployment you want to query, and other settings. The safety switch also moved into this configuration file.


```
yolo v0.2.1 - by @wunderwuzzi23
cmdbot v0.3.1 - Azure OpenAI Integration - by @iamnicoj

Usage: cmdbot [-a] list the current directory information
Argument: -a: Prompt the user before running the command (only useful when safety is off)

Current configuration per cmdbot.yaml:
* Temperature  : 0
* API Base     : <SET-VALUE>
* API Version  : <SET-VALUE>
* API Type     : azure
* Engine       : <SET-VALUE>
* Safety       : True
```

Happy Hacking!

# Installation on Linux and macOS

```
git clone https://github.com/iamnicoj/azure-openai-cmdbot
cd azure-openai-cmdbot
pip3 install -r requirements.txt
chmod +x cmdbot.py
alias cmdbot=$(pwd)/cmdbot.py
alias computer=$(pwd)/cmdbot.py #optional

cmdbot show me some funny unicode characters
```

## OpenAI API Key configuration

There are three ways to configure the key on Linux and macOS:
- You can either `export OPENAI_API_KEY=<yourkey>`, or have a `.env` file in the same directory as `cmdbot.py` with `OPENAI_API_KEY="<yourkey>"` as a line

## Aliases

To set the alias, like `cmdbot` or `computer` on each login, add them to .bash_aliases (or .zshrc on macOS) file. Make sure the path is the one you want to use.

```
echo "alias cmdbot=$(pwd)/cmdbot.py"     >> ~/.bash_aliases
echo "alias computer=$(pwd)/cmdbot.py" >> ~/.bash_aliases
```

## Installation script

Another option is to run `source install.sh` after cloning the repo. That does the following:
1. Copies the necessary files to `~/cmdbot-ai-cmdbot/`
2. Creates two aliases `cmdbot` and `computer` pointint to `~/cmdbot-ai-cmdbot/cmdbot.py`
3. Adds the aliases to the `~/.bash_aliases` or `~/.zshrc` file

That's it for Linux and macOS. Now make sure you have an OpenAI API key set.

# Windows Installation

On Windows you can run `.\install.bat` (or double-click) after cloning the repo. By default it does the following:
1. Copies the necessary files to `~\cmdbot-ai-cmdbot\`
2. Creates a `cmdbot.bat` file in `~` that lets you run equivalent to `python.exe ~\cmdbot-ai-cmdbot\cmdbot.py`

You also have the option to:
1. Change the location where `cmdbot-ai-cmdbot\` and `cmdbot.bat` will be created
2. Skip creating `cmdbot-ai-cmdbot\` and use the folder of the cloned repository instead.
3. Create a `.openai.apikey` file in your `~` directory

That's it basically.

## OpenAI API Key Configuration on Windows

On Windows `export OPENAI_API_KEY=<yourkey>` will not work instead:
- Run `$env:OPENAI_API_KEY="<yourkey>"` to set key for that terminal
- Or, Run PowerShell as administrator and run `setx OPENAI_API_KEY "<yourkey>"`
- Or, Go to `Start` and search `edit environment variables for your account` and manually create the variable with name `OPENAI_API_KEY` and value `<yourkey>`


## Running cmdbot on Windows 

Windows is less tested, it does work though and will use PowerShell.

```
python.exe cmdbot.py what is my username
```

That's it.

## cmdbot.bat

If you use `install.bat` you should have a `cmdbot.bat` file in your `~` directory that lets you run the command like so:

```
.\cmdbot.bat what is my username
```

You can put the `cmdbot.bat` file into a $PATH directory (like `C:\Windows\System32`) to use in any directory like so:

```
cmdbot what is my username
```

Have fun.

# Disabling the safety switch! **Caution!**

By default `cmdbot` will prompt the user before executing commands. 

Since v.0.2 the safety switch setting moved to `cmdbot.yaml`, the old `~/.cmdbot-safety-off` is not used anymore. 

To have cmdbot run commands right away when they come back from ChatGPT change the `safety` in the `cmdbot.yaml` to `False`.

If you still want to inspect the command that is executed when safety is off, add the `-a` argument, e.g `cmdbot -a delete the file test.txt`.

Let's go!

# Demo Video on YouTube

https://www.youtube.com/watch?v=g6rvHWpx_Go

[![Watch the video](https://embracethered.com/blog/images/2023/yolo-thumbnail-small.png)](https://www.youtube.com/watch?v=g6rvHWpx_Go)


# Examples

Here are a couple of examples on how this utility can be used.

```
cmdbot whats the time?
cmdbot whats the time in UTC
cmdbot whats the date and time in Vienna Austria
cmdbot show me some unicode characters
cmdbot what is my user name and whats my machine name?
cmdbot is there a nano process running
cmdbot download the homepage of ycombinator.com and store it in index.html
cmdbot find all unique urls in index.html
cmdbot create a file named test.txt and write my user name into it
cmdbot print the contents of the test.txt file
cmdbot -a delete the test.txt file
cmdbot whats the current price of Bitcoin in USD
cmdbot whats the current price of Bitcoin in USD. Ext the price only
cmdbot look at the ssh logs to see if any suspicious logons accured
cmdbot look at the ssh logs and show me all recent logins
cmdbot is the user hacker logged on right now?
cmdbot do i have a firewall running?
cmdbot create a hostnames.txt file and add 10 typical hostnames based on planet names to it, line by line, then show me the contents
cmdbot find any file with the name cmdbot.py. do not show permission denied errors
cmdbot write a new bash script file called scan.sh, with the contents to iterate over hostnames.txt and invokes a default nmap scan on each host. then show me the file. 
cmdbot write a new bash script file called scan.sh, with the contents to iterate over hostnames.txt and invokes a default nmap scan on each host. then show me the file. Make it over multiple lines with comments and annotiations.
```

# Thanks!

# License

MIT. No Liability. No Warranty. But lot's of fun.
