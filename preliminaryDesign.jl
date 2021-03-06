### A Pluto.jl notebook ###
# v0.19.9

using Markdown
using InteractiveUtils

# ╔═╡ 3e151178-a5f2-4db4-a847-2ef697bb20af
begin
	using JuMP
	import Ipopt
end


# ╔═╡ dfd14873-9245-4faf-a22f-05369b6a195f
using PyCall

# ╔═╡ 59edcf90-f222-11ec-0710-cf30cec93c3d
begin
	using Colors, ColorVectorSpace, ImageShow, FileIO, ImageIO
	using PlutoUI
	using HypertextLiteral
	using JSON
	using Plots
	using InteractiveUtils
end

# ╔═╡ c49dec22-9c65-46b3-b59b-503553be2181
#https://htmlcheatsheet.com/

# ╔═╡ 67e1a008-bebc-4901-b13d-4b6c5b2849cb
md"""
## Logbook
Il y a un problème pour hops avec julia implanté dans python.
appV6.py fonctionne correctement tant que jz est une fonction purement python mais ne fonctionne pas quand c'est une fonction julia. Alors que en effectuant python ligne à ligne cela fonctionne.


**Guide · PythonCall & JuliaCall**


https://cjdoris.github.io/PythonCall.jl/dev/pythoncall/


**juliacall · PyPI**
https://pypi.org/project/juliacall/


**Tutorials - Speckle - The Platform For 3D Data**
https://speckle.systems/tutorials/


**Create Your First Speckle App using only Python 🐍**
https://www.google.com/amp/s/speckle.systems/tutorials/create-your-first-speckle-app-using-only-python/amp/

"""


# ╔═╡ ac812745-7bd6-400e-a8ec-e7308c56133c
md"""
L'emploi de Speckle pour assurer des script python a été validé dans main.py (répertoire *pythonInSpecke*): lorsque l'on active dans GH *SpeckleSendReceive.gh* l'historique est mis a jour dans *http://localhost:8501/*
"""

# ╔═╡ 304eec7c-4dec-4feb-b66b-65affd6e8fad
@htl """
 <p>appV6.py: OK if hops output function is pure Python. KO if its integrates Julia code</p>
      <img src = "https://raw.githubusercontent.com/FiatLux-Rapid/NotebooksPluto1/master/images/appV6.PNG" alt = "Test Image" width = "800" height = "500"  border = "5" align = "left"/>
"""


# ╔═╡ cb32bb73-e448-4d0b-9cdb-8b6ee7fb2574
md"""
## Speckle python application
"""

# ╔═╡ 31677e3d-7a2d-4753-9dc0-0a53082e6cd8
html"""   
   <a href = "https://www.google.com/amp/s/speckle.systems/tutorials/create-your-first-speckle-app-using-only-python/amp/" target = "_self">Create Your First Speckle App using only Python 🐍
</a>
"""


# ╔═╡ f470427b-72ca-429c-81f1-9a388d33e99e
md"""
>Les notebooks *Pluto* peuvent être exécutés à partir d'un environneemnt Julia soit localement soit à partir de leur URL . Ils peuvent exécuter du code Julia. Les cellules sont activées seulement si nécessaire pour conserver la cohérence d'ensemble (on ne peut affecter qu'une valeur à une variable, les cellules qui l'impliquent sont alors remises automatiquement à jour). L'ordre des cellules n'a pas d'importance pour la production du résultat. Les notebooks  *Pluto* offrent aussi toutes les possibilités de mise en forme (HTML/CSS, MarkDown) et de mise en oeuvre (Javascript). 
>Ils peuvent être exportés en pur html ou pdf.
>
>Pour rendre leurs exécutions indépendantes de l'utilisateur, il faut que tous les fichiers attachés soient accessibles par le net. 
"""

# ╔═╡ 42624349-193f-44d7-94c5-9c1e7f1eced7
md"""
## Création d'un site web avec streamlit
https://streamlit.io/
"""

# ╔═╡ 2dac349e-a825-45b5-8947-7c69729bea7c
md"""
> [Streamlit a été racheté par Snowflake pour 800 M\$ ! ]  (https://www.finsmes.com/2022/03/snowflake-to-acquire-streamlit-for-reportedly-800m.html#:~:text=Snowflake%20(NYSE%3A%20SNOW)%2C,deal%20was%20reportedly%20%24800m.)( publié le 7 mars 2022),ce qui montre l'importance de ce logiciel auprès des investisseurs
"""

