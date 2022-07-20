#from ssl import ALERT_DESCRIPTION_BAD_CERTIFICATE_STATUS_RESPONSE
import time
import streamlit as st
import streamlit.components.v1 as components
from specklepy.api.client import SpeckleClient
from specklepy.api.credentials import get_default_account	
from specklepy.objects import Base
from specklepy.transports.server import ServerTransport
from specklepy.api import operations
#from streamlit_autorefresh import st_autorefresh
#vo=st_autorefresh(interval=5000, limit=1e6, key="fizzbuzzcounter")
#ep=st_autorefresh(interval=5000, limit=1e6, key="fizzbuzzcounter")

#st.title("FIATLUX: un cas d'école")
st.markdown("<h1 style='text-align: center; color: Maroon;'>FIATLUX: cas minimaliste</h1>", unsafe_allow_html=True)
st.markdown("""
L'objectif est d'illustrer les possibilités de mise en œuvre pratique de FIATLUX, dans le cloud, avec trois acteurs différent du cloud et trois scripts assurant les échanges:
* Un script *Python* qui génère le site utilisateur et qui assure les échanges avec les autres acteurs,
* un script *Julia* qui assure l'optimisation
* Un script *Grasshopper* qui assure la génération de l'objet 3D. Dans l'esprit d'un example minimal, la représentation 3D est très basique. Pour une application commerciale, un rendu de meilleure qualité sera nécessaire et est réalisable comme le montre l'exemple suivant:
""")

components.iframe("https://mcneel.github.io/rhino-developer-samples/rhino3dm/js/SampleViewer/02_advanced/" ,width=600 ,height=400 , scrolling=True )

st.markdown("""
Des applications plus complexes pourront être réalisées en partant de cet exemple "***hello world***" 

Le cœur de FIATLUX est **open source** et peut être **mis en œuvre à partir d'un simple navigateur**. 
En particulier FIATLUX assure l'**archivage de tous les échanges** et permettra la **formation interactive** à ses fonctionnalités.
"""
)  


st.image(
            "https://github.com/FiatLux-Rapid/NotebooksPluto1/blob/e4820323423781fedb05dceec1da49c5dfd35886/FIATLUX_cloud.PNG?raw=true",
            width=600, # Manually Adjust the width of the image as per requirement
        )

st.markdown("<h2 style='text-align: left; color: Maroon;'>Le modèle</h2>", unsafe_allow_html=True)
st.write("Le cas d'école retenu consiste à calculer les caractéristiques d'un verre ayant le volume et l'épaisseur de paroi requis tout en minimisant la matière employée pour sa réalisation")

st.write("""Le rayon du verre est R, l'épaisseur de la paroi et du socle e, H est sa hauteur

**Volume du verre (intérieur):** *V= π(R-e)²*(H-e)* 

**Volume de la part matière**: *πR²e* (pour le socle du verre) *+ πR²(H-e)-π(R-e)²(H-e)*
(pour la paroi latérale). 
C'est cette quantité qu'il faut minimiser!
""")

st.markdown("<h2 style='text-align: left; color: Maroon;'>Méthode de résolution</h2>", unsafe_allow_html=True)

st.markdown("""
* L'optimisation sous contraintes est réalisée par un programme *Julia*. Ce programme minimisant la part matière pour atteindre le volume requis fournira les valeurs optimales pour R et H
* Un modèle paramétrique du verre, réalisé sous *Grasshopper*, fournira la représentation 3D du verre.
* Les échanges de données entre les divers logiciels mis en œuvre se fait de façon asynchrone à l'aide de *Speckle* 
* Le site est réalisé à partir du logiciel *Streamlit*
* Son déploiement est possible grâce à son hébergement, gratuit, chez *Heroku*


""")



class Block1(Base):
    volume: float
    epaisseur: float
    

    def __init__(self, volume, epaisseur, **kwargs) -> None:
        super().__init__(**kwargs)
        # mark the origin as a detachable attribute
        self.volume = volume
        self.epaisseur = epaisseur
 


st.sidebar.markdown("<h2 style='text-align: left; color: Maroon;'>Envoi des données</h2>", unsafe_allow_html=True)


with st.sidebar.form("my_form"):
    #st.write("Inside the form")
   
    V=st.number_input('Volume V du verre souhaité (cm ³)', 0, 1000,value=300)
    e=st.number_input('Epaisseur e de la paroi (cm )', 0.10,5.0,value=0.2)
    
    #slider_val = st.slider("Form slider")
    #checkbox_val = st.checkbox("Form checkbox")

    # Every form must have a submit button.
    submitted = st.form_submit_button("Submit")
    if submitted:
        #st.write("slider", slider_val, "checkbox", checkbox_val)
        # here's the data you want to send
#block = Block(length=2, height=4)
        block = Block1(volume=V, epaisseur=e)	


        # next create a server transport - this is the vehicle through which you will send and receive
        client = SpeckleClient(host="https://speckle.xyz/")
        new_stream_id="36b6a4554d"  # spécifique au projet ToyExampleV2_APIJulia

        account = get_default_account()
        #client.authenticate_with_account(account)
        client.authenticate_with_token("bb79167d4c8279ffcdac840cf0593191b54504f359")
        transport = ServerTransport(client=client, stream_id=new_stream_id)

        # this serialises the block and sends it to the transport
        hash = operations.send(base=block, transports=[transport])
        commid_id = client.commit.create(
            stream_id=new_stream_id, 
            object_id=hash, 
            message="V and e transmission",
            )
        st.write("Les nouvelles données ont été envoyées")
        
        
        
        
        #time.sleep(20)
        #"c9b24bc2de" -> fromGH
        #my_glass="""<iframe src="https://speckle.xyz/embed?stream=c9b24bc2de" width="600" height="400" frameborder="0"></iframe>"""
        
        #stream="https://speckle.xyz/embed?stream=c9b24bc2de"
        #if vo not in st.session_state:
        #  st.session_state.vo=300
        #  st.write(st.session_state.stream)
        #if V != st.session_state.vo: 
        #  st.session_state.vo=V
        #  st.write(st.session_state.vo)

        #if ep not in st.session_state:
        #  st.session_state.ep=0.5
        #  st.write(st.session_state.ep)
        #if e != st.session_state.ep: 
        #  st.session_state.ep=e
        #  st.write(st.session_state.ep)
        
        

#st.write("Outside the form")
st.sidebar.markdown("<h2 style='text-align: left; color: Maroon;'>Récupération des données optimisées</h2> <par>  Puis rafraîchir la page</par> ", unsafe_allow_html=True)
view = st.sidebar.button("view 3D")
if view:
    my_glass="""<iframe src="https://speckle.xyz/embed?stream=c9b24bc2de" width="600" height="400" frameborder="0"></iframe>"""
    st.markdown(my_glass, unsafe_allow_html=True)



