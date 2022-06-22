# Templates Files

**Templates files to create new documents on a GUI based file explorer.**

<p align="center">
<img src="https://raw.githubusercontent.com/UbioZur/templates/master/screenshots/right_click_menu.jpg" alt="Screenshot of the New Document menu on Thunar" title="Right Click menu example" />
</p>

### Disclaimer

This repository is intended for my personal use, **YOU DO NOT WANT TO USE IT** to install on your own system, but use it as an inspiration to make your own. I have tried to document it as best as possible for learning purpose.

---

## How to install the Templates

* Clone the repository.

````
git clone git@github.com:UbioZur/templates.git
````

* To Install the Templates, you can simply copy the content of `Templates` folder into `$XDG_TEMPLATES_DIR` or `$HOME/Templates`.

* You can also use the `install.sh` script which will create the sym-link for the folder `$XDG_TEMPLATES_DIR` or `$HOME/Templates`.

````
Usage:  install.sh [-h]
        install.sh [-v] [--dry-run] [--no-color] [-q] [-l] [--log-file /path/to/log [--log-append]] [--root-ok]
        install.sh [-v] [--dry-run] [--no-color] [-q] [-l] [--log-file /path/to/log [--log-append]] [--root-ok] [-u]

 Script to install (sym-link), uninstall (unlink) the templates files to the system

Available options:

    -h, --help          FLAG, Print this help and exit
    -v, --verbose       FLAG, Print script debug info
    --dry-run           FLAG, Display the commands the script will run. ( Will create/delete the folders needed to avoid failure)

Log options:

    --no-color          FLAG, Remove style and colors from output.
    -q, --quiet         FLAG, Non error logs are not output to stderr.
    -l, --log-to-file   FLAG, Write the log to a file (Default: /var/log/install.sh.log).
    --log-file          PARAM, File to write the log to (Also set the --log-to-file flag).
    --log-append        FLAG, Append the log to the file (Also set the --log-to-file flag).

Install options:

    -u, --uninstall     FLAG, Uninstall the program.
    --root-ok           FLAG, Allow script to be run as root (usefull for container CI).
````

---

## Templates Available

* `HeaderDash`: Create the UbioZur Header using double dash `--` as comment.
* `HeaderHash`: Create the UbioZur Header using double hashtag `##` as comment.
* `HeaderSlash`: Create the UbioZur Header using double slash `//` as comment.
* `bash`
    * `install.sh`: Create a template bash script with usefull functions and skeleton for my install script.
    * `script.sh`: Create a template bash script with usefull functions and skeleton.
    * `simple.sh`: Create a template bash script with usefull functions and skeleton for simple scripts.
    * `lib`
        * `envlib.sh`: My bash script library for easy access to functions about the environment (hardware/software)
        * `library.sh`: Template bash script to be used for a library.
        * `loglib.sh`: My bash script library for easy logging functions to std and files.
        * `utilslib.sh`: My bash script library for utility functions.

---

## TODO - Future Updates

* `rofi modi template`: A template to create rofi modi scripts easily.
* `bash test script template`: A template to ease the creation of bash testing.

---

## License

The repo is release under the `MIT No Attribution` license.

````
MIT No Attribution License

Copyright (c) 2022 UbioZur

Permission is hereby granted, free of charge, to any person obtaining a copy of this
software and associated documentation files (the "Software"), to deal in the Software
without restriction, including without limitation the rights to use, copy, modify,
merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
````

**TLDR:** A short, permissive software license. Basically, you can do whatever you want.
