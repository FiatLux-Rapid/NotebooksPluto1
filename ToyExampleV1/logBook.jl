### A Pluto.jl notebook ###
# v0.19.9

using Markdown
using InteractiveUtils

# ╔═╡ ad67872f-06ad-4088-be30-ab865dadc003
using WebAPI

# ╔═╡ 600c2e1d-ec3e-4974-b02b-319f77dedff2
using Genie,Genie.Router,Genie.Renderer.Html, Genie.Renderer.Json,Genie.Requests

# ╔═╡ f07fcd5f-807e-4802-8193-2c90a2484b5c
 using HTTP.WebSockets

# ╔═╡ fff8dd7e-d479-4c0b-b6c2-6064584df30a
using HTTP

# ╔═╡ 7fd5df5f-2767-48a2-ab80-d4912dba16e6
begin
	using JuMP
	import Ipopt
end

# ╔═╡ 01482bd8-5371-402d-9571-eed7feeed4cd
using PyCall

# ╔═╡ f7899725-2afe-46de-9586-66727eca0ad5
begin
	using Colors, ColorVectorSpace, ImageShow, FileIO, ImageIO
	using PlutoUI
	using HypertextLiteral
	using JSON
	using Plots
	using InteractiveUtils
end

# ╔═╡ 90abf264-1fe9-4460-830d-50c6e88b4ce0
begin
	using CSV
	using DataFrames
end

# ╔═╡ c34f220e-6706-4661-8f99-7b8d856c015a
md"""
## ToyExampleV2
### API streamlit
* On crée le fichier app.py dans le répertoire ToyExampleV2 (VS code) et on active l'environnement fiatlux pour le terminal pointant sur ce répertoire
* On utilise le tuto *tutoStreamlit.jl* pour réaliser l'API souhaité
* On crée un stream dédié à l'envoi des données API → Julia (via speckle.xyz)
le stream est *https://speckle.xyz/streams/36b6a4554d*
* L'envoi API → Julia a été réalisé dans app.py
```
https://speckle.xyz/streams/36b6a4554d/commits/357903b478
```
l'id de l'objet *14be226ac92562de9f646d6bd88d0d6e*
* Nous allons créé un module julia de réception et de traitement de ce stream (sous la forme d'un notebook *ToyExampleV2Optim.jl*)

Lors de la mise au point nous avons rencontré les problèmes suivants:
* il faut un stream pour chaque envoi
  * depuis l'API python avec le stream ToyeXampleV2_APIJulia
  * Après l'optimisation avec le stream fromJulia
  * Après le traitement par GH avec le stream FromGH


* L'API Python ne remet pas à jour le stream en provenance de Grasshopper, un rafraîchissement de la page remet les conditions V,e à leur état initial (incohérent avec l'objet 3D qui est alors mis à jour): pour régler ce problème nous avons lancé la récupération de l'objet après
  * L'envoi de "submit"
  * Un délai de 5 s pemrettant la prise en compte des traitements (une façon plus sophistiquée consiterait à utiliser une fonction asynchrone basée sur l'arrivé du nouveau stream (comme cela est implémenté dans speckle pour GH avec les fonctions auto receive et auto send))

  * Le notebook julia bien que réactif ne voit pas le changement du nouveau stream (inséré dans un script Python qui ne change pas):

  Cela remet en cause notre architecture privilégiant d'insérer du code python dans un script julia. 
  Il faut probablement faire l'inverse:
    * partir d'un script python qui détecte de façon asynchrone l'arrivée de nouveaux flux.
    * activer alors un script julia
    * Pour activer un notebook particulier Pluto.run(notebook="test.jl")

    * Pour lancer une commande dans python
```Python

import subprocess, sys

computer_name = "L8694C"

p = subprocess.Popen(
    ["powershell.exe", "Get-ADComputer " + computer_name+ " | Select-Object Name"],
    stdout=sys.stdout)

p.communicate()
```

  * Lancement en une ligne julia 

  Nous avons testé 
```console
julia -e 'import Pluto; Pluto.run(notebook="tutoHTML.jl")' 
```
  (qui ne fonctionne pas) alors alors que
```console
julia -e 'import Pluto; Pluto.run()'
``` 
  fonctionne


  * L'option la plus pertinente consiste à décomposer les fonctions avec 
     * un acteur python qui récupère les entrées via Speckle et met les données dans un fichier local (*in.csv*)
Cet acteur peut être un simple API réalisé avec streamlit, localisé chez l'acteur python qui a pour seule fonction d'écrire les données du stream dans in.txt à chaque changement 
     * un acteur julia lors des changements du fichier *in.csv* et qui le traite.
```julia
open("in.txt") do f
       line = 0

         # read till end of file
         while ! eof(f)

            # read a new / next line for every iteration
            s = readline(f)
            line += 1
            println("$line . $s")
         end
       end
```

Il faut que le fichier in.txt soit rafraîchi si le stream change
pip install streamlit-autorefresh


"""

# ╔═╡ 4e5181d5-f0b3-4194-9c4d-c70119db1c11
md"""
### Point d'étape (15/7/2022)

L'architecture logiciel maquêtée présentent plusieurs avantages
* Elle est distribuée dans le cloud: les contributions et les requêtes client peuvent venir de n'importe où dans le monde
* Elle est asynchrone: l'activité n'est pas séquentielle mais les tâches s'activent en tant que de besoin
* Elle est multilangages: les applications peuvent provenir de Julia, Python, Grasshopper...
* Elle conserve la mémoire du passé: on peut revenir à des versions antérieures de logiciel sans avoir eu a se préoccuper des sauvegardes
* Les modifications logiciels (d'où qu'elles proviennent) sont automatiquement actives
* Les logiciels consistituant le coeur des ressources ne peuvent pas être piratés
* Ces logiciels sont mis en oeuvre sans temps de latence car toutes les ressources nécessaires sont déjà chargés et précompilés (Julia). 
*  Le front end est généré par un serveur très léger qui n'a pour fonction que d'établir l'IHM client et le routage des requêtes. Il peut être donc être hébergé sur des sites gratuits.
* On évite pour l'emploi de la solution de Grasshopper intégré dans le cloud, payante au temps passé. Au contraire la version mono-ordinateur (même avec plusieurs instances d'ouverte) devient accessible à tous de part le monde et cela ne nécessite qu'une seule licence. 
* Pour julia on peut activer plusieurs notebooks Pluto indépendant chacun dédié à des tâches spécifiques

**RESTE A FAIRE**
* Mise en œuvre de streamlit pour l'interface client et déploiement
* Réalisation du cas d'école (V2) avec Julia/GH/Streamlit/Speckle/Python
* Mise en œuvre de ModelingToolKit.jl pour le choix automatique des variables à optimiser 
""" 

# ╔═╡ 9824289d-e5c9-4713-9dde-3ddbcd888676
read("D:\2022\FIATLUX_Implementation\NotebooksPluto\ToyExampleV2\in.txt")

# ╔═╡ 8f7cd2bc-d0eb-4681-ac99-37bcab30819b
pwd()

# ╔═╡ 394d2f30-fd0b-11ec-1fc6-8ba50442f9a2

@htl """
  <p align = "center"> <font size = "5" >

Maquettage rapide d'une application FIATLUX

</font> 
"""


# ╔═╡ 62d62d31-132c-4fc9-a0c1-e9507ce92d3e
md"""
> 👍 Il est possible de ne pas lancer une requête si une requête identique avait été préalablement lancée. En effet streamlit conserve l'historique des requêtes précédentes dans des *commits*. Il faut donc balayer l'ensemble des commits archivés pour voir si l'on retrouve les paramètres de la requête souhaitée afin de récupérer, le cas échéant, les résultats déjà archivés avant toute nouvelle requête.

> 👍 Les requêtes archivées peuvent aussi être utilisés à des fins statistiques dans un contexte marketing ou pour servir de base de données pour réaliser un *jumeau digital* directement intégré en front end et qui pourra être utilisé pour de nouvelles requêtes sans passer par le serveur.


> 👍 Il est possible d'ouvrir plusieurs notebook en même temps, il suffit de revenir au menu principal (flèche ← en haut à gauche du navigateur) , copier l'url et l'ouvrir dans un nouvel onglet !

> 👍 Pour créer un module Julia ayant ces propres dépendances, il suffit de se mettre
dans le bon répertoire et de faire sous julia
```julia
import Pkg
] activate
#  Pkg.generate nommDuModule 
```


> 👍 Exécution de Julia en remote [ici]( https://rikhuijzer.github.io/JuliaTutorialsTemplate/getting-started/#without_running_the_site_locally)

> 👍 On peut zoomer dézoomer un notebook Pluto en appuyant sur *Ctrl* en même temps qu'en agissant sur la roulette de la souris

> 👍 Pour éviter l'affichage lié à l'exécution d'une cellule, il suffit de rajouter *nothing* à la fin de la cellule et rien de ne sera afficher
"""

