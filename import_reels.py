import pandas as pd
import mysql.connector

df = pd.read_excel(r"C:\Users\ebadh\Downloads\reels.csv.xlsx")

conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="Sherin@2026!",
    database="smart_content_organizer"
)

cursor = conn.cursor()

for _, row in df.iterrows():
    cursor.execute("""
        INSERT INTO reels
        (hashtags, lemmatized_tags, number_of_tags, topic, encoded_topic)
        VALUES (%s, %s, %s, %s, %s)
    """, (
        str(row['hashtags']),
        str(row['lemmatized_tags']),
        int(row['number_of_tags']),
        str(row['topic']),
        int(row['encoded_topic'])
    ))

conn.commit()
print("Imported", len(df), "rows")

cursor.close()
conn.close()