# ╔═╡ bbce6e6a-3b95-4718-9c01-6b31d7b39338
function run_with_timeout(command, timeout::Integer = 5)
           cmd = run(command; wait=false)
            for i in 1:timeout
                if !process_running(cmd) return success(cmd) end
                sleep(1)
            end
            kill(cmd)
            return false
				end;

# ╔═╡ 6e7360a1-e684-466d-be83-1918826c54b7
md"""
> 👍	Il est possible de proposer un accès payant à un utilisateur de FIATLUX en validant son accès pour une durée donnée avec le programme ci-après:
"""

# ╔═╡ a7b8fdd4-fe61-4725-9380-e94cb7acbfd5
begin   # execution is OK but interrupt not possible : here with timeout dely else ouside Julia 
	mycommand=`streamlit hello`
	run_with_timeout(mycommand,10)  # without timeout run(mycommand)
end;

# ╔═╡ eb7950dc-b59e-48ee-845b-d87bfc4f4edd
md"""
> 👍	Il est impossible (sous Windows) d'arreter une commande telle que run(`streamlit hello'). La fonction *run\_with\_timeout* l'arrête passé un certain délai
"""

# ╔═╡ 9d3b1a73-da29-4862-9293-5582b7adf117
md"""
> 👍	Streamlit permet de **créer un site web** en une ligne de code à partir d'un fichier python interne ou externe (via https://gist.github.com/). On peut faire en sorte que *la page web se modifie si l'on fait évoluer le code correspondant*. Un example a été réalisé en suivant [*streamlit*](https://docs.streamlit.io/library/get-started/create-an-app )

Il suffit de faire:

* conda activate fiatlux
* streamlit run https://gist.githubusercontent.com/FiatLux-Rapid/b51a332532d07e30fd83a84c62cbb933/raw/e98cd08ac6bf50bae42d6e84351b98c9aae631a0/streamlit_example.py

[Pour **apprendre streamlit en un mois** (et *en français* !)](https://github.com/streamlit/30days-French)

En particulier (day 7) nous avons connecté github à Streamlit Cloud afin de synchroniser github avec streamlit: [exemple de déploiement](https://fiatlux-rapid-notebo-streamlite-90days-tutostreamlit-app-v2ovvi.streamlitapp.com/)

Un [tuto plus approfondi](https://docs.streamlit.io/library/components/components-api) permet les échanges bidirectionels entre utilisateur disposant d'un navigateur et un développeur disposant de python. [Clickez ici pour un démarrage rapide](https://github.com/streamlit/component-template)
"""

# ╔═╡ 78cbf7a2-168a-4212-941e-7b95b3f514cc
@htl """
<iframe src="https://speckle.xyz/embed?stream=19bbef82bc" width="600" height="400" frameborder="0"></iframe>
<br>
<div align = "middle" > <p>Le lien est directement récupéré à partir de speckle.xyz</centered> </p> </div>
"""

# ╔═╡ 777d1647-fe64-4a8f-8935-fcbd47ff3ea4
md"""
### Activation site web streamlit
```console 
 conda activate fiatlux
 streamlit run D:\2022\FIATLUX_Implementation\NotebooksPluto\streamlite_90days_tuto\streamlit_app.py
```
streamlit_app.py contient l'html:

```console
html_string = '<iframe src="https://speckle.xyz/embed?stream=19bbef82bc" width="600" height="400" frameborder="0"></iframe>'
st.markdown(html_string, unsafe_allow_html=True)
```
"""

# ╔═╡ 6b22f0d1-1ad0-489d-8b43-4d2b18ce1fe3
md"""
déploiement: par example
https://fiatlux-rapid-notebook-createcomponentinfrontendmyscript-rsyejx.streamlitapp.com/
"""