# ╔═╡ 09e67d1b-dddd-4128-9df5-46ea1e664c76


# ╔═╡ 7a6a6e87-56c1-4a7c-b49c-81bda3c82065
md"""
## Réalisation d'un site client FIATLUX maquette

Il existe plusieurs possibilités de framework pour mettre en oeuvre la partie client (front end) et la partie serveur (backend).
**Streamlit** semble le meilleur candidat pour le front end et pour le backend:
* **Speckle** dans grasshopper semble le mieux adapté pour tout ce qui est production 3D ; il activera suivant la route mise ne oeuvre le la réalisation paramétrique correspondante 
* **Pluto** semble me meilleur candidat pour ce qui est dss mises en oeuvre julia, python (via pyCall) et javascript.
"""

# ╔═╡ c5502518-c38b-4b21-806f-52868115d00f
md"""
Un des avantages d'un serveur Grasshopper est qu'il permet de fonctionner avec une instance Grasshopper déjà ouverte donc disponible pour traiter des requêtes graphiques.
De même un serveur Pluto aura toutes ses bibliothèques et fonctions précompilées et pourra donc répondre de façon très rapide à toutes les requêtes.
On peut imaginer des serveurs spécialisés optimisés à traiter des tâches spécifiques

Clients et serveurs fonctionnent en réseau:
* Speckle et Pluto gèrent les requêtes de clients multiples
* Des serveurs en série décompose une tâche complexe en sous-tâches à réaliser successivement
* Des serveurs en parallèle peuvent fournir plusieurs solutions à une requête donnée (site marchand)
* Des serveurs spécialisés en réseau constituent un espace collaboratif

"""

# ╔═╡ 776fa883-806a-45e8-866a-fd9ea49de765
begin

md"""
	
```python
import streamlit as st
import pandas as pd


st.header('FIATLUX client')

e = st.slider('Epaisseur souhaitée pour le verre ?', 0.1, 1.0, 0.2)
st.write('Epaisseur' ,'=', e, 'cm')
V=st.slider('Volume souhaité?', 50.0, 1000.,300.0)
st.write('Volume' ,'=', V, r'$$ cm^3 $$')
```
"""
end

# ╔═╡ 0c7b1103-8533-440b-944e-eca21d739952
md"""
## Réalisation d'un serveur Pluto
Il existe trois possiblités que nous allons tester.

Dans tous les cas il faut que le programme julia à mettre en oeuvre soit un module propre. Pour créer un tel module "sliderServerTest.jl" il doit contenir localement ces propres dépendances. On se place dans le répertoire où devra se trouver le module
```console
cd D:\2022\FIATLUX_Implementation\NotebooksPluto\ToyExampleV1

```
sous Julia:
```julia
begin
let
    import Pkg
    Pkg.activate(".")
    Pkg.generate sliderServerTest
    #Pkg.add("XXX")
end

end
```

* pluto-Rest
#### PlutoSliderServer ( ne tourne que sous linux)

* Installation de [pluto-rest](https://github.com/ctrekker/pluto-rest)
La visio explicative est [ici](https://www.youtube.com/watch?v=cx_mjsmybA8)

Dans une console julia n'import où dans le monde
```julia
import Pkg; Pkg.add("plutoRESTClient")
using PlutoRESTClient
nb=PlutoNotebook("http://localhost:1234/?secret=S6L412Fp","Docs.jl")
```
"""

# ╔═╡ 24bb245c-3fbd-4c17-955c-0f483b0e157a
md"""
 [WebAPI](https://github.com/fonsp/WebAPI.jl)
On écrit explicitement dans le notebook les commandes get et post souhaitées
```julia
begin
using WebAPI

function bhaskara(a, b, c)
    Δ = b^2 - 4*a*c

    Δ < 0 && (Δ = complex(Δ))

    x₁ = (-b + √Δ) / 2a
    x₂ = (-b - √Δ) / 2a
    return x₁, x₂
end

const app = App()

add_get!(app, "/bhaskara/:a/:b/:c") do req
    a = parse(Int, req.params.a)
    b = parse(Int, req.params.b)
    c = parse(Int, req.params.c)
    x₁, x₂ = bhaskara(a, b, c)

    return Dict("x1" => "$x₁", "x2" => "$x₂")
end

add_get!(app, "/bhaskara") do req
    verifykeys(req.query, (:a, :b, :c)) || return Res(400, "Incorrect Query.")

    a = parse(Int, req.query.a)
    b = parse(Int, req.query.b)
    c = parse(Int, req.query.c)
    x₁, x₂ = bhaskara(a, b, c)

    return (x1 = "$x₁", x2 = "$x₂")
end

add_post!(app, "/bhaskara") do req
    verifykeys(req.body, ["a", "b", "c"]) || return Res(400, "Incorrect JSON.")

    a = req.body.a
    b = req.body.b
    c = req.body.c
    x₁, x₂ = bhaskara(a, b, c)

    return Res(201, (x1 = "$x₁", x2 = "$x₂"))
end

serve(app) #Deafult: ip = localhost, port = 8081
end
```

Malheureusement le lancement de cette cellule sur Pluto bloque le notebook. Il faut donc créer un serveur dédié remplissant certaine fonction (sous pluto par exemple) distinct des autres notebooks

"""


# ╔═╡ 61121415-bf02-447d-a4d0-14e4c68829ce
# to import WebAPI
#using Pkg; Pkg.add(url="https://github.com/eliascarv/WebAPI.jl")#, adding rev="master" and/or subdir="tree/master/src


# ╔═╡ 87399a03-8c61-4912-9068-29ee9d49d97f
begin


function bhaskara(a, b, c)
    Δ = b^2 - 4*a*c

    Δ < 0 && (Δ = complex(Δ))

    x₁ = (-b + √Δ) / 2a
    x₂ = (-b - √Δ) / 2a
    return x₁, x₂
end

const app = App()
add_get!(app, "/bhaskara/:a/:b/:c") do req
    a = parse(Int, req.params.a)
    b = parse(Int, req.params.b)
    c = parse(Int, req.params.c)
    x₁, x₂ = bhaskara(a, b, c)

    return Dict("x1" => "$x₁", "x2" => "$x₂")
end

add_get!(app, "/bhaskara") do req
    verifykeys(req.query, (:a, :b, :c)) || return Res(400, "Incorrect Query.")

    a = parse(Int, req.query.a)
    b = parse(Int, req.query.b)
    c = parse(Int, req.query.c)
    x₁, x₂ = bhaskara(a, b, c)

    return (x1 = "$x₁", x2 = "$x₂")
end

add_post!(app, "/bhaskara") do req
    verifykeys(req.body, ["a", "b", "c"]) || return Res(400, "Incorrect JSON.")

    a = req.body.a
    b = req.body.b
    c = req.body.c
    x₁, x₂ = bhaskara(a, b, c)

    return Res(201, (x1 = "$x₁", x2 = "$x₂"))
end

serve(app) #Deafult: ip = localhost, port = 8081
end

# ╔═╡ 74e918fa-d49f-40cc-96a7-af7c8dec803a
1+1

# ╔═╡ e5e6f968-7729-4631-93d9-4acb7e12b82c

md"""
## Réalisation d'un serveur node.js
* Vérifions que node est bien installé sur notre ordinateur
"""


# ╔═╡ c4189247-0959-4e94-b198-db96de500f40
run(`node -v`);

# ╔═╡ eb991f2a-ed86-4c32-bc08-a36434366ce0
myDir=pwd()

# ╔═╡ 879436b4-08e1-43e7-b2fc-8c23733ea889
md"""
Notre répertoire de travail est $(myDir)
"""

# ╔═╡ b0f51d3c-a07c-4ed6-9b4b-5964118936e3
md"""
* On crée un répertoire */serveurNode* dans $(pwd()) et un fichier *app.js* dans ce répertoire
dans lequel on insère (avev vs studio par exemple)
```javascript
console.log("Hello  Node 😄  ")
```
que l'on exécute
```console
node ./serveurNode/app0.js
```
"""

# ╔═╡ c335521d-ec2a-4fc1-b82d-266dad36a02a
run(`node ./serveurNode/app0.js`);

# ╔═╡ 7ed2f250-b63b-4bd4-8ee0-68eba8a493ec
md"""
* Le serveur fonctionne correctement sur ce serveur maquette , nous allons donc réaliser le *vrai* serveur sur un nouveau fichier app.js dans le même répertoire


* on se place dans le répertoire du serveur
```console
cd ./serveurNode
```


* on configure le projet (sous ce répertoire) avec
```console
npm init
```
Ne peut être lancé via pluto, donc le faire à partir d'un terminal VS code

"""

