import pandas as pd

import matplotlib.pyplot as plt

import seaborn as sns # Import seaborn for color palettes

from textblob import TextBlob

# Function to preprocess text data

def preprocess_text(text):

text = str(text).lower().strip()

return text

# Function to perform sentiment analysis

def get_sentiment(text):

analysis = TextBlob(text)

polarity = analysis.sentiment.polarity

if polarity > 0:

return 'Positive'

elif polarity < 0:

return 'Negative'

else:

return 'Neutral'

# Function to plot sentiment distribution

def plot_sentiment_distribution(df):

plt.figure(figsize=(8, 6))

sns.countplot(x='Sentiment', data=df, palette='husl') # Use 'husl' 

palette

plt.title('Sentiment Distribution across Reviews')

plt.xlabel('Sentiment')

plt.ylabel('Count')

plt.show()

# Function to plot sentiment pie chart for a specific company

def plot_sentiment_pie(df, company_name):

sentiment_counts = 

df[df.index.get_level_values('payments_companies') == 

company_name]['Sentiment'].value_counts()

plt.figure(figsize=(8, 6))

plt.pie(sentiment_counts, labels=sentiment_counts.index, 

autopct='%1.1f%%', startangle=140, colors=sns.color_palette('husl')) # 

Use 'husl' palette

plt.title(f'Sentiment Distribution for {company_name}')

plt.axis('equal')

plt.show()

# Function to analyze negative reviews and suggest improvements

def analyze_negative_reviews(df, company_name, threshold=0.2):

negative_comments = 

df[(df.index.get_level_values('payments_companies') == company_name) & 

(df['Sentiment'] == 'Negative')]['Comment']

if len(negative_comments) > 0:

print(f"Negative Reviews and Suggestions for {company_name}:")

for i, comment in enumerate(negative_comments):

analysis = TextBlob(comment)

polarity = analysis.sentiment.polarity

if polarity < -threshold:

print(f"Negative Comment {i+1}: '{comment}'")

print("Improvement Suggestion: Consider addressing 

customer service issues or product quality concerns.")

print("")

# Load datasets for each payments_companies

companies = ['alpha_payments_reviews', 'beta_payments_reviews', 

'paytm_reviews', 'phonepe_reviews', 'payu_reviews', 'paypal_reviews']

dataframes = {}

for company in companies:

path = f'{company.lower()}.csv'

dataframes[company] = pd.read_csv(path)

# Concatenate all datasets into a single DataFrame

all_reviews_df = pd.concat(dataframes.values(), keys=dataframes.keys(), 

names=['payments_companies'])

# Preprocess text data

all_reviews_df['Comment'] = 

all_reviews_df['Comment'].apply(preprocess_text)

# Perform sentiment analysis and add sentiment labels

all_reviews_df['Sentiment'] = 

all_reviews_df['Comment'].apply(get_sentiment)

# Plot sentiment distribution across reviews

plot_sentiment_distribution(all_reviews_df)

# Plot sentiment pie chart for each payment company

for company in companies:

plot_sentiment_pie(all_reviews_df, company)

analyze_negative_reviews(all_reviews_df, company)

# Calculate average ratings by payment company

average_ratings = 

all_reviews_df.groupby('payments_companies')['Rating'].mean()

# Plot average ratings comparison

plt.figure(figsize=(10, 6))

sns.barplot(x=average_ratings.index, y=average_ratings.values, 

palette='husl') # No need to multiply or scale ratings

plt.title('Average Ratings Comparison among Payments Companies')

plt.xlabel('Payment Company')

plt.ylabel('Average Rating') # Update ylabel to reflect the change

plt.xticks(rotation=45)

plt.ylim(0, 5) # Set y-axis limit for ratings out of 5

plt.grid(axis='y', linestyle='--', alpha=0.7)

plt.show()

# Let's simulate some data for interest over time

import numpy as np

dates = pd.date_range(start='2022-01-01', end='2024-01-01', freq='M')

interest_data = np.random.randint(0, 100, size=(len(dates), 

len(companies)))

interest_over_time_df = pd.DataFrame(interest_data, index=dates, 

columns=companies)

# Plot interest over time

plt.figure(figsize=(10, 6))

for company in companies:

plt.plot(interest_over_time_df.index, 

interest_over_time_df[company], label=company)

plt.title('Interest Over Time by Payment Company')

plt.xlabel('Date')

plt.ylabel('Interest')

plt.legend()

plt.grid(True)

plt.show()

# Plot sentiment breakdown by subregion
sentiment_subregion_df = all_reviews_df.groupby(['payments_companies', 

'Subregion', 'Sentiment']).size().unstack(fill_value=0)

sentiment_subregion_df.plot(kind='bar', stacked=True, figsize=(10, 6))

plt.title('Sentiment Breakdown by Subregion')

plt.xlabel('Payment Company and Subregion')

plt.ylabel('Count')

plt.xticks(rotation=45)

plt.legend(title='Sentiment')

plt.show()