# ╔═╡ 8a486868-fba6-4564-b7fc-3f23f3622d02
md"""
## Un maquettage rapide et minimaliste des fonctionnalités FIATLUX
L'objectif est de faire une application *FiatLux* minimaliste intégrant ses principales fonctions; l'objectif est de réaliser un verre (impression 3D) avec le volume maximal pour une quantité de matière donnée avec les paramètres:
* e=épaisseur (mm)
* r=rayon (cm)
* h=hauteur (cm)
* q=quantité de matière (cm$$^3$$)
Grasshopper réalise le verre en 3D, Julia fait l'optimisation, Speckle la transmission des données entre l'utilisateur ( et son navigateur) et le développeur
### * Code en julia pour l'optimisation
!!! note
    ```julia
	begin
	    using JuMP
	    import Ipopt 
		model = Model(Ipopt.Optimizer)
		r,h= nothing, nothing # clear the julia variables
		@variable(model, r >= 0.0)
		@variable(model, h >= 0.0)
		vol=3*π
		e=1
		@NLobjective(model, Max, π*r^2*h)
		@NLconstraint(model, c, π*r^2*e+2*π*r*h*e== vol)
		optimize!(model)
		@show [value(r),value(h)];
	end
    ```

### * Modèle Grasshopper
Partons de l'existant avec [*cette réalisation*](http://wiki.iad.zhdk.ch/wiki/download/thumbnails/743604339/image2017-11-23_22-52-16.png?version=1&modificationDate=1578151744396&cacheVersion=1&api=v2&width=811&height=250) en suivant [ce guide](http://wiki.iad.zhdk.ch/DT/743604339/Grasshopper+Basics). Le fichier GH correspondant est *GH_Cup.ghx*.
Nous avons ensuite rajouté l'envoi du résultat 3D via le plugin Speckle.
On peut alors accéder à ce modèle 3D via l'[url](https://speckle.xyz/streams/19bbef82bc/commits/3ad77a0980?c=%5B0.17717,0.19543,0.18226,-0.01664,0.00163,0.06501,0,1%5D)

L'hisorique de ce stream est conservé [ici](https://speckle.xyz/streams/19bbef82bc/branches/main)


### * Connexion Navigateur utilisateur ↔  Développeur en Python

Nous allons utiliser streamlit, SpecklePy en suivant [*ces instructions*](https://speckle.systems/tutorials/create-your-first-speckle-app-using-only-python/) et [cette video](https://www.youtube.com/watch?v=17UOP4XLim8&list=PLlI5Dyt2HaEu83rSRNGmgaDgSl7ytrS4M)

Commençons par un [exemple simple en python](https://github.com/specklesystems/speckle-examples/tree/main/python/speckle-py-starter) 

Dans le fichier [02_create_and_send.py](D:\2022\FIATLUX_Implementation\NotebooksPluto\ToyExample\simpleExample\python\speckle-py-starter\02_create_and_send.py) il faut remplacer ligne 12 avec un stream créé via speckle.xyz et une nouvelle branche nommée duplicated

Il faut aussi installer graphql
```console
npm init
npm install graphql --save
```

Example javascript : Il faut un token créé sur speckle.xyz (rubrique *profile* ):17a898dbd280df9e42ef5a29676776e126b8418b18
  8557c57f7fe475ae727995bb4dbc0ee644aed7470f
Il faut que le stream soit public pour qu l'application fonctionne. 
Pourle guide utilisateur de cette fonctionnalité voir [ici](https://speckle.guide/user/web.html)
"""

# ╔═╡ 7cd284b6-28b5-41ad-b068-2a4858f1f31f
begin
	model = Model(Ipopt.Optimizer)
	r,h= nothing, nothing # clear the julia variables
	@variable(model, r >= 0.0)
	@variable(model, h >= 0.0)
	vol=9
	e=1e-1
	@NLobjective(model, Max, π*r^2*h)
	@NLconstraint(model, c, π*r^2*e+2*π*r*h*e== vol)
	optimize!(model);
	[value(r),value(h)];
    
end

# ╔═╡ df67c439-0652-462e-bd98-9b6e106ea161
value(π*r^2*e+2*π*r*h*e)

# ╔═╡ 2c057af3-a2cc-46ea-bb2c-4138d8ba90d5
md"""
## Logbook Juillet 2022
"""

# ╔═╡ 84d2d0cf-8d76-41ad-92cb-f28d5968ae56
md"""
## * Connexion Julia (pluto notebook) --> Python
Intégration du code python dans julia
"""

# ╔═╡ 2e8b7a78-0f86-4a8d-b431-d8b116357bc2
md"""  
### PythonCall & JuliaCall
https://cjdoris.github.io/PythonCall.jl/dev/pythoncall/
https://docs.juliahub.com/PythonCall/WdXsa/0.5.0/juliacall/
using PythonCall;
Testé mais finalement replis sur PyCall 
"""

# ╔═╡ f6891298-6ebd-4e61-bfa8-00689228d1a4
begin
	ENV["JULIA_CONDAPKG_BACKEND"] = "System"
end

# ╔═╡ ccbb292d-b24a-4279-9299-8365f13438ed
md"""
### Julia --> Python (via PyCall) --> Speckle
Il suffit d'insérer le code python avec py\"\"\"  ...\"\"\"
"""

