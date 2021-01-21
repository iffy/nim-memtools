import strutils

proc lowerHex(x: byte|int): string {.inline.} =
  toHex(x).toLower()

proc addrstr*[T](t: T): string {.inline.} =
  ## Get the address of a thing as a hex value
  "0x" & lowerHex(cast[int](cast[ptr UncheckedArray[byte]](t.unsafeAddr)))

proc charRepr*(x:byte):char =
  ## Lossly: Convert a character to human-readable
  case x
  of 32..126: result = chr(x)
  else: result = '.'

proc dumpPtrMem*(p:pointer, N:int): string =
  ## Print out a chunk of memory
  ## p = memory to print out
  ## N = number of bytes to highlight
  if p == nil:
    return "0x0000000000000000  nil"
  if N == 0:
    return "dumpMem WARNING: N=0"
  var cp = cast[ptr UncheckedArray[byte]](p)
  var asciibuf = ""
  for c in 0..<N:
    if c mod 16 == 0:
      # print out line address
      result.add "0x"
      result.add lowerHex(cast[int](cp) + c)
      result.add "  "
    if c mod 16 == 8:
      # space between sets of 8
      result.add " "
    # print char
    result.add lowerHex(cp[c]) & " "
    # add to right-side ascii table
    asciibuf.add charRepr(cp[c])
    if c mod 16 == 15 or c == N-1:
      # ascii repr
      let empty = 16 - (c mod 16 + 1)
      for x in 0..<empty:
        
        if (c+x) mod 16 == 7:
          result.add " "
        result.add "-- "
      result.add " |" & asciibuf & "|\l"
      asciibuf = ""
  result.stripLineEnd()

proc dumpMem*[T](obj: T, N: int): string {.inline.} =
  dumpPtrMem(cast[pointer](obj.unsafeAddr), N)

proc dumpMem*(obj: string, N = 0): string =
  result.add "..pointer:\l"
  result.add dumpPtrMem(cast[pointer](obj.unsafeAddr), sizeof(pointer))
  let p = cast[pointer](obj.cstring)
  result.add "\l..storage:\l"
  result.add dumpPtrMem(p, obj.len)

proc dumpMem*(obj: ref object, N = 0): string =
  result.add "..pointer:\l"
  let p1 = cast[pointer](obj.unsafeAddr)
  result.add dumpPtrMem(p1, sizeof(pointer))
  let i = cast[ptr int](p1)
  let p2 = cast[pointer](i[])
  result.add "\l..storage:\l"
  result.add dumpPtrMem(p2, sizeof(obj))
