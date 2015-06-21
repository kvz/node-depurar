dbg = require("../src/Depurar")()

dbg "Please look at this object: %o", contains: a: "bug"
dbg "Please look at this object: %s", contains: a: "bug"
dbg "Please look at this string: %o", "ohai"
dbg "Please look at this string: %s", "ohai"
dbg {}
dbg nested: two: "levels"
dbg false
dbg process.nonExisting
dbg "ohai"