# ╔═╡ 7b2cf1cc-ef3c-4b8f-8d4f-8af3a5f65609
ENV["PYTHON"] = raw"C:\Python39\python.exe" # example for Windows, "raw" to not have to escape: "C:\\Python310-x64\\python.exe"


# ╔═╡ fddd1551-776e-4fd1-ae37-0f7e8cc7bca1
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
newObj["myTextProp"] = "Some text value"
newObj["rayon bas verre"] = 70
newObj["mySpeckleProp"] = Point.from_coords(1, 1, 1)


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
print("Successfully created commit with id: ", py"commit_id")

end

# ╔═╡ 911e1c44-d330-4ad8-a4e4-59c1521e6a2c
md"""
Envoi/réception de données avec streamlit voir 
D:\2022\FIATLUX_Implementation\NotebooksPluto\CreateComponentinFrontEnd


https://discuss.streamlit.io/t/code-snippet-create-components-without-any-frontend-tooling-no-react-babel-webpack-etc/13064


"""

# ╔═╡ c5c80272-443b-4292-af3d-bb2bfee4a40c
md"""
## Didacticiel NodeJS 
voir [ici](https://raw.githubusercontent.com/FiatLux-Rapid/NotebooksPluto1/master/tutoNodeJS.jl)
"""

# ╔═╡ 55166b92-58bd-4471-b42e-7019a1b028b1
md"""
> 👍 On peut maintenant mettre en oeuvre des notebook pluto sans installation particulière:
>en cliquant [ici](https://hub-binder.mybinder.ovh/user/fonsp-pluto-on-binder-ddk4whca/pluto/edit?id=8b72d70e-fcfe-11ec-2f59-8b93ec7b06c5&token=cQJnOc_mTJWEfYrfhMlQ6Q) par exemple
"""

# ╔═╡ a375945e-ff05-4639-b9b8-57160c77a6a5
md"""
## Maquettage rapide d'une application FIATLUX V2

Nous allons utiliser
* Grasshopper pour la conception paramétrique d'un objet simple : 
Un verre avec 3 paramètres l'épaisseur `e` des parois, sa hauteur `h`et son rayon `R`.
* Julia pour l'optimisation avec contraintes:
Le verre doit avoir un volume donnée en minimisant la matière nécessaire pour le fabriquer (```π*R²*e+2*π*R*h*e```)
* Streamlit pour la réalisation du front end: entrées des paramètres et visualisation 3D du verre
* Speckle pour l'interconnexion backend/frontend, l'interconnexion python/Grasshopper et le déploiement.
* Le projet sera synchronisé avec sa sauvegarde sur Github

"""

# ╔═╡ 4d3548c4-3396-428d-a5d8-38dd7d8f9eb6
md"""
## Lots de travaux
"""

# ╔═╡ 649c99a2-1603-42fe-980c-b6d102f9c01b
md"""
### 1. Lot 1: Avant-projet (durée 6 mois)
#### 1.1 Spécification du logiciel FIATLUX
Le logiciel s'adresse à trois types d'utilisateurs : les *développeurs* (qui disposent des ressources logiciel FiatLux), les *étudiants* (qu'il faut former aux outils de base) et les *utilisateurs finaux* (qui ne dispose que d'un navigateur)
1. Réalisation de notebooks de formation dans l'esprit de [*Introduction to computational thinking*](https://computationalthinking.mit.edu/Spring21/) 
1. *Interconnexion Julia Grasshopper*
    * en local (plugin Julia) 
    * via le cloud
2. Contrôle collaboratif à distance d'un Rhino Grasshopper (GH 🦗)
3. Programmation visuelle hiérarchique (pour éviter l'effet *"spaghetti"*)
4. Interconnexion navigateur *utilisateurs finaux* / sites *développeur*
5. Porter la bibliothèque [SciML](https://sciml.ai/) en programmation visuelle (au moins partiellement)
5. Créer un environnement multi-utilisateurs (avec node.js)
6. Porter la bibliothèque [OpenModelica](https://www.openmodelica.org/) dans [ModelingToolKit](https://github.com/SciML/ModelingToolkit.jl)
7. Stockage des données FIATLUX sur le cloud via [GitHub](https://github.com/) et [Speckle](https://speckle.systems/) avec automatisation de la gestion des évolutions logiciel. [lien pour automatiser GitHub](https://resources.github.com/devops/tools/automation/actions/) 
8. *Mise en place* et *interconnexion* de ressources logiciel comme python3,excel...
9. Lien via le cloud entre les *utilisateurs finaux* et le *ou les* sites *développeurs*. 
10. *Digital twins* : L'optimisation automatique nécessite de réaliser de nombreuses boucles afin de converger vers le résultats optimum cela est possible en réalisant des modèles jumeaux des modèles (en général lourd de mise en œuvre) définissant le process à optimiser.
11. La *marche des Sphères* : pour résoudre des problèmes physiques incluant une géométrie complexe
12. Outils permettant la création d'un site dédié aux *utilisateurs finaux* pour une application spécifique.
13. Liaison de FIATLUX avec l'impression 3D
14. Liaison de FIATLUX avec la mise en oeuvre sur microcontrôleur
15. Outils permettant d'accéder aux ressources FIATLUX disponibles avec un exemple de mise en œuvre pour chacun d'entre eux.


**L'objectif du lot 1.1 est d'établir l'avant projet de FIATLUX en explorant les pistes susceptibles de développer les briques précédemment listées.** 

Cette liste pourra être compléter suite au retour d'expérience du lot 1.2

"""

