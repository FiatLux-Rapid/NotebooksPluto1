# This program receive data from Speckle stream when a change occurs 
# NEED pip install streamlit-autorefresh
import streamlit as st
from specklepy.api.client import SpeckleClient 
from specklepy.api.credentials import get_default_account
from specklepy.api import operations
from specklepy.api.resources import commit
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
last_obj_id = client.commit.list(stream_id)[0].referencedObject
lastcommit=client.commit.list(stream_id)[0]
last_obj = operations.receive(obj_id=last_obj_id, remote_transport=transport)
a=last_obj_id
b=last_obj.v
c=last_obj.e

st.write("hello world")
st.write("ID",a)
st.write("Commit",lastcommit.id)
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

if lastcommit.id not  in st.session_state:
    st.session_state.id=""
if lastcommit.id !=st.session_state.id:
    st.session_state.id=lastcommit.id
    com_id=lastcommit.id
    file2= open("commit.txt", "r")
    # setting flag and index to 0
    flag = 0
    index = 0

    # Loop through the file line by line
    for line in file2:  
        index += 1 
        
        # checking string is present in line or not
        if com_id in line:
            
            flag = 1
            break
    # checking condition for string found or not
    if flag == 0: 
        file2.close()
        file2=open("commit.txt","a")
        file2.write(lastcommit.id+", "+a+" ,"+str(b)+","+str(c)+"\n")
        #client.commit.list
    file2.close()

    # commit.txt has changed, this will refresh julia activity (toy_example_v2.jl)



    
if a != st.session_state.ID:
    string1=a 
    st.session_state.ID=a
    #st.write(st.session_state.ID)
    #file1 = open("in.txt", "a") 
    #file1.write(a+" ,"+str(b)+","+str(c)+"\n")
    #file1.close()
    
    file1 = open("in.txt", "r")
    
    # setting flag and index to 0
    flag = 0
    index = 0

    # Loop through the file line by line
    for line in file1:  
        index += 1 
        
        # checking string is present in line or not
        if string1 in line:
            
            flag = 1
            break
    # checking condition for string found or not
    if flag == 0: 
        file1.close()
        file1=open("in.txt","a")
        file1.write(a+" ,"+str(b)+","+str(c)+"\n")

        #client.commit.list
    file1.close()



#client.commit.list