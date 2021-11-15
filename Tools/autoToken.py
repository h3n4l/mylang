'''
Author: your name
Date: 2021-11-15 11:12:59
LastEditTime: 2021-11-15 11:16:57
LastEditors: Please set LastEditors
Description: 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
FilePath: /mylang/Tools/autoToken.py
'''
def foo(istr):
    print("%%token %s"%istr)

if __name__ == "__main__":
    s = input()
    s = s.split(" ")
    for i in s:
        foo(i)

