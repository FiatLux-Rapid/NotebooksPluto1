//console.log("Hello  Node 😄. ")

const express = require('express')    
const morgan= require('morgan')    // log book sur console
const favicon= require('serve-favicon')  // add favicon
const bodyParser=require('body-parser')  // middleware json to stringy
const sequelize= require('./src/db/sequelize')  // SQL /JS interconnexion
const app = express()
const port = 3000

app
    .use(favicon(__dirname+'/favicon.ico'))
    .use(morgan('dev'))
    .use(bodyParser.json())

sequelize.initDb
app.listen(port, () => console.log(`Notre application Node est démarrée sur : http://localhost:${port}`))

// end points à créer


