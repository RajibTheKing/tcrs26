######################################
#
# SVG2PDF
# by ssm, 2018
# modernized by nre, 2025-2026
# added support for PNG files by rcd, Date: 1st July, 2026
import os, re, subprocess, sys, getopt
from pathlib import Path

basepath = "."
override = False

def process(path, file):
    m = re.match("^(.+)\\.(svg|png)$", file, re.IGNORECASE)
    filename = m.group(1) + ".pdf"
    abspath = (Path(path) / file).resolve()
    genpath = abspath.parent / "gen"
    pdffile = genpath / filename
    ext = m.group(2).lower()

    print("Processing " + str(abspath) + " ... ", end='', flush=True)

    if not override and os.path.exists(str(pdffile)):
        print("Skipped")
        return

    if ext == "svg":
        pdfcommand = "inkscape --export-area-drawing --export-dpi=1200 " + str(abspath) + " --export-filename=" + str(pdffile) + " 2>/dev/null"
    else:
        pdfcommand = "inkscape " + str(abspath) + " --export-filename=" + str(pdffile) + " 2>/dev/null"

    if not os.path.exists(genpath):
        os.makedirs(genpath)

    subprocess.Popen(pdfcommand, shell=True, stdout=subprocess.DEVNULL).wait()

    print("OK")
    return


opts, args = getopt.getopt(sys.argv[1:], "fd:", ["force"])
for opt, arg in opts:
    if opt in ("-f", "-force"):
        override = True
    if opt in ("-d"):
        basepath += "/" + arg

directories = os.walk(basepath)
# circumvent issue when executed from VS Code shell.
os.environ.pop('GTK_PATH', None)
for d in directories:
    for f in d[2]:
        if re.match("^.*\\.(svg|png)$", f, re.IGNORECASE):
            process(d[0], f)