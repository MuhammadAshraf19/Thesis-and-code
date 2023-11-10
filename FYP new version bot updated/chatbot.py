import nltk
from nltk.stem import WordNetLemmatizer
lemmatizer = WordNetLemmatizer()
nltk.download("punkt")
import json
import pickle
import tensorflow as tf

import numpy as np
import random
from keras.models import Sequential
from keras.layers import Activation,Dropout,Dense
from keras.models import load_model

#chatbot gui
from termcolor import colored

ls

