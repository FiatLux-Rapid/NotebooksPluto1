import streamlit as st
import pandas as pd


st.header('FIATLUX client')

e = st.slider('Epaisseur souhaitée pour le verre ?', 0.1, 1.0, 0.2)
st.write('Epaisseur' ,'=', e, 'cm')
V=st.slider('Volume souhaité?', 50.0, 1000.,300.0)
st.write('Volume' ,'=', V, r'$$ cm^3 $$')
