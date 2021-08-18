import PIL
import numpy as np
import cv2
# reading the input image in grayscale image
image = cv2.imread('003.png',cv2.IMREAD_GRAYSCALE)
image = image / 255
image = image * 255
cv2.imwrite('image.jpg', image)
if image is None:
    print('Can not find/read the image data')
# Defining ver and hor kernel
N = 5
kernel = np.zeros((N,N), dtype=np.uint8)
kernel[2,:] = 1
dilated_image = cv2.dilate(image, kernel, iterations=2)

kernel = np.zeros((N,N), dtype=np.uint8)
kernel[:,2] = 1
dilated_image = cv2.dilate(dilated_image, kernel, iterations=2)
cv2.imwrite('dilated_image.jpg', dilated_image)
image = image * 255

# finding contours in the dilated image
img,contours,a = cv2.findContours(dilated_image,cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)

# finding bounding rectangle using contours data points
rect = cv2.boundingRect(contours[0])
pt1 = (rect[0],rect[1])
pt2 = (rect[0]+rect[2],rect[1]+rect[3])
cv2.rectangle(image,pt1,pt2,(100,100,100),thickness=2)

# extracting the rectangle
text = image[rect[1]:rect[1]+rect[3],rect[0]:rect[0]+rect[2]]

plt.subplot(1,2,1), plt.imshow(image,'gray')
plt.subplot(1,2,2), plt.imshow(text,'gray')

plt.show()