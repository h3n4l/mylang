'''
Author: your name
Date: 2021-11-14 22:51:18
LastEditTime: 2021-11-14 22:57:26
LastEditors: Please set LastEditors
Description: 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
FilePath: /mylang/autoActionInLex.py
'''
def foo(uinput):
    print("{%s}    {printf(\"%s\\n\"); return %s;}"%(uinput,uinput,uinput))


if __name__ == "__main__":
    while(1):
        uinput = input()
        s = uinput.split(" ")
        for t in s:
            foo(t)