import numpy as np
import skimage
from skimage import color
import matplotlib
import matplotlib.pyplot as plt
import cv2
from skimage import morphology
from skimage import feature
from skimage.measure import label, regionprops


def change_perspective(image):
    orig = image
    image = color.rgb2gray(image)
    image = skimage.morphology.opening(image, skimage.morphology.disk(20))
    image = (image > np.median(image))*1
    labeled = label(image)
    regions = regionprops(labeled)
    bigest_block = sorted(regions, key=lambda region: region.filled_area)[-1].label
    image = labeled == bigest_block

    (im_height, im_width) = image.shape

    loc = np.array(np.where(image)).T
    loc[:, [1, 0]] = loc[:, [0, 1]]

    target_points = np.float32([[0,0],[0, im_height],[im_width, 0],[im_width, im_height]])
    top_left = loc[np.argmin(np.linalg.norm(target_points[0] - loc, axis=1, ord=2))]
    top_right = loc[np.argmin(np.linalg.norm(target_points[1] - loc, axis=1, ord=2))]
    bot_left = loc[np.argmin(np.linalg.norm(target_points[2] - loc, axis=1, ord=2))]
    bot_right = loc[np.argmin(np.linalg.norm(target_points[3] - loc, axis=1, ord=2))]
    current_points = np.float32([top_left, top_right, bot_left, bot_right])
    matrix = cv2.getPerspectiveTransform(target_points, current_points)
    result = skimage.transform.warp(orig, matrix)
    return result


a = change_perspective(skimage.io.imread("kocka2.jpg"))
skimage.io.imshow(a)
skimage.io.show()