# ╔═╡ 9ba3692e-cd7e-4480-bc7b-2f2b3af7e6d4
md"""
#### 1.2 Tâches à automatiser pour le conditionnement électrique
1. Génération et simplification automatique et symbolique des équations d'un circuit électrique (convertisseurs)
1. Simulation différentiable du circuit
1. Optimisation de son pilotage par analyse des espaces d’état
1. Modélisation électromagnétique 3D et thermique par la marche des sphères 
1. Modélisation  et optimisation de bout en bout du transformateur (jusqu'aux pièces imprimées en 3D):
* applications en mode pulsé
* applications en mode continu
1. Association de convertisseurs en réseau (via fibre optique et/ou Wifi)
1. Programmes des microcontrôleurs et de l’IHM générés automatiquement ( automates à états  finis, PWM…) 

**L'objectif du lot 1.2 est d'établir l'avant projet de FIATLUX en explorant les pistes susceptibles de développer les briques précédemment listées.**

Cette liste pourra être compléter suite au retour d'expérience du lot 1.1
"""

# ╔═╡ d038e213-b29b-4027-a788-0822e3368015
md""" 
### Réalisation de notebooks de formation
"""

# ╔═╡ 97f65e05-05ea-4785-9707-6c53560356b5
md" voir [pour la formation HTML,CSS,Markdown et Javascript](https://github.com/FiatLux-Rapid/NotebooksPluto1/blob/master/tutoHTML.jl.html) "

# ╔═╡ d683a576-b1f0-4635-b23f-c64e3afbbce9
md"""
### [Speckle short video introduction](https://youtu.be/B9humiSpHzM)
"""


# ╔═╡ bd3e5ff0-b513-4890-9bee-19a39e87a62e

md"""
### Envoi et réception de données de GH à GH remote
"""


# ╔═╡ 02c9a9ac-ef95-4278-a507-af3f345c0279
@htl """
<p align = "center" > <font size = "4" >  GH ↔️ ☁️  ↔️ GH  </font>  </p>
"""

# ╔═╡ 8fb5c378-95a9-4f66-8908-4abac0ae7d07
md"""
Ouvrir [speckle.xyz](https://speckle.xyz/) pour obtenir un lien de de communication (new stream)
Dans les exemples qui suivent, un seul fichier Grasshopper est mis en oeuvre pour l'envoi et la réception de données. En pratique l'envoi et la réception sont délocalisés 

Dans GH mettre ce lien comme chemin du plugin "send" et "receive".
L'envoi et réception peut être fait manuellement ou automatiquement suivant la configuration des plugins: [implantation dans GH](https://github.com/FiatLux-Rapid/NotebooksPluto1/blob/master/images/SendReceiveRemote.PNG?raw=true)

[L'historique des échanges est accessible dans speckle.xyz](https://github.com/FiatLux-Rapid/NotebooksPluto1/blob/master/images/HistoriqueSpeckle.PNG?raw=true)
"""

# ╔═╡ f6eafdaa-b23a-4ac2-a1a7-008fd0ba1ed5
md"""

Les données transmisent peuvent être des objets GH comme un cercle dans l'exemple suivant:
> [Le fichier gh correspondant](https://github.com/FiatLux-Rapid/NotebooksPluto1/blob/f9b79f98d9ad2d60ddde71c40c9e76031f428e9a/grasshopper/SpeckleSendReceived.gh)
"""

# ╔═╡ 4e04718d-2804-4ef8-b012-79c78a98fadd
md"""
### Collecte données texte à partir de GitHub


[GH envoi et réception de données délocalisée](https://github.com/FiatLux-Rapid/NotebooksPluto1/blob/master/images/send_receiveSpeckle.png?raw=true)  
"""