# ╔═╡ ee687a13-6541-4868-9ac8-afb92aeba51e
md"""
Le fichier package.json suivant est automatiquement créé en fonction de nos réponses
```json
{
  "name": "fiatlux_server",
  "version": "1.0.0",
  "description": "node server for a toy FIATLUX example",
  "main": "app.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "author": "JP Brasile",
  "license": "MIT"
}
```


on remplace dans ce package le script avec 

```json
"scripts": {
    "start": "nodemon app.js"
  },
```
et on peut maintenant mettre en oeuvre l'appli avec (sous VS code)
```console
npm run start
```


"""

# ╔═╡ aea1137a-1938-44a9-935a-13acf300cfd0
 nameA=[]

# ╔═╡ 2a1adb70-2498-4982-8d1c-941c78411bb7
begin
 
# Genie Hello World!
# As simple as Hello
route("/hello") do
    "Welcome to Genie!"
end

# Powerful high-performance HTML view templates
route("/html") do
    h1("Welcome to Genie HTML!") #|> html
end

# JSON rendering built in

route("./json/") do
    (:greeting => "Welcome to Genie!") |> json
end	

	route("/hi") do
  		name = params(:name, "Anon")
		
  		"Hello $name"
		push!(nameA,name)
		
				end

	
	
end

# ╔═╡ c8b6d38d-4d2c-47e3-ae15-cfe3237ab160
up(8001, async = true)

# ╔═╡ c8ee01db-2032-4154-9c7c-5f82cf026644
nameA

# ╔═╡ 215afe86-91a8-4330-9240-f0f992e49ef3
md"""
Lz requête *http://127.0.0.1:8001/hi?name=Toto/* montre que le serveur récupère bien le nom
"""

# ╔═╡ 104f2db7-9610-4675-a760-709a2d13c4c9


# ╔═╡ 525e13e1-d2be-4d73-8f9f-68c3e7570357


# ╔═╡ 6a1c5476-ebb2-4584-9a6b-17ea7716b4ce
md"""
#### Réalisation d'une passerelle speckle 
L'évalution a été réalisée avec succès surle  notebook GHServer.jl :
* PyCall permet de passer de julia en python
* Specklepy permet alors 
  * de créer une url (stream) d'échange active (elle est mise en mémoire dans le site speckle.xyz) avec tout l'historique de son utilisation (commit)
  * De bâtir un objet contenant les données à transférer (y compris de type géométrique)
  * De le transférer avec un message
  * L'objet peut alors être reçu en temps réel sur Grasshopper (streamFromGHServer.gx)

**La liaison julia ⟶ Grasshopper est donc établie via internet** 	

"""

# ╔═╡ 7be7820e-23b4-4172-9791-f43a703b5a36
#down()

# ╔═╡ 2360a112-d4f7-415b-82e4-d1d9245b1699
 #run_with_timeout(`node D:/2022/FIATLUX_Implementation/NotebooksPluto/NODE-POKEMON-API/app.js`,50)

# ╔═╡ f631d1aa-7a7a-4ee2-aa3a-9f73893d46e6
pwd()

# ╔═╡ b2fe6b7d-c682-4adc-98dc-ecd5e025bce4

md"""
## Introduction:
Nous allons utiliser
* Grasshopper pour la conception paramétrique d'un objet simple : 
Un verre avec 3 paramètres l'épaisseur `e` des parois, sa hauteur `h`et son rayon `R`.
* Julia pour l'optimisation avec contraintes:
Le verre doit avoir un volume donné en minimisant la part matière nécessaire pour le fabriquer (```π*R²*e+π*(2*e*R-e^2)*(h-e)```)
* Streamlit pour la réalisation du front end: entrées des paramètres et visualisation 3D du verre
* Speckle pour l'interconnexion backend/frontend, l'interconnexion python/Grasshopper et le déploiement.
* Le projet sera synchronisé avec sa sauvegarde sur Github

## Grasshopper et Speckle

Le plugin Speckle de Grasshopper permet la transmission du résultat, disponible sous
`https://speckle.xyz/streams/19bbef82bc?u=b416f52ba5`  (lien sur Grasshopper)

En appuyant sur "share" on obtient sa mise en forme html
```html
<iframe src="https://speckle.xyz/embed?stream=19bbef82bc&transparent=true" width="600" height="400" frameborder="0"></iframe>

```
insérable dans l'HTML

Dans Grasshopper on peut (bouton droit sur les plugins d'envoi et de réception) imposer une mise à jour automatique  pour l'envoi et réception de l'URL quand l'objet est modifié

"""

# ╔═╡ 968dfd5f-89b3-4eb2-949b-b0bd8a12d3a7
@htl """
<iframe src="https://speckle.xyz/embed?stream=19bbef82bc" width="600" height="400" frameborder="0"></iframe>

"""

# ╔═╡ 511adc08-962e-47fa-9a37-7ad3cbe8f085
md"""
## Julia --> Python (via PyCall) --> Speckle

il faut installer streamlit dans l'environnement conda adéquat:
```console
conda create -n toyexampleV1 Python=3.10 
conda activate toyexampleV1
pip install streamlit


voir `https://python-poetry.org/docs/#installation :
(Invoke-WebRequest -Uri https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py -UseBasicParsing).Content | python -
ou encore `pip install poetry`

pip install specklepy
```

Il suffit d'insérer le code python avec py\"\"\"  ...\"\"\"
"""

# ╔═╡ 29e50e5f-2496-43c5-96bd-1cb529383197
#ENV["PYTHON"] = raw"C:\Python39\python.exe" # example for Windows, "raw" to not have to escape: "C:\\Python310-x64\\python.exe"

# ╔═╡ b3b5f9be-5014-4ed5-a8bf-9063f733065b
md"""
## Vérification du bon fonctionnement de streamlit via une console
```console
begin   # execution is OK but interrupt not possible : here with timeout delay 
	mycommand=`streamlit hello`
	run_with_timeout(mycommand,30)  # without timeout run(mycommand)
end;
```
"""

# ╔═╡ 74b5477b-9168-4cd8-aada-d661129ad2cb



# ╔═╡ e52caa5e-dbe6-43d3-aa64-2fa6eda70a4e
1+1

# ╔═╡ a01b63b0-96a5-4aca-86f9-5ef3320b59f0

md"""
## Création d'un client
Voir [ici](https://speckle.guide/dev/py-examples.html) pour le détail des échanges entre python et streamlit

Le client envoie le volume et l'épaisseur du verre

Le client a été intégré dans ce notebook pour des raisons pratiques, en réalité il est extérieur. On créera un frontend streamlit ultérieurement pour le prendre en compte
"""


# ╔═╡ 9522c1f6-4781-4537-ac9d-420bb05584b6
begin   # Le client envoie ses critères  
Jvol=485.0   #Volume objectif (variable julia)
Jépaisseur=1.0  # épaisseur :paramètre fixé par le client
end

# ╔═╡ e49480c8-3d67-4547-93fd-0d96b32085b6
begin
	
# les objets sont envoyés dans Grasshopper GH_Cup.ghx
py"""
# Running this script will pull the latest commit from the main branch
# of the specified stream and duplicate it inside a different branch.
# (branch should exist already or the script will fail

from specklepy.api.client import SpeckleClient
from specklepy.api.credentials import get_default_account, get_local_accounts
from specklepy.transports.server import ServerTransport
from specklepy.api import operations
from specklepy.objects.base import Base
from specklepy.objects.geometry import Point
# The id of the stream to work with (we're assuming it already exists in your default account's server)
streamId = "834e9dc3f1"
#<iframe src="https://speckle.xyz/embed?stream=834e9dc3f1" width="600" height="400" frameborder="0"></iframe>
branchName = "duplicated"


# Initialise the Speckle client pointing to your specific server.
client = SpeckleClient(host="https://speckle.xyz")

# Get the default account
account = get_default_account()
# If you have more than one account, or the account is not the default, use get_local_accounts
# accounts = get_local_accounts()
# account = accounts[0]

# Authenticate using the account token
#client.authenticate(token=account.token)
client.authenticate_with_token(account.token)
# Get the main branch with it's latest commit reference
branch = client.branch.get(streamId, "main", 1)


# Create the server transport for the specified stream.
transport = ServerTransport(client=client, stream_id=streamId)


# TODO: Perform some operation on the received data

newObj = Base()
newObj["Data from client"] = "From client"
newObj["Volume"] = $Jvol  # les variables julia sont passées à Python
newObj["épaisseur"] = $Jépaisseur 
newObj["Point"] =Point.from_coords(1, 1, 1)


# Send the points using a specific transport
newHash = operations.send(base=newObj, transports=[transport])

# you can now create a commit on your stream with this object
commit_id = client.commit.create(
    stream_id=streamId,
    branch_name=branchName,
    object_id=newHash,
    message="Automatic commit created the python starter example",
    source_application="PyStarter"
)

"""
#get value !
	commit_id=py"commit_id"
	#object_id=py"object_id"
