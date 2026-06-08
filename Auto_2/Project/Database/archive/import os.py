import os
import random
from pathlib import Path

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from PIL import Image

from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report, confusion_matrix, ConfusionMatrixDisplay, f1_score

import tensorflow as tf
from tensorflow.keras import layers, models, regularizers

# --- CONFIGURACIÓN ---
SEED = 42
random.seed(SEED)
np.random.seed(SEED)
tf.random.set_seed(SEED)

# Tu ruta exacta proporcionada
DATA_DIR = Path(r"C:\Users\ikerf\Downloads\TERCERO\SegundoCuatri\Fecas_Repository\Auto_2\Project\Database")
IMG_SIZE = (128, 128)
BATCH_SIZE = 32
CLASS_NAMES = ["COVID", "NORMAL", "PNEUMONIA"]

# --- 1. CARGA Y EXPLORACIÓN (EDA) ---
print(f"Buscando imágenes en: {DATA_DIR}")

rows = []
for c in CLASS_NAMES:
    path_class = DATA_DIR / c
    if not path_class.exists():
        print(f"[ERROR] No existe la carpeta: {path_class}")
        continue
    
    # Buscamos formatos comunes
    files = []
    for ext in ["*.png", "*.jpg", "*.jpeg"]:
        files.extend(list(path_class.glob(ext)))
        
    print(f"Clase {c}: {len(files)} imágenes halladas.")
    for fp in files:
        rows.append({"filepath": str(fp), "label": c})

df = pd.DataFrame(rows)
if df.empty:
    raise ValueError("No se encontraron imágenes. Revisa que la ruta sea correcta y contenga las subcarpetas.")

# --- 2. SPLIT 70/15/15 ESTRATIFICADO ---
train_df, temp_df = train_test_split(
    df, test_size=0.30, stratify=df["label"], random_state=SEED
)
val_df, test_df = train_test_split(
    temp_df, test_size=0.50, stratify=temp_df["label"], random_state=SEED
)

print(f"\nConjuntos creados: Train({len(train_df)}), Val({len(val_df)}), Test({len(test_df)})")

# --- 3. PIPELINE DE DATOS ---
label_to_id = {c: i for i, c in enumerate(CLASS_NAMES)}
id_to_label = {i: c for c, i in label_to_id.items()}

def load_and_preprocess(path, label_id):
    img = tf.io.read_file(path)
    img = tf.io.decode_image(img, channels=3, expand_animations=False)
    img = tf.image.resize(img, IMG_SIZE)
    img = tf.cast(img, tf.float32) / 255.0
    img = tf.image.rgb_to_grayscale(img) # Las RX son monocromáticas
    return img, tf.one_hot(label_id, depth=len(CLASS_NAMES))

def make_ds(df_subset, shuffle=False):
    ds = tf.data.Dataset.from_tensor_slices((df_subset["filepath"].values, 
                                             df_subset["label"].map(label_to_id).values))
    if shuffle:
        ds = ds.shuffle(len(df_subset))
    ds = ds.map(load_and_preprocess, num_parallel_calls=tf.data.AUTOTUNE)
    return ds.batch(BATCH_SIZE).prefetch(tf.data.AUTOTUNE)

train_ds = make_ds(train_df, shuffle=True)
val_ds = make_ds(val_df)
test_ds = make_ds(test_df)

# --- 4. MODELO 1: BASELINE MLP (Referencia a tu práctica 6) ---
# [Inferencia] Tal como pide la guía, aplanamos la imagen para el baseline.
mlp = models.Sequential([
    layers.Input(shape=(IMG_SIZE[0], IMG_SIZE[1], 1)),
    layers.Flatten(),
    layers.Dense(256, activation='relu'),
    layers.Dropout(0.3),
    layers.Dense(128, activation='relu'),
    layers.Dense(len(CLASS_NAMES), activation='softmax')
], name="Baseline_MLP")

mlp.compile(optimizer='adam', loss='categorical_crossentropy', metrics=['accuracy'])

print("\nEntrenando Baseline MLP...")
hist_mlp = mlp.fit(train_ds, validation_data=val_ds, epochs=15, verbose=1)

# --- 5. MODELO 2: CNN (Arquitectura Compleja sugerida por profesor) ---
cnn = models.Sequential([
    layers.Input(shape=(IMG_SIZE[0], IMG_SIZE[1], 1)),
    
    # Bloque 1
    layers.Conv2D(32, (3, 3), activation='relu', padding='same'),
    layers.MaxPooling2D((2, 2)),
    
    # Bloque 2
    layers.Conv2D(64, (3, 3), activation='relu', padding='same'),
    layers.MaxPooling2D((2, 2)),
    
    # Bloque 3
    layers.Conv2D(128, (3, 3), activation='relu', padding='same'),
    layers.MaxPooling2D((2, 2)),
    
    layers.Flatten(),
    layers.Dense(128, activation='relu'),
    layers.Dropout(0.5),
    layers.Dense(len(CLASS_NAMES), activation='softmax')
], name="Advanced_CNN")

cnn.compile(optimizer='adam', loss='categorical_crossentropy', metrics=['accuracy'])

print("\nEntrenando CNN Avanzada...")
hist_cnn = cnn.fit(train_ds, validation_data=val_ds, epochs=15, verbose=1)

# --- 6. EVALUACIÓN Y COMPARATIVA ---
def evaluate(model, name):
    results = model.evaluate(test_ds, verbose=0)
    print(f"\n--- {name} ---")
    print(f"Test Accuracy: {results[1]:.4f}")
    
    y_prob = model.predict(test_ds, verbose=0)
    y_pred = np.argmax(y_prob, axis=1)
    y_true = test_df["label"].map(label_to_id).values
    
    print(classification_report(y_true, y_pred, target_names=CLASS_NAMES))
    
    # Matriz de Confusión
    cm = confusion_matrix(y_true, y_pred)
    ConfusionMatrixDisplay(cm, display_labels=CLASS_NAMES).plot(cmap="Blues")
    plt.title(f"Confusión: {name}")
    plt.show()

evaluate(mlp, "MLP (Baseline)")
evaluate(cnn, "CNN (Avanzada)")