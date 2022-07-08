Nous allons créer un projet avec son propre environnement

Le modèle paramétrique du verre se trouve sous Graahopper/glass.3dm
Dans un terminal de VS studio :
conda create -n toyexampleV1 Python=3.10 
conda activate toyexampleV1
pip install streamlit
pip install poetry
pip install specklepy
npm install speckle-js
(Invoke-WebRequest -Uri https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py -UseBasicParsing).Content | python -
julia
import Pkg
Pkg.update()
import Pluto
Pluto.run()