print("Successfully created commit with id: ", py"commit_id")



end

# ╔═╡ a840fa7e-b130-4dca-ab55-d11f1e2e1d84
md"""
## Réception des données coté serveur
"""

# ╔═╡ 2c26d100-cabd-4b0d-8b06-2c8436525870
md"""
Les données peuvent être récupérés sous forme d'un objet Speckle (voir ci-dessous). Néanmoins l'extraction des données pertinentes à partir de cet objet sous python n'est pas aisée à partir de la documentation Speckle. En revanche sont extraction via grasshopper est très simple (via le pllugin *receive*) C'est donc cette option que nous retenons pour notre maquettage

Dans la cellule ci-dessous faire "expand data view" . On visualise bien les valeurs de *épaisseur* et *volume* 
"""

# ╔═╡ 0a10ea62-962f-4471-8abf-61008fe52922
# use that stream id to get the stream from the server
@htl """
<iframe src= "https://speckle.xyz/streams/834e9dc3f1/" width="800" height="400" frameborder="0"> </iframe>
"""

# ╔═╡ 8a79af6c-9798-4fa4-8d61-451c5bacf3a4
@htl """
<iframe src= "https://speckle.xyz/streams/19bbef82bc?u=b416f52ba5" width="600" height="400" frameborder="0"> </iframe>
"""


# ╔═╡ 8591ed8f-23aa-46f3-81b0-86f896ca65e3
md""" 
[Possibilité 3D en html](https://github.com/mcneel/rhino-developer-samples/tree/7/rhino3dm#samples) et [ici](https://github.com/mcneel/rhino-developer-samples/tree/7/rhino3dm#samples)
"""

# ╔═╡ 3051c04c-c2e0-4f16-985c-1468c4169306
@htl """
<iframe src= "https://mcneel.github.io/rhino-developer-samples/rhino3dm/js/SampleViewer/02_advanced/" width="600" height="400" frameborder="0"> </iframe>
"""

# ╔═╡ a6e4cc74-f8b0-4b0b-b0bf-30863eed784b
md"""
Dans Grasshopper, nous réceptionnons les données [épaisseur, volume] en provenance du client et nous les sauvegardons dans *ReceiveFromClient.csv*. Elles peuvent donc être récupérées par le serveur sous Julia:
"""

# ╔═╡ 57638089-79c4-4a03-bf12-12290f229eee
begin
	
f=CSV.read("D:/2022/FIATLUX_Implementation/NotebooksPluto/ToyExampleV1/ReceiveFromClient.csv", DataFrame)
	e=f[1,1]
	vol=f[2,1]

end


# ╔═╡ 29173ad3-d9d2-421d-a384-0e54368399ca
f

# ╔═╡ a70ffb37-2fe6-4974-9210-230494608dd8
md"""
## Le programme julia relatif à l'optimisation
A partir de ces données client, le serveur lance l'optimisation:
```julia
begin
	model = Model(Ipopt.Optimizer)
	r,h= nothing, nothing # clear the julia variables
	@variable(model, r >= 0.0)  # le rayon
	@variable(model, h >= 0.0) # la hauteur
	vol=300  # volume objectif cm3
	e=4e-1  # épaisseur du verre
	@NLobjective(model, Min,π*r^2*e+2*π*r*h*e)  # le volume de la part matière est à minimiser
	# On calcule le volume intérieur du verre
	@NLconstraint(model, c, π*(r-e)^2*(h-e)== vol) # "c" est le nom de la contrainte
	optimize!(model);

	r=value(r)  # variable à nouveau julia
	h=value(h)
    [r,h,π*(r-e)^2*(h-e)]  # volume calculé. L'optimum correspond à r=h !
end
```

"""

# ╔═╡ 3dff1720-648d-45f4-ad4c-b69ed624e90f


# ╔═╡ f2c9bcd0-04ea-4df6-b8a1-c2268d3976f5
begin
	model = Model(Ipopt.Optimizer)
	r,h= nothing, nothing # clear the julia variables
	@variable(model,30>= r >= 0.0)  # le rayon
	@variable(model,30>= h >= 0.0) # la hauteur
	#vol=300  # volume objectif cm3
	#e=4e-1  # épaisseur du verre
	@NLobjective(model, Min,π*r^2*e+π*(2r-e^2)*(h-e) ) # le volume de la part matière est à minimiser
	# On calcule le volume intérieur du verre
	@NLconstraint(model, c, (h-e)*(r-e)^2*π== vol) # "c" est le nom de la contrainte
	@NLconstraint(model, c1, h>=e) #
	@NLconstraint(model, c3, r>=e) #
	optimize!(model);

	r=value(r)  # variable à nouveau julia
	h=value(h)
    [r,h,π*(r-e)^2*(h-e)]  # volume calculé. L'optimum correspond à r=h !
  
	htl"""
	"Résultat de l'optimisation: rayon=$(round(r,digits=1)),hauteur=$(round(h,digits=1)), volume=$(round(π*(r-e)^2*(h-e),digits=1)), part matière=$(round(π*r^2*e+π*(2r-e^2)*(h-e),digits=1))
	"""
	
end

# ╔═╡ 78f702d0-e3d1-4259-8a1b-4d181b3ac42f
md"""
## Résultat de l'optimisation --> Grasshopper
Les données nécessaires à Grasshopper pour réaliser la modélisation du verre en 3D sont fournis à Grasshopper via un fichier csv *optimizedDataForGH.csv*
Si les entités réalisant l'optimisation Julia et la modélisation GH était séparées, il faudrait passer par Speckle.
"""

# ╔═╡ 364f4cd7-21a6-4bbd-ba5f-6724c947532a
begin
	# a 2d array of random numbers 
# using write method
numbers=[e r  h vol]
CSV.write("D:/2022/FIATLUX_Implementation/NotebooksPluto/ToyExampleV1/optimizedDataForGH.csv", DataFrame(numbers,:auto),  header = false)  
end

# ╔═╡ 969f480c-f12a-432c-9296-81741a47d8b7
md"""
## Selecting elements
When writing the javascript code for a widget, it is common to **select elements inside the widgets** to manipulate them. In the number-of-clicks example above, we selected the `<span>` and `<button>` elements in our code, to trigger the input event, and attach event listeners, respectively.
There are a numbers of ways to do this, and the recommended strategy is to **create a wrapper `<span>`, and use `currentScript.parentElement` to select it**.
### `currentScript`
When Pluto runs the code inside `<script>` tags, it assigns a reference to that script element to a variable called `currentScript`. You can then use properties like `previousElementSibling` or `parentElement` to "navigate to other elements".
Let's look at the "wrapper span strategy" again.
```htmlmixed
@htl("\""
<!-- the wrapper span -->
<span>
	<button id="first">Hello</button>
	<button id="second">Julians!</button>
	
	<script>
		const wrapper_span = currentScript.parentElement
		// we can now use querySelector to select anything we want
		const first_button = wrapper_span.querySelector("button#first")
		console.log(first_button)
	</script>
</span>
"\"")
```
"""

# ╔═╡ d67ec3a2-7d74-4ba1-bf17-d884fc4c05e7
@htl("""
<!-- the wrapper span -->
<span>
	<button id="first">Hello</button>
	<button id="second">Julians!</button>
	
	<script>
		const wrapper_span = currentScript.parentElement
		// we can now use querySelector to select anything we want
		const first_button = wrapper_span.querySelector("button#first")
		console.log(first_button)
	</script>
</span>
""")

# ╔═╡ b675a03d-df22-41b7-8492-9ed7399aa41d
@htl("""
console.log(first_button)
""")

# ╔═╡ 3b325115-9c50-4beb-b76f-f69712cca8a8
span

# ╔═╡ bf4c4087-103b-4ba6-a73d-b4dc078e66c1
function run_with_timeout(command, timeout::Integer = 5)
           cmd = run(command; wait=false)
            for i in 1:timeout
                if !process_running(cmd) return success(cmd) end
                sleep(1)
            end
            kill(cmd)
            return false
				end;

# ╔═╡ 850e1e36-09e0-4cd9-932e-1121336a145a
begin   # execution is OK but interrupt not possible : here with timeout dely else ouside Julia 
	mycommand=`streamlit hello`
	run_with_timeout(mycommand,20)  # without timeout run(mycommand)
