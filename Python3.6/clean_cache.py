'''
    Remove older versions of pacakges in cache_dir.

'''
import re, sys, os

assert len(sys.argv) == 2, "Usage: {} <cache_dir>".format(sys.argv[0])

files = os.listdir(sys.argv[1])

clean_dict = {}
to_drop = []
for f in files:
    m = re.findall(r'(.+\.\d+)(-|\.tar\.gz|\.zip)', f)
    if not m:
        continue

    assert len(m) == 1 and len(m[0]) == 2, f"bad m {m} for file: {f}"
    pv = m[0][0]
    m = re.match(r'(?P<pkg>.+)-(?P<version>[\d.]+)$', pv)
    assert m, f"Can not match pv {pv} in file {f}"
    p = m.group('pkg')
    v = m.group('version')
    v = tuple(int(part) for part in v.split('.'))
    #print(p, v, f)
    if p not in clean_dict:
        clean_dict[p] = (f, v)
    else:
        old_f, old_v = clean_dict[p]
        if v > old_v:
            to_drop.append(old_f)
            clean_dict[p] = (f, v)
        else:
            to_drop.append(f)

for f in to_drop:
    full_path = os.path.join(sys.argv[1], f)
    print(f'Cleanup up: {full_path}')
    os.remove(full_path)

print (f'{len(to_drop)} files deleted' if len(to_drop) else 'no files need to be deleted')

# --- NUMPY handling
if not os.path.exists('EXTRA_PACKAGES'):
    raise "EXTRA_PACKAGES directory not found"
#numpy-1.14.1+mkl-cp36-cp36m-win_amd64.whl
numpy_mkl = [f for f in os.listdir('EXTRA_PACKAGES') if re.match('numpy-[\d.]+\+mkl-', f)]
if not numpy_mkl:
    raise "EXTRA_PACKAGES does not have numpy-mkl"
numpy_mkl = numpy_mkl[0]
if 'numpy' in clean_dict:
    f, v = clean_dict['numpy']
    print('Deleting {}'.format(f))
    os.remove(os.path.join(sys.argv[1], f))
