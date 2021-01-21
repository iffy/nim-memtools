
import unittest

import memtools
test "string":
  let s = "something"
  echo dumpMem(s, s.len)

test "longstring":
  let s = "something long and ridiculous and stuff"
  echo dumpMem(s, s.len)

test "int":
  let i = 5
  echo dumpMem(i, 1)

test "bool":
  let b = true
  let c = false
  echo dumpMem(b, 1)
  echo dumpMem(c, 1)

type
  Something = ref object of RootObj
    name*: string

test "obj":
  var a: Something
  echo dumpMem(a, sizeof(a))
  a = Something(name: "bob")
  echo dumpMem(a, sizeof(a))