# ╔═╡ 2afdefcf-3786-4fc3-843a-22d962627850


# ╔═╡ 4e40bdd7-cdc8-4241-b086-82f365c74d4e
md"""
> 👍	Il est possible de récupérer les données d'un fichier texte situé sur GitHub dans Grasshopper"
> Il suffit de récupérer le lien en surlignant les données à récupérer dans GitHub, puis click droit pour trouver le lien. Un simple traitement des données est alors [mis en oeuvre dans GH](https://github.com/FiatLux-Rapid/NotebooksPluto1/blob/master/images/CollectDataFromGitHubinGH.PNG?raw=true) pour "nettoyer" les données

"""


# ╔═╡ bbcf9a3b-6643-4940-a75a-581787e75a53


# ╔═╡ 745b0658-f0ed-467e-ad16-473db9a40a5d
md"""
### Lot 2 : Développement logiciel(durée 30 mois)
### Lot 3 : Application au conditionnement électrique (durée 30 mois)

"""


# ╔═╡ 523d898c-4eb7-4e74-a3af-d59e32ee3935
md"""
## Ressources
"""

# ╔═╡ f558baf4-d69c-4062-84e0-f24aa5bf9ed8
md"""
#### Julia code expansion 
"""

# ╔═╡ 9656c208-22af-47d4-9c9c-ef27151913b4
details(x, summary="Show more") = @htl("""
	<details>
		<summary>$(summary)</summary>
		$(x)
	</details>
	""")

# ╔═╡ ad6ab075-fd5a-4631-8312-0edd441e7565
details(md""" 


#### [Création d'un compte GitHub avec qqes astuces](https://github.com/join?plan=free&ref_cta=Join%2520for%2520free&ref_loc=cards&ref_page=%2Fpricing&source=pricing-card-free)

> + Le nom est FiatLux-Rapid et le password FiatLux-01
> + mail @ jp.brasile@gmail.com
> + Ensuite lancer github avec le password, github demandera le code qu'il a envoyé par mail pour valider la création

Nous allons sauvegarder le notebook d'abord manuellement puis automatiquement pour ses mises à jour
##### Mise à jour manuelle
On créer le répertoire FiatLux-notebook en suivant [*les instructions*](https://gist.github.com/mindplace/b4b094157d7a3be6afd2c96370d39fad#file-git_and_github_instructions-md)

add file tutoHTML.jl drag and drop  commit 

On récupère son [url](https://github.com/FiatLux-Rapid/NotebooksPluto/blob/f11a43dacf65c3959cdbcf9207aa05f6d84ed373/tutoHTML.jl) (copy permalink)
...que l'on peut lancer en mettant cette url comme lien du notebook pluto à ouvrir

##### Contrôle via GitHub Desktop 
1. Télécharger [Github Desktop](https://desktop.github.com/)
2. Connexion git local <--> Github : file /options/ 
3. ajout du répertoire (ctrl O dans github desktop) D:\...\NotebooksPluto
4. commit to master
5. push to github

> 👍	La visualisation d'un fichier html peut être faite en l'ouvrant avec *Visual Studio Code* et en cliquant sur "Go Live"

> 👍   Pour afficher un html dans un navigateur, il faut soit imoprter tout le repository de Github soit le seul fichier html (ctl C, Ct v dans WordPad avec un nom se terminant par .html) 

> 👍  le rajout d'un emoji se fait en le trouvant sur le [net](https://gist.github.com/rxaviers/7360908) et couper coller !

""",
	md"""
### Gestion des historiques avec git et Github
""")

# ╔═╡ 9692a16c-e9e8-484e-aa7a-2933d5c60a5d
details(md"""
```julia
function func(x)
    # ...
end
```
""","func(x)")


# ╔═╡ f7977fc7-610c-491b-a7ca-2c433169f103
details(md"""
#### title
hidden title
    ""","test")

