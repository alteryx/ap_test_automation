'use strict'

require('./index.html')
const Elm = require('./Main')
const main = document.getElementById('main')
Elm.Main.embed(main)

