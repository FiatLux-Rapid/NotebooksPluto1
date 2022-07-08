//console.log("Hello  Node 😄. ")

const express = require('express')
const { success, getUniqueId } = require('./helper.js')
const morgan= require('morgan')
const favicon= require('serve-favicon')
const bodyParser=require('body-parser')
let pokemons = require('./mock-pokemon')
const {Sequelize,DataTypes} = require('sequelize')
const PokemonModel= require('./src/models/pokemon')
const app = express()
const port = 3000




const sequelize= new Sequelize(
    'pokedex',  // nom de la base de données
    'root',   // identifiant pour accéder à la base de données : par défaut root
    '',   // mot de passe
    {
        host: 'localhost',
        dialect: 'mariadb',
        dialectOptions: {
            timezone :'Etc/GMT-2'
    } ,
    logging : false
}
)  

const Pokemon=PokemonModel(sequelize,DataTypes)
sequelize.sync({force:true}) 
    .then (_ => {
        console.log('la connexion a bien été établie')

        Pokemon.create({
            name: "Bulbizarre V2",
            hp: 25,
            cp: 5,
            picture: "https://assets.pokemon.com/assets/cms2/img/pokedex/detail/001.png",
            types: ["Plante","Poison"].join()
        }).then(bulbizare => console.log(bulbizare.toJSON()))
    })
    



 



//app.use((req,res,next) => {
//    console.log(`${req.url}`)
//    next()
//})

app
    .use(favicon(__dirname+'/favicon.ico'))
    .use(morgan('dev'))
    .use(bodyParser.json())

app.post('/api/pokemons', (req, res) => {
  const id = getUniqueId(pokemons)
  const pokemonCreated = { ...req.body, ...{id: id, created: new Date()}}
  pokemons.push(pokemonCreated)
  const message = `Le pokémon ${pokemonCreated.name} a bien été crée.`
  res.json(success(message, pokemonCreated))
})

// ...
 
app.put('/api/pokemons/:id', (req, res) => {
    const id = parseInt(req.params.id);
    const pokemonUpdated = { ...req.body, id: id }
    pokemons = pokemons.map(pokemon => {
     return pokemon.id === id ? pokemonUpdated : pokemon
    })
     
    const message = `Le pokémon ${pokemonUpdated.name} a bien été modifié.`
    res.json(success(message, pokemonUpdated))
   });
    
// ...
 
app.delete('/api/pokemons/:id', (req, res) => {
    const id = parseInt(req.params.id)
    const pokemonDeleted = pokemons.find(pokemon => pokemon.id === id)
    pokemons = pokemons.filter(pokemon => pokemon.id !== id)
    const message = `Le pokémon ${pokemonDeleted.name} a bien été supprimé.`
    res.json(success(message, pokemonDeleted))
  });
   
  // ...


app.get('/', (req,res) => res.send('Hello again, Express !'))
 
// On retourne la liste des pokémons au format JSON, avec un message :
app.get('/api/pokemons', (req, res) => {
  const message = 'La liste des pokémons a bien été récupérée.'
  res.json(success(message, pokemons)) 
})
 
app.get('/api/pokemons/:id', (req, res) => {
  const id = parseInt(req.params.id)
  const pokemon = pokemons.find(pokemon => pokemon.id === id)
  const message = 'Un pokémon a bien été trouvé.'
  res.json(success(message, pokemon))
})
  
sequelize.authenticate()
    .then( _ => console.log('connexion OK'))
    .catch(error=>console.error(`connexion impossible ${error}`))

app.listen(port, () => console.log(`Notre application Node est démarrée sur : http://localhost:${port}`))


