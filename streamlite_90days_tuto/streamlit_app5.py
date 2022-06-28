import numpy as np
import altair as alt
import pandas as pd
import streamlit as st

st.header('st.write')

# Exemple 1

st.write('Hello, *World!* :sunglasses:')

# Exemple 2

st.write(1234)

# Exemple 3

df = pd.DataFrame({
     'première colonne' : [1, 2, 3, 4],
     'deuxième colonne' : [10, 20, 30, 40]
     })
st.write(df)

# Exemple 4

st.write('Ci-dessous se trouve une DataFrame :', df, 'Ci-dessus se trouve une DataFrame.')

# Exemple 5

df2 = pd.DataFrame(np.random.randn(200, 3), columns = ['a', 'b', 'c'])

     
    


c = alt.Chart(df2).mark_circle().encode(
     x='a', y='b', size='c', color='c')
st.write(c)
