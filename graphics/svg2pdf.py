######################################
#
# SVG2PDF
# by ssm, 2018
# modernized by nre, 2025-2026
#
import os, re, subprocess, sys, getopt
from pathlib import Path

basepath = "."
override = False

def process(path, file):
    m = re.match("^(.+)\\.svg$", file)
    filename = m.group(1) + ".pdf"
    abspath = (Path(path) / file).resolve()
    genpath = abspath.parent / "gen"
    pdffile = genpath / filename

    print("Processing " + str(abspath) + " ... ", end='', flush=True)

    if not override and os.path.exists(str(pdffile)):
        print("Skipped")
        return

    pdfcommand = "inkscape --export-area-drawing --export-dpi=1200 " + str(abspath) + " --export-filename=" + str(pdffile) + " 2>/dev/null"

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
        if re.match("^.*\\.svg$", f):
            process(d[0], f)
