import time
import streamlit as st
import streamlit.components.v1 as components
from specklepy.api.client import SpeckleClient
from specklepy.api.credentials import get_default_account	
from specklepy.objects import Base
from specklepy.transports.server import ServerTransport
from specklepy.api import operations

new_stream_id="b4fdac11b9"  # spécifique au projet ToyExampleV2_APIJulia
client = SpeckleClient(host="speckle.xyz", use_ssl=True)
account = get_default_account()
client.authenticate(token=account.token)
transport = ServerTransport(client=client, stream_id=new_stream_id)
last_obj_id = client.commit.list(new_stream_id)[0].referencedObject
st.write(last_obj_id)
        #st.write(client)
st.write(new_stream_id)
lastcommit=client.commit.list(new_stream_id)[0]
       # <iframe src="https://speckle.xyz/embed?stream=b4fdac11b9&commit=73809b959a" width="600" height="400" frameborder="0"></iframe>
        
        #components.iframe("https://speckle.xyz/embed?stream=b4fdac11b9&commit=73809b959a",width=600 ,height=400 , scrolling=True )
last_obj = operations.receive(obj_id="0513dd3106ddd14faa070501045d21df", remote_transport=transport)
        #last_obj = operations.receive(obj_id=last_obj_id, remote_transport=transport)
       

        #st.write(last_obj)
st.write(last_obj)
st.write(last_obj.e)