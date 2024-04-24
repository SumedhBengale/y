#Topic

import pandas as pd
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.decomposition import LatentDirichletAllocation
from sklearn.pipeline import Pipeline

df = pd.read_csv('cleaned.csv')

df['text'] = df['headline'].astype(str) +" "+ df['reviewBody'].astype(str)

pipeline = Pipeline([('vect', CountVectorizer(stop_words='english')),('lda', LatentDirichletAllocation(n_components=10,random_state=42))])
pipeline.fit(df['text'])

vectorizer = pipeline.named_steps['vect']
lda_model = pipeline.named_steps['lda']
feature_names = vectorizer.get_feature_names_out()

n_top_words = 10
for topic_idx, topic in enumerate(lda_model.components_):
  print(f"Topic {topic_idx + 1}:")
  print(" ".join([feature_names[i] for i in
  topic.argsort()[:-n_top_words - 1:-1]]))
  print()


doc_topic_distributions =lda_model.transform(vectorizer.transform(df['text']))
df['topic'] = doc_topic_distributions.argmax(axis=1)

print(df[['headline', 'reviewBody', 'topic']].head())