# ╔═╡ e67654b3-e7de-47ad-b72c-cf80b2f0f992
details(md"""
	```htmlmixed
	<script type="module" id="asdf">
		//await new Promise(r => setTimeout(r, 1000))

		const { html, render, Component, useEffect, useLayoutEffect, useState, useRef, useMemo, createContext, useContext, } = await import( "https://cdn.jsdelivr.net/npm/htm@3.0.4/preact/standalone.mjs")

		const node = this ?? document.createElement("div")

		const new_state = $(json(state))

		if(this == null){

			// PREACT APP STARTS HERE

			const Item = ({value}) => {
				const [loading, set_loading] = useState(true)

				useEffect(() => {
					set_loading(true)

					const handle = setTimeout(() => {
						set_loading(false)
					}, 1000)

					return () => clearTimeout(handle)
				}, [value])

				return html`<li>\${loading ? 
					html`<em>Loading...</em>` : 
					value
				}</li>`
			}

			const App = () => {

				const [state, set_state] = useState(new_state)
				node.set_app_state = set_state

				return html`<h5>Hello world!</h5>
					<ul>\${
					state.x.map((x,i) => html`<\${Item} value=\${x} key=\${i}/>`)
				}</ul>`;
			}

			// PREACT APP ENDS HERE

			render(html`<\${App}/>`, node);

		} else {

			node.set_app_state(new_state)
		}
		return node
	</script>
	```
	""", "Show with syntax highlighting")

# ╔═╡ 8c87a9d3-d839-4468-be3a-25cf2c240537
md"""
$ text $
"""

# ╔═╡ 8af69410-c7dd-4155-acfb-e710a75e95ea
PlutoUI.TableOfContents(aside=true)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
ColorVectorSpace = "c3611d14-8923-5661-9e6a-0046d554d3a4"
Colors = "5ae59095-9a9b-59fe-a467-6f913c188581"
FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
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
ColorVectorSpace = "~0.9.9"
Colors = "~0.12.8"
FileIO = "~1.14.0"
HypertextLiteral = "~0.9.4"
ImageIO = "~0.6.6"
ImageShow = "~0.3.6"
Ipopt = "~1.0.2"
JSON = "~0.21.3"
JuMP = "~1.1.1"
Plots = "~1.31.1"
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
git-tree-sha1 = "8e9c3482c61d06343a6199814bf84f7df82f2b28"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.2.0"

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