end;

# ╔═╡ a81be1c2-fdda-4fd3-8c90-88335901d3a7
# Pkg.add("Colors")

# ╔═╡ f4ebe983-0375-45dc-b107-a17b74516939
#Pkg.add("ColorVectorSpace")

# ╔═╡ 6b71eb5f-e5d5-40e7-87fb-0b41835a54ce
#Pkg.add("ColorVectorSpace")

# ╔═╡ 2e16679f-ac65-4507-af49-53f0895273a0
#Pkg.add("HypertextLiteral")

# ╔═╡ ffc2d82b-aa46-4f04-93d2-38ef36a172b3
#Pkg.add("DataFrames")

# ╔═╡ 9477d6e7-9bdb-403c-98d6-512ad6f58da2
#Pkg.add("CSV")

# ╔═╡ 8cf32708-2c11-4711-820f-e6964de03804
PlutoUI.TableOfContents(aside=true)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
ColorVectorSpace = "c3611d14-8923-5661-9e6a-0046d554d3a4"
Colors = "5ae59095-9a9b-59fe-a467-6f913c188581"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
Genie = "c43c736e-a2d1-11e8-161f-af95117fbd1e"
HTTP = "cd3eb016-35fb-5094-929b-558a96fad6f3"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
ImageIO = "82e4d734-157c-48bb-816b-45c225c6df19"
ImageShow = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
InteractiveUtils = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
Ipopt = "b6b21f68-93f8-5de0-b562-5493be1d77c9"
JSON = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
JuMP = "4076af6c-e467-56ae-b986-b466b2749572"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PyCall = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"

[compat]
CSV = "~0.10.4"
ColorVectorSpace = "~0.9.9"
Colors = "~0.12.8"
DataFrames = "~1.3.4"
FileIO = "~1.14.0"
Genie = "~4.18.1"
HTTP = "~0.9.17"
HypertextLiteral = "~0.9.4"
ImageIO = "~0.6.6"
ImageShow = "~0.3.6"
Ipopt = "~1.0.2"
JSON = "~0.21.3"
JuMP = "~1.1.1"
Plots = "~1.31.2"
PlutoUI = "~0.7.39"
PyCall = "~1.93.1"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.2"
manifest_format = "2.0"

