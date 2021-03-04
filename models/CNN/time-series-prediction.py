import tensorflow_model_optimization as tfmot
from tensorflow import keras
import tensorflow as tf
import pandas as pd
import numpy as np
import argparse
import zlib
import sys
import os

tf.random.set_seed(55)
np.random.seed(55)

#download and read the dataset
original_path = 'pd.read_csv("https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-andamento-nazionale/dpc-covid19-ita-andamento-nazionale.csv")'
filename = 'dpc-covid19-ita-andamento-nazionale.csv'
zip_path = tf.keras.utils.get_file(origin=original_path, 
                                   fname=filename, 
                                   extract = True, 
                                   cache_dir='.', 
                                   cache_subdir='data')
csv_path, _ = os.path.splitext(zip_path)
df = pd.read_csv(csv_path)
columns_indices = [6,9]  #totale_positivi, dimessi_guariti
columns = df.columns[columns_indices]
data = df[columns].values.astype(np.float32)

n = len(data)
#split of the data
train_data = data[0:int(n*0.7)]
val_data = data[int(n*0.7):int(n*0.9)]
test_data = data[int(n*0.9):]

mean = train_data.mean(axis=0)
std = train_data.std(axis=0)

def evaluate(model_lite_dir, test_ds):  #evaluate the tflite model
  interpreter = tf.lite.Interpreter(model_path=model_lite_dir)
  interpreter.allocate_tensors()
  input_details = interpreter.get_input_details()
  output_details = interpreter.get_output_details()

  mae_t = 0
  mae_h = 0
  c = 0
  test_ds = test_ds.unbatch().batch(1)

  for val, lab in test_ds:
    interpreter.set_tensor(input_details[0]['index'], val)
    interpreter.invoke()
    ris = interpreter.get_tensor(output_details[0]['index'])
    mae_t += np.sum(np.abs(lab[0,:,0] - ris[0,:,0]))
    mae_h += np.sum(np.abs(lab[0,:,1] - ris[0,:,1]))
    c += 6 #lenght of the windows

  mae_t = mae_t/c
  mae_h = mae_h/c
  print(f'MAE Cases = {mae_t}')
  print(f'MAE Recovered = {mae_h}')

def save_convert_model(model, model_dir, model_lite_dir, quant = False, compr = False):
  #save the model
  run_model = tf.function(lambda x: model(x))
  concrete_func = run_model.get_concrete_function(tf.TensorSpec([1, 6, 2]))
  model.save(model_dir, signatures = concrete_func)

  #convert the model
  converter = tf.lite.TFLiteConverter.from_saved_model(model_dir)
  if quant == True:
    converter.optimizations = [tf.lite.Optimize.OPTIMIZE_FOR_SIZE]
    converter.target_spec.supported_types = [tf.float16]    #use the float16 format

  model_quant = converter.convert()

  with open(model_lite_dir , 'wb') as f:
    if compr == True:
      model_quant = zlib.compress(model_quant)
    f.write(model_quant)

class WindowGenerator:
  def __init__(self, windows_width, label_width, mean, std):
    self.windows_width = windows_width
    self.label_width = label_width
    self.input_width = self.windows_width-self.label_width
    self.mean = tf.reshape(tf.convert_to_tensor(mean), [1,1,2])
    self.std = tf.reshape(tf.convert_to_tensor(std), [1,1,2])

  def split_window(self, features):
    inputs = features[:, :-self.label_width, :]
    labels = features[:, self.input_width: , :]

    inputs.set_shape([None, self.input_width, 2]) 
    labels.set_shape([None, self.label_width, 2])
    return inputs, labels

  def normalize(self, features):
    features = (features - self.mean)/(self.std + 1.e-6)
    return features

  def preprocess(self, features):
    inputs, labels = self.split_window(features)  
    inputs = self.normalize(inputs)  
    return inputs, labels

  def make_dataset(self, data, train): 
    ds = tf.keras.preprocessing.timeseries_dataset_from_array(
        data=data,                                                       
        sequence_length=self.windows_width, 
        sequence_stride=1,
        batch_size=32, 
        targets=None)
    ds = ds.map(self.preprocess)
    ds = ds.cache()

    if train:
      ds = ds.shuffle(len(data), reshuffle_each_iteration=True)
    return ds

class My_MAE(tf.keras.metrics.Metric):
  def __init__(self, name= "My_mae", **kwargs):
    super(My_MAE, self).__init__(name=name, **kwargs)
    self.temp_mae = self.add_weight(name="temp_mae", initializer="zeros")
    self.hum_mae = self.add_weight(name="hum_mae", initializer="zeros")
    self.len_data = self.add_weight(name="len", initializer="zeros")

  def update_state(self, y_true, y_pred, sample_weight=None):
    y_pred = tf.cast(y_pred, tf.float32)
    y_true = tf.cast(y_true, tf.float32)
    temp = tf.reduce_sum(tf.abs(y_true[:, :, 0] - y_pred[:, :, 0]), axis=[1,0])
    hum = tf.reduce_sum(tf.abs(y_true[:, :, 1] - y_pred[:, :, 1]), axis = [1,0])

    self.temp_mae.assign_add(temp)
    self.hum_mae.assign_add(hum)
    self.len_data.assign_add(192) #32*6

  def result(self):
    return (self.temp_mae/self.len_data , self.hum_mae/self.len_data)

  def reset_states(self): 
    self.temp_mae.assign(0.0)
    self.hum_mae.assign(0.0)
    self.len_data.assign(0.0)

windows_width = 12
label_width = 6

generator = WindowGenerator(windows_width, label_width, mean, std)
train_ds = generator.make_dataset(train_data, True)
test_ds = generator.make_dataset(test_data, False)
val_ds = generator.make_dataset(val_data, False)

#same model for both version
alpha = 0.16
model = keras.Sequential([
    keras.layers.Flatten(input_shape=(6, 2)),
    keras.layers.Dense(int(128*alpha), activation='relu'),
    keras.layers.Dense(12),
    keras.layers.Reshape((6, 2), input_shape=(12,))
])
model.summary()

reduce_lr = tf.keras.callbacks.ReduceLROnPlateau(monitor='val_loss', factor=0.2,
                                                  patience=4, min_lr=0.0001)

model.compile(optimizer='adam', loss = tf.keras.losses.MeanAbsoluteError(), metrics=[My_MAE()])

model_story = model.fit(train_ds, epochs=40, verbose=2, validation_data=val_ds, batch_size=32, callbacks = [reduce_lr])

test_loss, test_acc = model.evaluate(test_ds)
print('The accuracy of the model on the test set before the quantization:')
print(f'MAE Cases {test_acc[0]}')
print(f'MAE Recovered {test_acc[1]}')

save_convert_model(model, model_dir, model_lite_dir, quant = True, compr = False)
print('The accuracy of the model on the test set after the quantization:')
evaluate(model_lite_dir, test_ds)
save_convert_model(model, model_dir, model_lite_dir, quant = True, compr = True)

