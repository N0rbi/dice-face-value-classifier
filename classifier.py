from keras.models import Sequential
from keras.layers import Conv2D
from keras.layers import MaxPooling2D
from keras.layers import Flatten
from keras.layers import Dense
from keras.layers import Dropout
import numpy as np
from skimage import io, filters
import skimage.morphology as morph

TARGET_SIZE = 128

def transform(img):
    grayscale = img[:, :, 0]
    grayscale = morph.dilation(grayscale)
    grayscale = filters.sobel(grayscale)
    img = np.array(grayscale).reshape(TARGET_SIZE,TARGET_SIZE,1)
    return img


classifier = Sequential()

classifier.add(Conv2D(32, (3, 3), input_shape = (TARGET_SIZE, TARGET_SIZE, 1), activation = 'relu'))
classifier.add(MaxPooling2D(pool_size = (2, 2)))

classifier.add(Conv2D(32, (3, 3), activation = 'relu'))
classifier.add(MaxPooling2D(pool_size = (2, 2)))

classifier.add(Conv2D(64, (3, 3), activation = 'relu'))
classifier.add(MaxPooling2D(pool_size = (2, 2)))

classifier.add(Flatten())
classifier.add(Dropout(0.2))
classifier.add(Dense(units = 128, activation = 'relu'))
classifier.add(Dropout(0.5))
classifier.add(Dense(units = 6, activation = 'sigmoid'))

classifier.compile(optimizer = 'adam', loss = 'categorical_crossentropy', metrics = ['accuracy'])


from keras.preprocessing.image import ImageDataGenerator

train_datagen = ImageDataGenerator(rescale = 1./255,
                                   shear_range = 0.1,
                                   zoom_range = 0.2,
                                   samplewise_center = True,
                                   horizontal_flip = True,
                                   vertical_flip=True,
                                   rotation_range = 40,
                                   preprocessing_function=transform)

test_datagen = ImageDataGenerator(rescale = 1./255)

training_set = train_datagen.flow_from_directory('dataset/train_set',
                                                 target_size = (TARGET_SIZE, TARGET_SIZE),
                                                 batch_size = 32,
                                                 class_mode = 'categorical',
                                                 color_mode='grayscale')

test_set = test_datagen.flow_from_directory('dataset/test_set',
                                            target_size = (TARGET_SIZE, TARGET_SIZE),
                                            batch_size = 32,
                                            class_mode = 'categorical',
                                            color_mode='grayscale')

classifier.fit_generator(training_set,
                         steps_per_epoch = 1000,
                         epochs = 25,
                         validation_data = test_set,
                         validation_steps = 30)