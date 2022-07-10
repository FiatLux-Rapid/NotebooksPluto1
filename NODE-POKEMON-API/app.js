// Tuto 1
//console.log("Hello  Node 😄. ")

// tuto 2
// const express = require('express')
// const app = express()
// const port = 3000
// app.get('/', (req, res) => res.send('Hello, Express!'))  
// app.get('/pokemons/1',(req,res)=>res.send('Les informations du pokemon 1'))   // le serveur envoi à la requete du client
// app.listen(port, () => console.log(`Notre application Node est démarrée sur : http://localhost:${port}`))

// tuto 3 le client passe des paramètres au serveur ici id avec http://localhost:3000/api/pokemons/1

// const express = require('express')
// const app = express()
// const port = 3000
// app.get('/', (req, res) => res.send('Hello, Express!')) 
// app.get('/api/pokemons/:id/',(req,res)=>  {
//     const id =req.params.id
//     res.send(`Vous avez demandé le pokemon n°${id} `)
// })

// app.get('/api/pokemons/:id/:name',(req,res)=>  {
//     const id =req.params.id
//     const name =req.params.name
//     res.send(`Vous avez demandé le pokemon n°${id} qui a pour nom ${name}`)
// })
// app.listen(port, () => console.log(`Notre application Node est démarrée sur : http://localhost:${port}`))


// tuto4  mise des pokemons dans le serveur

const express = require('express')
const app = express()
let pokemons = require('./mock-pokemon')

const port = 3000



app.get('/', (req,res) => res.send('Hello again, Express !')) 

app.get('/api/pokemons/:id/',(req,res)=>  {
    const id =parseInt(req.params.id)
    const pokemon= pokemons.find(pokemon => pokemon.id===id)
    res.send(`Vous avez demandé le pokemon n°${pokemon.name} `)   
})

app.get('/api/fiatlux/:epaisseur/:volume',(req,res)=>  {
    const epaisseur =parseFloat(req.params.epaisseur)
    const volume =parseFloat(req.params.volume)
    res.send(`Volume reçu par le serveur: ${volume} et épaisseur ${epaisseur} `)   
})

app.listen(port, () => console.log(`Notre application Node est démarrée sur : http://localhost:${port}`))

//app.listen(port, () => console.log(`Notre application Node est démarrée sur : http://localhost:${port}`))



// app.post('/pokemons/',(req,res)=>res.send('Vous venez d\'ajouter un nouveau pokemon'))
// app.put('/pokemons/',(req,res)=>res.send('Vous souhaitez modifier le pokemeon 1'))
// app.delete('/pokemons/1/',(req,res)=>res.send('Le pokemeon 1 est supprimé'))
