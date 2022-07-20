# This program receive data from Speckle stream when a change occurs 
# NEED pip install streamlit-autorefresh
import streamlit as st
from specklepy.api.client import SpeckleClient 
from specklepy.api.credentials import get_default_account
from specklepy.api import operations
from specklepy.transports.server.server import ServerTransport
from streamlit_autorefresh import st_autorefresh

# Run the autorefresh about every 2000 milliseconds (2 seconds) and stop
# after it's been refreshed 100 times.
#count = st_autorefresh(interval=5000, limit=1e6, key="fizzbuzzcounter")
ID = st_autorefresh(interval=2000, limit=1e6, key="fizzbuzzcounter")

stream_id="36b6a4554d"  # spécifique au projet ToyExampleV2_APIJulia
client = SpeckleClient(host="speckle.xyz", use_ssl=True)
account = get_default_account()
client.authenticate(token=account.token)

transport = ServerTransport(client=client, stream_id=stream_id)
a=last_obj_id = client.commit.list(stream_id)[0].referencedObject
last_obj = operations.receive(obj_id=last_obj_id, remote_transport=transport)
b=last_obj.volume
c=last_obj.epaisseur


st.write("hello world")
st.write("ID",a)

# store  data on file
st.download_button(
    label="DOWNLOAD!",
    data="trees",
    file_name="out.txt",
    mime="text/plain"
)

if "counter" not in st.session_state:
    st.session_state.counter=0
st.write(st.session_state.counter)
if st.button("up"):
    st.session_state.counter+=1
    st.write(st.session_state.counter)

if "ID" not in st.session_state:
    st.session_state.ID=""
#st.write(st.session_state.ID)
if a != st.session_state.ID: 
    st.session_state.ID=a
    #st.write(st.session_state.ID)
    file1 = open("in.txt", "a") 
    file1.write(a+" ,"+str(b)+","+str(c)+"\n")
    file1.close()
   

