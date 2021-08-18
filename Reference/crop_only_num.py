import cv2
import numpy as np

img = cv2.imread('002.jpg') # Image saved offline on my computer
gray = cv2.cvtColor(img,cv2.COLOR_BGR2GRAY)
_,thresh = cv2.threshold(gray,128,255,cv2.THRESH_BINARY_INV) # Change

# Perform morphological closing
out = cv2.morphologyEx(thresh, cv2.MORPH_CLOSE, 255*np.ones((11, 11), dtype=np.uint8))
# Perform dilation to expand the borders of the text to be sure
out = cv2.dilate(thresh, 255*np.ones((11, 11), dtype=np.uint8))

# For OpenCV 3.0
_,contours,hierarchy = cv2.findContours(out,cv2.RETR_EXTERNAL,cv2.CHAIN_APPROX_SIMPLE) # Change
# For OpenCV 2.4.x
# contours,hierarchy = cv2.findContours(out,cv2.RETR_EXTERNAL,cv2.CHAIN_APPROX_SIMPLE)

# Find the area made by each contour
areas = [cv2.contourArea(c) for c in contours]

# Figure out which contour has the largest area
idx = np.argmax(areas)

# Choose that contour, then get the bounding rectangle for this contour
cnt = contours[idx]
x,y,w,h = cv2.boundingRect(cnt)

# Crop
crop = img[y:y+h,x:x+w]

cv2.imshow('Image',img)
cv2.imshow('Thresholded Image',thresh)
cv2.imshow('Closed Image',out)
cv2.imshow('Cropped', crop)
cv2.imwrite('thresh.png', thresh)
cv2.imwrite('binary.png', out)
cv2.imwrite('crop.png', crop)
cv2.waitKey(0)
cv2.destroyAllWindows()