[[deps.CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[deps.Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "924cdca592bc16f14d2f7006754a621735280b74"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.1.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Conda]]
deps = ["Downloads", "JSON", "VersionParsing"]
git-tree-sha1 = "6e47d11ea2776bc5627421d59cdcc1296c058071"
uuid = "8f4d0f93-b110-5947-807f-2305c1781a2d"
version = "1.7.0"

[[deps.Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[deps.DataAPI]]
git-tree-sha1 = "fb5f5316dd3fd4c5e7c30a24d50643b73e37cd40"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.10.0"

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

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "51d2dfe8e590fbd74e7a842cf6d13d8a2f45dc01"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.6+0"

[[deps.GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "RelocatableFolders", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "c98aea696662d09e215ef7cda5296024a9646c75"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.64.4"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "3a233eeeb2ca45842fe100e0413936834215abf5"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.64.4+0"

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

[[deps.IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "b3364212fb5d870f724876ffcd34dd8ec6d98918"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.7"

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
git-tree-sha1 = "21e4d46307492e77332c777699c90d58a4fa3245"
uuid = "b8f27783-ece8-5eb3-8dc8-9495eed66fee"
version = "1.5.0"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

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

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

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
git-tree-sha1 = "9a36165cf84cff35851809a40a928e1103702013"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.16+0"

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
git-tree-sha1 = "93e82cebd5b25eb33068570e3f63a86be16955be"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.31.1"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "8d1f54886b9037091edf146b517989fc4a09efec"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.39"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

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
git-tree-sha1 = "dc1e451e15d90347a7decc4221842a022b011714"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.5.2"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "cdbd3b1338c72ce29d9584fdbe9e9b70eeb5adca"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "0.1.3"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

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
git-tree-sha1 = "a9e798cae4867e3a41cae2dd9eb60c047f1212db"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.6"

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

[[deps.StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "ec47fb6069c57f1cee2f67541bf8f23415146de7"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.11"

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

[[deps.TiffImages]]
deps = ["ColorTypes", "DataStructures", "DocStringExtensions", "FileIO", "FixedPointNumbers", "IndirectArrays", "Inflate", "Mmap", "OffsetArrays", "PkgVersion", "ProgressMeter", "UUIDs"]
git-tree-sha1 = "fcf41697256f2b759de9380a7e8196d6516f0310"
uuid = "731e570b-9d59-4bfa-96dc-6df516fadf69"
version = "0.6.0"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "216b95ea110b5972db65aa90f88d8d89dcb8851c"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.6"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

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
# ╠═c49dec22-9c65-46b3-b59b-503553be2181
# ╟─67e1a008-bebc-4901-b13d-4b6c5b2849cb
# ╟─ac812745-7bd6-400e-a8ec-e7308c56133c
# ╠═304eec7c-4dec-4feb-b66b-65affd6e8fad
# ╟─cb32bb73-e448-4d0b-9cdb-8b6ee7fb2574
# ╟─31677e3d-7a2d-4753-9dc0-0a53082e6cd8
# ╟─f470427b-72ca-429c-81f1-9a388d33e99e
# ╟─42624349-193f-44d7-94c5-9c1e7f1eced7
# ╟─2dac349e-a825-45b5-8947-7c69729bea7c
# ╠═bbce6e6a-3b95-4718-9c01-6b31d7b39338
# ╠═6e7360a1-e684-466d-be83-1918826c54b7
# ╠═a7b8fdd4-fe61-4725-9380-e94cb7acbfd5
# ╟─eb7950dc-b59e-48ee-845b-d87bfc4f4edd
# ╠═9d3b1a73-da29-4862-9293-5582b7adf117
# ╠═78cbf7a2-168a-4212-941e-7b95b3f514cc
# ╟─777d1647-fe64-4a8f-8935-fcbd47ff3ea4
# ╠═6b22f0d1-1ad0-489d-8b43-4d2b18ce1fe3
# ╟─8a486868-fba6-4564-b7fc-3f23f3622d02
# ╠═3e151178-a5f2-4db4-a847-2ef697bb20af
# ╠═7cd284b6-28b5-41ad-b068-2a4858f1f31f
# ╠═df67c439-0652-462e-bd98-9b6e106ea161
# ╟─2c057af3-a2cc-46ea-bb2c-4138d8ba90d5
# ╟─84d2d0cf-8d76-41ad-92cb-f28d5968ae56
# ╟─2e8b7a78-0f86-4a8d-b431-d8b116357bc2
# ╠═f6891298-6ebd-4e61-bfa8-00689228d1a4
# ╠═ccbb292d-b24a-4279-9299-8365f13438ed
# ╠═dfd14873-9245-4faf-a22f-05369b6a195f
# ╠═7b2cf1cc-ef3c-4b8f-8d4f-8af3a5f65609
# ╠═fddd1551-776e-4fd1-ae37-0f7e8cc7bca1
# ╟─911e1c44-d330-4ad8-a4e4-59c1521e6a2c
# ╠═c5c80272-443b-4292-af3d-bb2bfee4a40c
# ╟─55166b92-58bd-4471-b42e-7019a1b028b1
# ╠═a375945e-ff05-4639-b9b8-57160c77a6a5
# ╟─4d3548c4-3396-428d-a5d8-38dd7d8f9eb6
# ╠═649c99a2-1603-42fe-980c-b6d102f9c01b
# ╟─9ba3692e-cd7e-4480-bc7b-2f2b3af7e6d4
# ╟─d038e213-b29b-4027-a788-0822e3368015
# ╟─97f65e05-05ea-4785-9707-6c53560356b5
# ╟─ad6ab075-fd5a-4631-8312-0edd441e7565
# ╟─d683a576-b1f0-4635-b23f-c64e3afbbce9
# ╟─bd3e5ff0-b513-4890-9bee-19a39e87a62e
# ╟─02c9a9ac-ef95-4278-a507-af3f345c0279
# ╟─8fb5c378-95a9-4f66-8908-4abac0ae7d07
# ╟─f6eafdaa-b23a-4ac2-a1a7-008fd0ba1ed5
# ╟─4e04718d-2804-4ef8-b012-79c78a98fadd
# ╠═2afdefcf-3786-4fc3-843a-22d962627850
# ╠═4e40bdd7-cdc8-4241-b086-82f365c74d4e
# ╠═bbcf9a3b-6643-4940-a75a-581787e75a53
# ╟─745b0658-f0ed-467e-ad16-473db9a40a5d
# ╟─523d898c-4eb7-4e74-a3af-d59e32ee3935
# ╟─f558baf4-d69c-4062-84e0-f24aa5bf9ed8
# ╟─9692a16c-e9e8-484e-aa7a-2933d5c60a5d
# ╠═9656c208-22af-47d4-9c9c-ef27151913b4
# ╠═f7977fc7-610c-491b-a7ca-2c433169f103
# ╠═e67654b3-e7de-47ad-b72c-cf80b2f0f992
# ╠═59edcf90-f222-11ec-0710-cf30cec93c3d
# ╠═8c87a9d3-d839-4468-be3a-25cf2c240537
# ╠═8af69410-c7dd-4155-acfb-e710a75e95ea
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
