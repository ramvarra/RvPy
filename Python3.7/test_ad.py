import active_directory
import win32api


user = win32api.GetDomainName() + '\\' + win32api.GetUserName()
print('CurUser: ', user)
assert user

my_root = active_directory.root ()
assert my_root
print('Root: ', my_root)

user = active_directory.find_user(win32api.GetUserName())
print('User: ', user)
assert user

print('Success')