[[deps.ASL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6252039f98492252f9e47c312c8ffda0e3b9e78d"
uuid = "ae81ac8f-d209-56e5-92de-9978fef736f9"
version = "0.1.3+0"

[[deps.AbstractFFTs]]
deps = ["ChainRulesCore", "LinearAlgebra"]
git-tree-sha1 = "69f7020bd72f069c219b5e8c236c1fa90d2cb409"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.2.1"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "af92965fb30777147966f58acb05da51c5616b5f"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.3"

[[deps.ArgParse]]
deps = ["Logging", "TextWrap"]
git-tree-sha1 = "3102bce13da501c9104df33549f511cd25264d7d"
uuid = "c7e460c6-2fb9-53a9-8c5b-16f535851c63"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Profile", "Statistics", "UUIDs"]
git-tree-sha1 = "4c10eee4af024676200bc7752e536f858c6b8f93"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.3.1"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.CEnum]]
git-tree-sha1 = "eb4cb44a499229b3b8426dcfb5dd85333951ff90"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.2"

[[deps.CSTParser]]
deps = ["Tokenize"]
git-tree-sha1 = "dc96b54b68e930db929403c38c08af71dde6e984"
uuid = "00ebfdb7-1f24-5e51-bd34-a7502290713f"
version = "3.3.4"

[[deps.CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "SentinelArrays", "Tables", "Unicode", "WeakRefStrings"]
git-tree-sha1 = "873fb188a4b9d76549b81465b1f75c82aaf59238"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.10.4"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.Calculus]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f641eb0a4f00c343bbc32346e1217b86f3ce9dad"
uuid = "49dc2e85-a5d0-5ad3-a950-438e2897f1b9"
version = "0.5.1"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "2dd813e5f2f7eec2d1268c57cf2373d3ee91fcea"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.15.1"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "1e315e3f4b0b7ce40feded39c73049692126cf53"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.3"

[[deps.CodeTracking]]
deps = ["InteractiveUtils", "UUIDs"]
git-tree-sha1 = "6d4fa04343a7fc9f9cb9cff9558929f3d2752717"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "1.0.9"

[[deps.CodecBzip2]]
deps = ["Bzip2_jll", "Libdl", "TranscodingStreams"]
git-tree-sha1 = "2e62a725210ce3c3c2e1a3080190e7ca491f18d7"
uuid = "523fee87-0ab8-5b00-afb7-3ecf72e48cfd"
version = "0.7.2"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "ded953804d019afa9a3f98981d99b33e3db7b6da"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.0"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "1fd869cc3875b57347f7027521f561cf46d1fcd8"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.19.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "d08c20eef1f2cbc6e60fd3612ac4340b89fea322"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.9"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[deps.CommonMark]]
deps = ["Crayons", "JSON", "URIs"]
git-tree-sha1 = "4cd7063c9bdebdbd55ede1af70f3c2f48fab4215"
uuid = "a80b9123-70ca-4bc0-993e-6e3bcb318db6"
version = "0.8.6"

[[deps.CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[deps.Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "9be8be1d8a6f44b96482c8af52238ea7987da3e3"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.45.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Conda]]
deps = ["Downloads", "JSON", "VersionParsing"]
git-tree-sha1 = "6e47d11ea2776bc5627421d59cdcc1296c058071"
uuid = "8f4d0f93-b110-5947-807f-2305c1781a2d"
version = "1.7.0"

[[deps.Contour]]
git-tree-sha1 = "a599cfb8b1909b0f97c5e1b923ab92e1c0406076"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.1"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.DataAPI]]
git-tree-sha1 = "fb5f5316dd3fd4c5e7c30a24d50643b73e37cd40"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.10.0"

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "Future", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrettyTables", "Printf", "REPL", "Reexport", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "daa21eb85147f72e41f6352a57fccea377e310a9"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.3.4"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.DiffResults]]
deps = ["StaticArrays"]
git-tree-sha1 = "c18e98cba888c6c25d1c3b048e4b3380ca956805"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.0.3"

[[deps.DiffRules]]
deps = ["IrrationalConstants", "LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "28d605d9a0ac17118fe2c5e9ce0fbb76c3ceb120"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.11.0"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3f3a2501fa7236e9b911e0f7a588c657e822bb6d"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.3+0"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bad72f730e9e91c08d9427d5e8db95478a3c323d"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.8+0"

[[deps.EzXML]]
deps = ["Printf", "XML2_jll"]
git-tree-sha1 = "0fa3b52a04a4e210aeb1626def9c90df3ae65268"
uuid = "8f5d6c58-4d21-5cfd-889c-e3ad7ee6a615"
version = "1.1.0"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "Pkg", "Zlib_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "d8a578692e3077ac998b50c0217dfd67f21d1e5f"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.0+0"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "9267e5f50b0e12fdfd5a2455534345c4cf2c7f7a"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.14.0"

[[deps.FilePathsBase]]
deps = ["Compat", "Dates", "Mmap", "Printf", "Test", "UUIDs"]
git-tree-sha1 = "129b104185df66e408edd6625d480b7f9e9823a0"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.18"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions", "StaticArrays"]
git-tree-sha1 = "2f18915445b248731ec5db4e4a17e451020bf21e"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.30"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "51d2dfe8e590fbd74e7a842cf6d13d8a2f45dc01"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.6+0"

[[deps.GMP_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "781609d7-10c4-51f6-84f2-b8444358ff6d"

[[deps.GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "RelocatableFolders", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "037a1ca47e8a5989cc07d19729567bb71bfabd0c"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.66.0"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "c8ab731c9127cd931c93221f65d6a1008dad7256"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.66.0+0"

[[deps.Genie]]
deps = ["ArgParse", "Dates", "Distributed", "EzXML", "FilePathsBase", "HTTP", "HttpCommon", "Inflector", "JSON3", "JuliaFormatter", "Logging", "Markdown", "MbedTLS", "Millboard", "Nettle", "OrderedCollections", "Pkg", "REPL", "Random", "Reexport", "Revise", "SHA", "Serialization", "Sockets", "UUIDs", "Unicode", "VersionCheck", "YAML"]
git-tree-sha1 = "c3fa75b1f98dbe5f36c55f5e474171ec2fd2c3fc"
uuid = "c43c736e-a2d1-11e8-161f-af95117fbd1e"
version = "4.18.1"

[[deps.GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "83ea630384a13fc4f002b77690bc0afeb4255ac9"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.2"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "a32d672ac2c967f3deb8a81d828afc739c838a06"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.3+2"

[[deps.Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "d61890399bc535850c4bf08e4e0d3a7ad0f21cbd"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.2"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "0fa77022fe4b511826b39c894c90daf5fce3334a"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.17"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.HttpCommon]]
deps = ["Dates", "Nullables", "Test", "URIParser"]
git-tree-sha1 = "46313284237aa6ca67a6bce6d6fbd323d19cff59"
uuid = "77172c1b-203f-54ac-aa54-3f1198fe9f90"
version = "0.5.0"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.ImageBase]]
deps = ["ImageCore", "Reexport"]
git-tree-sha1 = "b51bb8cae22c66d0f6357e3bcb6363145ef20835"
uuid = "c817782e-172a-44cc-b673-b171935fbb9e"
version = "0.1.5"

[[deps.ImageCore]]
deps = ["AbstractFFTs", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Graphics", "MappedArrays", "MosaicViews", "OffsetArrays", "PaddedViews", "Reexport"]
git-tree-sha1 = "acf614720ef026d38400b3817614c45882d75500"
uuid = "a09fc81d-aa75-5fe9-8630-4744c3626534"
version = "0.9.4"

[[deps.ImageIO]]
deps = ["FileIO", "IndirectArrays", "JpegTurbo", "LazyModules", "Netpbm", "OpenEXR", "PNGFiles", "QOI", "Sixel", "TiffImages", "UUIDs"]
git-tree-sha1 = "342f789fd041a55166764c351da1710db97ce0e0"
uuid = "82e4d734-157c-48bb-816b-45c225c6df19"
version = "0.6.6"

[[deps.ImageShow]]
deps = ["Base64", "FileIO", "ImageBase", "ImageCore", "OffsetArrays", "StackViews"]
git-tree-sha1 = "b563cf9ae75a635592fc73d3eb78b86220e55bd8"
uuid = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
version = "0.3.6"

[[deps.Imath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "87f7662e03a649cffa2e05bf19c303e168732d3e"
uuid = "905a6f67-0a94-5f89-b386-d35d92009cd1"
version = "3.1.2+0"

[[deps.IndirectArrays]]
git-tree-sha1 = "012e604e1c7458645cb8b436f8fba789a51b257f"
uuid = "9b13fd28-a010-5f03-acff-a1bbcff69959"
version = "1.0.0"

[[deps.Inflate]]
git-tree-sha1 = "f5fc07d4e706b84f72d54eedcc1c13d92fb0871c"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.2"

[[deps.Inflector]]
deps = ["Unicode"]
git-tree-sha1 = "8555b54ddf27806b070ce1d1cf623e1feb13750c"
uuid = "6d011eab-0732-4556-8808-e463c76bf3b6"
version = "1.0.1"

[[deps.IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[deps.InlineStrings]]
deps = ["Parsers"]
git-tree-sha1 = "d19f9edd8c34760dca2de2b503f969d8700ed288"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.1.4"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "b3364212fb5d870f724876ffcd34dd8ec6d98918"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.7"

[[deps.InvertedIndices]]
git-tree-sha1 = "bee5f1ef5bf65df56bdd2e40447590b272a5471f"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.1.0"

[[deps.Ipopt]]
deps = ["Ipopt_jll", "MathOptInterface"]
git-tree-sha1 = "8b7b5fdbc71d8f88171865faa11d1c6669e96e32"
uuid = "b6b21f68-93f8-5de0-b562-5493be1d77c9"
version = "1.0.2"

[[deps.Ipopt_jll]]
deps = ["ASL_jll", "Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "MUMPS_seq_jll", "OpenBLAS32_jll", "Pkg"]
git-tree-sha1 = "e3e202237d93f18856b6ff1016166b0f172a49a8"
uuid = "9cc047cb-c261-5740-88fc-0cf96f7bdcc7"
version = "300.1400.400+0"

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[deps.IterTools]]
git-tree-sha1 = "fa6287a4469f5e048d763df38279ee729fbd44e5"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.4.0"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.JSON3]]
deps = ["Dates", "Mmap", "Parsers", "StructTypes", "UUIDs"]
git-tree-sha1 = "fd6f0cae36f42525567108a42c1c674af2ac620d"
uuid = "0f8b85d8-7281-11e9-16c2-39a750bddbf1"
version = "1.9.5"

[[deps.JpegTurbo]]
deps = ["CEnum", "FileIO", "ImageCore", "JpegTurbo_jll", "TOML"]
git-tree-sha1 = "a77b273f1ddec645d1b7c4fd5fb98c8f90ad10a5"
uuid = "b835a17e-a41a-41e7-81f0-2f016b05efe0"
version = "0.1.1"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b53380851c6e6664204efb2e62cd24fa5c47e4ba"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.2+0"

[[deps.JuMP]]
deps = ["Calculus", "DataStructures", "ForwardDiff", "LinearAlgebra", "MathOptInterface", "MutableArithmetics", "NaNMath", "OrderedCollections", "Printf", "SparseArrays", "SpecialFunctions"]
git-tree-sha1 = "534adddf607222b34a0a9bba812248a487ab22b7"
uuid = "4076af6c-e467-56ae-b986-b466b2749572"
version = "1.1.1"

[[deps.JuliaFormatter]]
deps = ["CSTParser", "CommonMark", "DataStructures", "Pkg", "Tokenize"]
git-tree-sha1 = "2e9129c034d3b9338d0f77672db5f8b312047689"
uuid = "98e50ef6-434e-11e9-1051-2b60c6c9e899"
version = "0.22.11"

[[deps.JuliaInterpreter]]
deps = ["CodeTracking", "InteractiveUtils", "Random", "UUIDs"]
git-tree-sha1 = "52617c41d2761cc05ed81fe779804d3b7f14fff7"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.9.13"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "46a39b9c58749eefb5f2dc1178cb8fab5332b1ab"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.15"

[[deps.LazyModules]]
git-tree-sha1 = "a560dd966b386ac9ae60bdd3a3d3a326062d3c3e"
uuid = "8cdb02fc-e678-4876-92c5-9defec4f444e"
version = "0.3.1"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "3eb79b0ca5764d4799c06699573fd8f533259713"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.4.0+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "09e4b894ce6a976c354a69041a04748180d43637"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.15"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoweredCodeUtils]]
deps = ["JuliaInterpreter"]
git-tree-sha1 = "dedbebe234e06e1ddad435f5c6f4b85cd8ce55f7"
uuid = "6f1432cf-f94c-5a45-995e-cdbf5db27b0b"
version = "2.2.2"

[[deps.METIS_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "1d31872bb9c5e7ec1f618e8c4a56c8b0d9bddc7e"
uuid = "d00139f3-1899-568f-a2f0-47f597d42d70"
version = "5.1.1+0"

[[deps.MUMPS_seq_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "METIS_jll", "OpenBLAS32_jll", "Pkg"]
git-tree-sha1 = "29de2841fa5aefe615dea179fcde48bb87b58f57"
uuid = "d7ed1dd3-d0ae-5e8e-bfb4-87a502085b8d"
version = "5.4.1+0"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[deps.MappedArrays]]
git-tree-sha1 = "e8b359ef06ec72e8c030463fe02efe5527ee5142"
uuid = "dbb5928d-eab1-5f90-85c2-b9b0edb7c900"
version = "0.4.1"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MathOptInterface]]
deps = ["BenchmarkTools", "CodecBzip2", "CodecZlib", "DataStructures", "ForwardDiff", "JSON", "LinearAlgebra", "MutableArithmetics", "NaNMath", "OrderedCollections", "Printf", "SparseArrays", "SpecialFunctions", "Test", "Unicode"]
git-tree-sha1 = "10d26d62dab815306bbd2c46eb52460e98f01e46"
uuid = "b8f27783-ece8-5eb3-8dc8-9495eed66fee"
version = "1.6.0"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "Random", "Sockets"]
git-tree-sha1 = "891d3b4e8f8415f53108b4918d0183e61e18015b"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.0"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[deps.Millboard]]
git-tree-sha1 = "ea6a5b7e56e76d8051023faaa11d91d1d881dac3"
uuid = "39ec1447-df44-5f4c-beaa-866f30b4d3b2"
version = "0.2.5"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MosaicViews]]
deps = ["MappedArrays", "OffsetArrays", "PaddedViews", "StackViews"]
git-tree-sha1 = "b34e3bc3ca7c94914418637cb10cc4d1d80d877d"
uuid = "e94cdb99-869f-56ef-bcf0-1ae2bcbe0389"
version = "0.3.3"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.MutableArithmetics]]
deps = ["LinearAlgebra", "SparseArrays", "Test"]
git-tree-sha1 = "4e675d6e9ec02061800d6cfb695812becbd03cdf"
uuid = "d8a4904e-b15c-11e9-3269-09a3773c0cb0"
version = "1.0.4"

[[deps.NaNMath]]
git-tree-sha1 = "737a5957f387b17e74d4ad2f440eb330b39a62c5"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.0"

[[deps.Netpbm]]
deps = ["FileIO", "ImageCore"]
git-tree-sha1 = "18efc06f6ec36a8b801b23f076e3c6ac7c3bf153"
uuid = "f09324ee-3d7c-5217-9330-fc30815ba969"
version = "1.0.2"

[[deps.Nettle]]
deps = ["Libdl", "Nettle_jll"]
git-tree-sha1 = "f96a7485d2404f90c7c5c417e64d231f8edc5f08"
uuid = "49dea1ee-f6fa-5aa6-9a11-8816cee7d4b9"
version = "0.5.2"

[[deps.Nettle_jll]]
deps = ["Artifacts", "GMP_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "eca63e3847dad608cfa6a3329b95ef674c7160b4"
uuid = "4c82536e-c426-54e4-b420-14f461c4ed8b"
version = "3.7.2+0"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.Nullables]]
git-tree-sha1 = "8f87854cc8f3685a60689d8edecaa29d2251979b"
uuid = "4d1e1d77-625e-5b40-9113-a560ec7a8ecd"
version = "1.0.0"

[[deps.OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "1ea784113a6aa054c5ebd95945fa5e52c2f378e7"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.12.7"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS32_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c6c2ed4b7acd2137b878eb96c68e63b76199d0f"
uuid = "656ef2d0-ae68-5445-9ca0-591084a874a2"
version = "0.3.17+0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.OpenEXR]]
deps = ["Colors", "FileIO", "OpenEXR_jll"]
git-tree-sha1 = "327f53360fdb54df7ecd01e96ef1983536d1e633"
uuid = "52e1d378-f018-4a11-a4be-720524705ac7"
version = "0.3.2"

[[deps.OpenEXR_jll]]
deps = ["Artifacts", "Imath_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "923319661e9a22712f24596ce81c54fc0366f304"
uuid = "18a262bb-aa17-5467-a713-aee519bc75cb"
version = "3.1.1+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e60321e3f2616584ff98f0a4f18d98ae6f89bbb3"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.17+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.PCRE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b2a7af664e098055a7529ad1a900ded962bca488"
uuid = "2f80f16e-611a-54ab-bc61-aa92de5b98fc"
version = "8.44.0+0"

[[deps.PNGFiles]]
deps = ["Base64", "CEnum", "ImageCore", "IndirectArrays", "OffsetArrays", "libpng_jll"]
git-tree-sha1 = "e925a64b8585aa9f4e3047b8d2cdc3f0e79fd4e4"
uuid = "f57f5aa1-a3ce-4bc8-8ab9-96f992907883"
version = "0.3.16"

[[deps.PaddedViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "03a7a85b76381a3d04c7a1656039197e70eda03d"
uuid = "5432bcbf-9aad-5242-b902-cca2824c8663"
version = "0.5.11"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "0044b23da09b5608b4ecacb4e5e6c6332f833a7e"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.3.2"

[[deps.Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PkgVersion]]
deps = ["Pkg"]
git-tree-sha1 = "a7a7e1a88853564e551e4eba8650f8c38df79b37"
uuid = "eebad327-c553-4316-9ea0-9fa01ccd7688"
version = "0.1.1"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "8162b2f8547bc23876edd0c5181b27702ae58dce"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.0.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "9888e59493658e476d3073f1ce24348bdc086660"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.3.0"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "b29873144e57f9fcf8d41d107138a4378e035298"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.31.2"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "8d1f54886b9037091edf146b517989fc4a09efec"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.39"

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "a6062fe4063cdafe78f4a0a81cfffb89721b30e7"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.2"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.PrettyTables]]
deps = ["Crayons", "Formatting", "Markdown", "Reexport", "Tables"]
git-tree-sha1 = "dfb54c4e414caa595a1f2ed759b160f5a3ddcba5"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "1.3.1"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

[[deps.ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "d7a7aef8f8f2d537104f170139553b14dfe39fe9"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.7.2"

[[deps.PyCall]]
deps = ["Conda", "Dates", "Libdl", "LinearAlgebra", "MacroTools", "Serialization", "VersionParsing"]
git-tree-sha1 = "1fc929f47d7c151c839c5fc1375929766fb8edcc"
uuid = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
version = "1.93.1"

[[deps.QOI]]
deps = ["ColorTypes", "FileIO", "FixedPointNumbers"]
git-tree-sha1 = "18e8f4d1426e965c7b532ddd260599e1510d26ce"
uuid = "4b34888f-f399-49d4-9bb3-47ed5cae4e65"
version = "1.0.0"

[[deps.Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "c6c0f690d0cc7caddb74cef7aa847b824a16b256"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+1"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
git-tree-sha1 = "6bf3f380ff52ce0832ddd3a2a7b9538ed1bcca7d"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.2.1"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "5d7acddc4bf58e37905b32a2aa469b83477fceb4"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.1"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "22c5201127d7b243b9ee1de3b43c408879dff60f"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "0.3.0"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Revise]]
deps = ["CodeTracking", "Distributed", "FileWatching", "JuliaInterpreter", "LibGit2", "LoweredCodeUtils", "OrderedCollections", "Pkg", "REPL", "Requires", "UUIDs", "Unicode"]
git-tree-sha1 = "4d4239e93531ac3e7ca7e339f15978d0b5149d03"
uuid = "295af30f-e4ad-537b-8983-00126c2a3abe"
version = "3.3.3"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[deps.SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "db8481cf5d6278a121184809e9eb1628943c7704"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.3.13"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.Sixel]]
deps = ["Dates", "FileIO", "ImageCore", "IndirectArrays", "OffsetArrays", "REPL", "libsixel_jll"]
git-tree-sha1 = "8fb59825be681d451c246a795117f317ecbcaa28"
uuid = "45858cf5-a6b0-47a3-bbea-62219f50df47"
version = "0.1.2"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "d75bda01f8c31ebb72df80a46c88b25d1c79c56d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.7"

[[deps.StackViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "46e589465204cd0c08b4bd97385e4fa79a0c770c"
uuid = "cae243ae-269e-4f55-b966-ac2d0dc13c15"
version = "0.1.1"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "StaticArraysCore", "Statistics"]
git-tree-sha1 = "9f8a5dc5944dc7fbbe6eb4180660935653b0a9d9"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.5.0"

[[deps.StaticArraysCore]]
git-tree-sha1 = "66fe9eb253f910fe8cf161953880cfdaef01cdf0"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.0.1"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "2c11d7290036fe7aac9038ff312d3b3a2a5bf89e"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.4.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "48598584bacbebf7d30e20880438ed1d24b7c7d6"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.18"

[[deps.StringEncodings]]
deps = ["Libiconv_jll"]
git-tree-sha1 = "50ccd5ddb00d19392577902f0079267a72c5ab04"
uuid = "69024149-9ee7-55f6-a4c4-859efe599b68"
version = "0.3.5"

[[deps.StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "ec47fb6069c57f1cee2f67541bf8f23415146de7"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.11"

[[deps.StructTypes]]
deps = ["Dates", "UUIDs"]
git-tree-sha1 = "d24a825a95a6d98c385001212dc9020d609f2d4f"
uuid = "856f2bd8-1eba-4b0a-8007-ebc267875bd4"
version = "1.8.1"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "5ce79ce186cc678bbb5c5681ca3379d1ddae11a1"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.7.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TextWrap]]
git-tree-sha1 = "9250ef9b01b66667380cf3275b3f7488d0e25faf"
uuid = "b718987f-49a8-5099-9789-dcd902bef87d"
version = "1.0.1"

[[deps.TiffImages]]
deps = ["ColorTypes", "DataStructures", "DocStringExtensions", "FileIO", "FixedPointNumbers", "IndirectArrays", "Inflate", "Mmap", "OffsetArrays", "PkgVersion", "ProgressMeter", "UUIDs"]
git-tree-sha1 = "fcf41697256f2b759de9380a7e8196d6516f0310"
uuid = "731e570b-9d59-4bfa-96dc-6df516fadf69"
version = "0.6.0"

[[deps.Tokenize]]
git-tree-sha1 = "2b3af135d85d7e70b863540160208fa612e736b9"
uuid = "0796e94c-ce3b-5d07-9a54-7f471281c624"
version = "0.5.24"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "216b95ea110b5972db65aa90f88d8d89dcb8851c"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.6"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.URIParser]]
deps = ["Unicode"]
git-tree-sha1 = "53a9f49546b8d2dd2e688d216421d050c9a31d0d"
uuid = "30578b45-9adc-5946-b283-645ec420af67"
version = "0.4.1"

[[deps.URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unzip]]
git-tree-sha1 = "34db80951901073501137bdbc3d5a8e7bbd06670"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.1.2"

[[deps.UrlDownload]]
deps = ["HTTP", "ProgressMeter"]
git-tree-sha1 = "05f86730c7a53c9da603bd506a4fc9ad0851171c"
uuid = "856ac37a-3032-4c1c-9122-f86d88358c8b"
version = "1.0.0"

[[deps.VersionCheck]]
deps = ["Dates", "JSON3", "Logging", "Pkg", "Random", "Scratch", "UrlDownload"]
git-tree-sha1 = "89ef2431dd59344ebaf052d0737205854ded0c62"
uuid = "a637dc6b-bca1-447e-a4fa-35264c9d0580"
version = "0.2.0"

[[deps.VersionParsing]]
git-tree-sha1 = "58d6e80b4ee071f5efd07fda82cb9fbe17200868"
uuid = "81def892-9a0e-5fdd-b105-ffc91e053289"
version = "1.3.0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.WeakRefStrings]]
deps = ["DataAPI", "InlineStrings", "Parsers"]
git-tree-sha1 = "b1be2855ed9ed8eac54e5caff2afcdb442d52c23"
uuid = "ea10d353-3f73-51f8-a26c-33c1cb351aa5"
version = "1.4.2"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "58443b63fb7e465a8a7210828c91c08b92132dff"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.14+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[deps.YAML]]
deps = ["Base64", "Dates", "Printf", "StringEncodings"]
git-tree-sha1 = "3c6e8b9f5cdaaa21340f841653942e1a6b6561e5"
uuid = "ddb6d928-2868-570f-bddf-ab3f9cf99eb6"
version = "0.4.7"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e45044cd873ded54b6a5bac0eb5c971392cf1927"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.2+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libsixel_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "78736dab31ae7a53540a6b752efc61f77b304c5b"
uuid = "075b6546-f08a-558a-be8f-8157d0f608a5"
version = "1.8.6+1"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "ece2350174195bb31de1a63bea3a41ae1aa593b6"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "0.9.1+5"
"""

# ╔═╡ Cell order:
# ╠═c34f220e-6706-4661-8f99-7b8d856c015a
# ╠═4e5181d5-f0b3-4194-9c4d-c70119db1c11
# ╠═9824289d-e5c9-4713-9dde-3ddbcd888676
# ╠═8f7cd2bc-d0eb-4681-ac99-37bcab30819b
# ╟─394d2f30-fd0b-11ec-1fc6-8ba50442f9a2
# ╟─62d62d31-132c-4fc9-a0c1-e9507ce92d3e
# ╠═09e67d1b-dddd-4128-9df5-46ea1e664c76
# ╟─7a6a6e87-56c1-4a7c-b49c-81bda3c82065
# ╟─c5502518-c38b-4b21-806f-52868115d00f
# ╟─776fa883-806a-45e8-866a-fd9ea49de765
# ╠═0c7b1103-8533-440b-944e-eca21d739952
# ╠═24bb245c-3fbd-4c17-955c-0f483b0e157a
# ╠═61121415-bf02-447d-a4d0-14e4c68829ce
# ╠═ad67872f-06ad-4088-be30-ab865dadc003
# ╠═87399a03-8c61-4912-9068-29ee9d49d97f
# ╠═74e918fa-d49f-40cc-96a7-af7c8dec803a
# ╠═e5e6f968-7729-4631-93d9-4acb7e12b82c
# ╠═c4189247-0959-4e94-b198-db96de500f40
# ╠═eb991f2a-ed86-4c32-bc08-a36434366ce0
# ╟─879436b4-08e1-43e7-b2fc-8c23733ea889
# ╟─b0f51d3c-a07c-4ed6-9b4b-5964118936e3
# ╠═c335521d-ec2a-4fc1-b82d-266dad36a02a
# ╟─7ed2f250-b63b-4bd4-8ee0-68eba8a493ec
# ╟─ee687a13-6541-4868-9ac8-afb92aeba51e
# ╠═600c2e1d-ec3e-4974-b02b-319f77dedff2
# ╠═aea1137a-1938-44a9-935a-13acf300cfd0
# ╠═2a1adb70-2498-4982-8d1c-941c78411bb7
# ╠═c8b6d38d-4d2c-47e3-ae15-cfe3237ab160
# ╠═c8ee01db-2032-4154-9c7c-5f82cf026644
# ╠═215afe86-91a8-4330-9240-f0f992e49ef3
# ╟─104f2db7-9610-4675-a760-709a2d13c4c9
# ╠═525e13e1-d2be-4d73-8f9f-68c3e7570357
# ╠═6a1c5476-ebb2-4584-9a6b-17ea7716b4ce
# ╠═7be7820e-23b4-4172-9791-f43a703b5a36
# ╠═f07fcd5f-807e-4802-8193-2c90a2484b5c
# ╠═fff8dd7e-d479-4c0b-b6c2-6064584df30a
# ╠═2360a112-d4f7-415b-82e4-d1d9245b1699
# ╠═f631d1aa-7a7a-4ee2-aa3a-9f73893d46e6
# ╠═b2fe6b7d-c682-4adc-98dc-ecd5e025bce4
# ╠═968dfd5f-89b3-4eb2-949b-b0bd8a12d3a7
# ╟─511adc08-962e-47fa-9a37-7ad3cbe8f085
# ╠═29e50e5f-2496-43c5-96bd-1cb529383197
# ╠═b3b5f9be-5014-4ed5-a8bf-9063f733065b
# ╠═850e1e36-09e0-4cd9-932e-1121336a145a
# ╠═74b5477b-9168-4cd8-aada-d661129ad2cb
# ╠═e52caa5e-dbe6-43d3-aa64-2fa6eda70a4e
# ╠═a01b63b0-96a5-4aca-86f9-5ef3320b59f0
# ╠═9522c1f6-4781-4537-ac9d-420bb05584b6
# ╠═e49480c8-3d67-4547-93fd-0d96b32085b6
# ╟─a840fa7e-b130-4dca-ab55-d11f1e2e1d84
# ╠═2c26d100-cabd-4b0d-8b06-2c8436525870
# ╠═0a10ea62-962f-4471-8abf-61008fe52922
# ╠═8a79af6c-9798-4fa4-8d61-451c5bacf3a4
# ╠═8591ed8f-23aa-46f3-81b0-86f896ca65e3
# ╠═3051c04c-c2e0-4f16-985c-1468c4169306
# ╠═a6e4cc74-f8b0-4b0b-b0bf-30863eed784b
# ╠═29173ad3-d9d2-421d-a384-0e54368399ca
# ╠═57638089-79c4-4a03-bf12-12290f229eee
# ╠═a70ffb37-2fe6-4974-9210-230494608dd8
# ╠═3dff1720-648d-45f4-ad4c-b69ed624e90f
# ╠═f2c9bcd0-04ea-4df6-b8a1-c2268d3976f5
# ╠═78f702d0-e3d1-4259-8a1b-4d181b3ac42f
# ╠═364f4cd7-21a6-4bbd-ba5f-6724c947532a
# ╟─969f480c-f12a-432c-9296-81741a47d8b7
# ╠═d67ec3a2-7d74-4ba1-bf17-d884fc4c05e7
# ╠═b675a03d-df22-41b7-8492-9ed7399aa41d
# ╠═3b325115-9c50-4beb-b76f-f69712cca8a8
# ╠═7fd5df5f-2767-48a2-ab80-d4912dba16e6
# ╠═01482bd8-5371-402d-9571-eed7feeed4cd
# ╠═bf4c4087-103b-4ba6-a73d-b4dc078e66c1
# ╠═a81be1c2-fdda-4fd3-8c90-88335901d3a7
# ╠═f4ebe983-0375-45dc-b107-a17b74516939
# ╠═6b71eb5f-e5d5-40e7-87fb-0b41835a54ce
# ╠═2e16679f-ac65-4507-af49-53f0895273a0
# ╠═f7899725-2afe-46de-9586-66727eca0ad5
# ╠═ffc2d82b-aa46-4f04-93d2-38ef36a172b3
# ╠═9477d6e7-9bdb-403c-98d6-512ad6f58da2
# ╠═90abf264-1fe9-4460-830d-50c6e88b4ce0
# ╠═8cf32708-2c11-4711-820f-e6964de03804
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
