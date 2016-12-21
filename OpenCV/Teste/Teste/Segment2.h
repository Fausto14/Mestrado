#include "opencv2/imgproc/imgproc.hpp"
#include "opencv2/highgui/highgui.hpp"
#include <stdlib.h>
#include <stdio.h>

using namespace cv;
using namespace std;

Scalar value;

Mat ROI(String img) {

	
	// read in the apple (change path to the file)
	Mat img0 = imread(img, 1);
	resize(img0,img0,Size(540,650));

	Mat bgr[3];   //destination array
	split(img0, bgr);//split source 

	vector<Vec4i> hierarchy;


	Mat img1;
	value = Scalar(0, 0, 0);
	copyMakeBorder(img0, img0, 2, 2, 2, 2, BORDER_CONSTANT, value);

	cvtColor(img0, img1, CV_RGB2GRAY);

	// apply your filter
	Canny(img1, img1, 100, 200);
	//inRange(img1, Scalar(0, 0, 22), Scalar(255), img1);

	
	//Erosion Image
	Mat element = getStructuringElement(0, Size(5, 5));
	//morphologyEx(dst, dilate_dst, 3, 5);
	dilate(img1, img1, element);
	erode(img1, img1, element);
	//imshow("Erosion Result", dilate_dst);

	// find the contours
	vector< vector<Point> > contours;
	findContours(img1, contours, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_NONE);

	// you could also reuse img1 here
	Mat mask = Mat::zeros(img1.rows, img1.cols, CV_8UC1);

	// CV_FILLED fills the connected components found
	//drawContours(mask, contours, -1, Scalar(255), CV_FILLED);

	/*
	Before drawing all contours you could also decide
	to only draw the contour of the largest connected component
	found. Here's some commented out code how to do that:
	*/

	vector<double> areas(contours.size());

	for (int i = 0; i < contours.size(); i++)
		areas[i] = contourArea(Mat(contours[i]));

	double max;
	Point maxPosition;
	minMaxLoc(Mat(areas), 0, &max, 0, &maxPosition);
	drawContours(mask, contours, maxPosition.y, Scalar(255), CV_FILLED);



	// let's create a new image now
	Mat crop(img1.rows, img1.cols, CV_8UC3);

	// set background to green
	crop.setTo(Scalar(255, 255, 255));

	// and copy the magic apple
	img0.copyTo(crop, mask);

	//threshold(mask, mask, 110, 255, 1);

	//drawContours(crop, contours, maxPosition.y, CV_RGB(0, 0, 0), 1, 8, hierarchy);

	// normalize so imwrite(...)/imshow(...) shows the mask correctly!
	bitwise_not(mask, mask);
	normalize(mask.clone(), mask, 0.0, 255.0, CV_MINMAX, CV_8UC1);

	// show the images
	//namedWindow("original", WINDOW_FREERATIO);
	/*imshow("original", img0);
	imshow("mask", mask);
	imshow("canny", img1);*/
	//imshow("cropped", crop);

	return crop;


	//imwrite("/home/philipp/img/apple_canny.jpg", img1);
	//imwrite("/home/philipp/img/apple_mask.jpg", mask);
	//imwrite("/home/philipp/img/apple_cropped.jpg", crop);

	//waitKey();
	//return 0;
}
