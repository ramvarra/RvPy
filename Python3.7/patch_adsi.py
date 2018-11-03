'''
Patch win32comext.adsi module (part of pywin32)
This moudule generates a ModuleNotFound error when used with active_directory
Need to change: lib\site-packages\win32comext\adsi\__init__.py file
    from adsi import *
to
    from .adsi import *
'''
import os, sys
import re

adsi_init_file  = os.path.join(sys.base_prefix, r'lib\site-packages\win32comext\adsi\__init__.py')
t_orig = open(adsi_init_file).read()
m = re.search(r'^from\s+adsi\s+import\s+\*$', t_orig, re.MULTILINE)
if m:
    print(f"Patching {adsi_init_file} - fixing from adsi import *")
    t_new = t_orig[:m.start()] + 'from .adsi import *' + t_orig[m.end():]
    with open(adsi_init_file, 'w') as fd:
        fd.write(t_new)
else:
    print(f"No need to patch {adsi_init_file} - from adsi import * not found")
