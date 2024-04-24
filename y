#5entiment

import nltk
nltk.download('vader_lexicon')
nltk.download('stopwords')
nltk.download('punkt')
import pandas as pd
from nltk.sentiment.vader import SentimentIntensityAnalyzer

sid = SentimentIntensityAnalyzer()
def get_sentiment_scores(text):
  scores = sid.polarity_scores(text)
  return scores['compound']

df['sentiment_score'] = df['text'].apply(get_sentiment_scores)
def classify_sentiment(score):
  if score >= 0.05:
    return 'Positive'
  elif score <= -0.05:
    return 'Negative'
  else:
    return 'Neutral'
df['sentiment'] = df['sentiment_score'].apply(classify_sentiment)
print(df[['text', 'sentiment_score', 'sentiment']].head())
