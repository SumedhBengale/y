import pandas as pd
import networkx as nx
import matplotlib.pyplot as plt

df = pd.read_csv('linkedin.csv')
G = nx.Graph()
for index, row in df.iterrows():
  G.add_node(row['First Name'],
    job_title=row['Job Title'],
    company=row['Company Name'],
    school=row['School Name'],
    location=row['Location'],
    followers=row['Number of Followers'])
for index, row in df.iterrows():
  for index2, row2 in df.iterrows():
    if row['Location'] == row2['Location'] and row['First Name'] != row2['First Name']:
      G.add_edge(row['First Name'], row2['First Name'])
communities = nx.algorithms.community.girvan_newman(G)
for i, community in enumerate(communities):
  print(f"Community {i+1}: {community}")
plt.figure(figsize=(5, 5))
pos = nx.spring_layout(G, k=0.7)
nx.draw(G, pos, with_labels=True, node_color='lightblue', node_size=200,font_size=8)
labels = nx.get_node_attributes(G, 'First Name')
nx.draw_networkx_labels(G, pos, labels=labels, font_size=6,
font_color='black', verticalalignment='bottom')
plt.title('LinkedIn User Network by Location')
plt.show()
