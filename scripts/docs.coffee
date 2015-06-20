dbgBar = require("../src/Depurar")("Foo:Bar")
dbgBar "ohai"

dbgBaz = require("../src/Depurar")("Foo:Baaaz")
dbgBaz "ohai"

dbgAuto = require("../src/Depurar")()
dbgAuto "ohai"

dbgBar = require("../src/Depurar")("Foo:Bar")
dbgBar "I'm just always Pink no matter when I'm instantiated"

dbgBaz = require("../src/Depurar")("Foo:Baaaz")
dbgBaz "I'm just always Blue no matter when I'm instantiated"

dbgAuto = require("../src/Depurar")()
dbgAuto "I'm just always Green no matter when I'm instantiated"
