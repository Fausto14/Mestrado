#include <opencv/cv.h>
#include <opencv/highgui.h>
#include <opencv/cvaux.h>
#include <opencv/cxcore.h>
#include <opencv/ml.h>
#include <stdlib.h>
#include <stdio.h>

using namespace cv;
using namespace std;

Scalar value;

//HSV to extract color from leather
int H_MIN = 0;
int H_MAX = 175;
int S_MIN = 0;
int S_MAX = 256;
int V_MIN = 0;
int V_MAX = 50;

Mat mask, maskInv, temp_image;

vector<Mat> images;

vector<Mat> ROI(String img) {

	Mat img0 = imread(img, 1);
	//resize(img0,img0,Size(540,650));


	Mat img1;

	//convert frame from BGR to HSV colorspace
	cvtColor(img0, img1, COLOR_BGR2HSV);

	//filter HSV image between values and store filtered image to
	inRange(img1, Scalar(H_MIN, S_MIN, V_MIN), Scalar(H_MAX, S_MAX, V_MAX), mask);

	//Morphological Transformations
	Mat element = getStructuringElement(0, Size(9, 9), Point(4, 4));
	morphologyEx(mask, mask, 0, element);//open
	morphologyEx(mask, mask, 1, element);//close

	//invert mask
	bitwise_not(mask, maskInv);

	maskInv.copyTo(temp_image);

	// find the contours
	vector< vector<Point> > contours;
	findContours(temp_image, contours, CV_RETR_CCOMP, CV_CHAIN_APPROX_SIMPLE);

	vector<double> areas(contours.size());

	//Pick up the areas smaller than 1000000 of the connected objects and fill them with the black background color
	for (size_t i = 0; i < contours.size(); ++i) {
		if (contourArea(Mat(contours[i])) < 100000) {
			drawContours(maskInv, contours, i, cv::Scalar(0), CV_FILLED);
		}
	}

	// let's create a new image now
	Mat crop(mask.rows, mask.cols, CV_8UC3);

	// set background to white
	crop.setTo(Scalar(255, 255, 255));
	// and copy the object
	// normalize so imwrite(...)/imshow(...) shows the mask correctly!
	//normalize(maskInv.clone(), maskInv, 1.0, 0.0, CV_MINMAX, CV_8UC1);

	img0.copyTo(crop, maskInv);


	images.clear();


	images.push_back(crop);
	images.push_back(maskInv);

	return images;
}
