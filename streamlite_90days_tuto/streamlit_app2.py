import streamlit as st


st.header('st.button1')
st.button('goodbye')
if st.button('say hello'):
     st.write('why hello?')
else:
     st.write('goodbye')