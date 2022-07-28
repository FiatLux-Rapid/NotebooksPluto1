from specklepy.objects import Base
from specklepy.api.client import SpeckleClient 
from specklepy.api.credentials import get_default_account
from specklepy.transports.server.server import ServerTransport
from specklepy.api import operations
		
class Block2(Base):
	e: float
	h: float
	r: float
			
		
	def __init__(self, e=0.1,h=1.0,r=1.1,v=1., **kwargs) -> None:
		super().__init__(**kwargs)
		self.r = r
		self.e =e
		self.h=h
				
		
block2 = Block2(e=$(e),h=$(h) ,r=$(r),v=$(V) )
		# next create a server transport
client = SpeckleClient(host="https://speckle.xyz/")
		
new_stream_id=$(fromJulia) # spécifique au projet	
account = get_default_account()
client.authenticate_with_account(account)
transport = ServerTransport(client=client, stream_id=new_stream_id)
				
		# this serialises the block and sends it to the transport
hash = operations.send(base=block2, transports=[transport])
commid_id = client.commit.create(
		stream_id=new_stream_id, 
		object_id=hash, 
		message="result of optimization",
		)

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
        st.sidebar.markdown("<h2 style='text-align: left; color: Maroon;'>Récupération des données optimisées</h2>  ", unsafe_allow_html=True)
        #view = st.sidebar.button("Result")
        #if view:
            
        client = SpeckleClient(host="speckle.xyz", use_ssl=True)
        account = get_default_account()
        client.authenticate(token=account.token)
        GH_stream_id="36b6a4554d" #"c9b24bc2de"
        lastcommit=client.commit.list(GH_stream_id)[0]
        last_obj_id = client.commit.list(GH_stream_id)[0].referencedObject 
        transport = ServerTransport(client=client, stream_id=GH_stream_id)
        last_obj = operations.receive(obj_id=last_obj_id, remote_transport=transport)    
        st.write(client.commit.list(GH_stream_id)[0])
        st.write(last_obj)
        st.write(last_obj.id)
        st.sidebar.write("hauteur=",last_obj.h,", rayon=",last_obj.r," , épaisseur= ",last_obj.e)
        st.write(client.commit)
        st.write(lastcommit)