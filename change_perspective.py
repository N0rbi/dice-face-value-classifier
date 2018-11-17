import numpy as np
import skimage
from skimage import color
import matplotlib
import matplotlib.pyplot as plt
import cv2
from skimage import morphology
from skimage import feature


def change_perspective(image):
    orig = image
    image = color.rgb2gray(image)
    image = skimage.morphology.dilation(image, skimage.morphology.disk(5))
    image = feature.canny(image, sigma=3)
    image = morphology.convex_hull_image(image)

    (im_height, im_width) = image.shape

    loc = np.array(np.where(image)).T

    target_points = np.float32([[0,0],[im_height, 0],[0, im_width],[im_height, im_width]])
    top_left = loc[np.argmin(np.linalg.norm(target_points[0] - loc, axis=1, ord=1))]
    top_right = loc[np.argmin(np.linalg.norm(target_points[1] - loc, axis=1, ord=1))]
    bot_left = loc[np.argmin(np.linalg.norm(target_points[2] - loc, axis=1, ord=1))]
    bot_right = loc[np.argmin(np.linalg.norm(target_points[3] - loc, axis=1, ord=1))]
    current_points = np.float32([top_left, top_right, bot_left, bot_right])

    matrix = cv2.getPerspectiveTransform(target_points, current_points)
    result = skimage.transform.warp(orig, matrix)
    # skimage.io.imshow(result)
    return result