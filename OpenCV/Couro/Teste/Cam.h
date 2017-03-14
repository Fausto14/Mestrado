#include<iostream>
#include<opencv2\highgui\highgui.hpp>
#include<opencv2\imgproc\imgproc.hpp>
#include<opencv2\core\core.hpp>
#include<opencv2\video\background_segm.hpp>
#include<Windows.h>
using namespace cv;
using namespace std;

//functions prototypes
void on_trackbar(int, void*);
void createTrackbars();
void showimgcontours(Mat &threshedimg, Mat &original);
void toggle(int key);
void morphit(Mat &img);
void blurthresh(Mat &img);

//function prototypes ends here

//boolean toggles

bool domorph = false;
bool doblurthresh = false;
bool showchangedframe = false;
bool showcontours = false;

//boolean toggles end


int H_MIN = 0;
int H_MAX = 255;
int S_MIN = 0;
int S_MAX = 255;
int V_MIN = 0;
int V_MAX = 255;

int kerode = 1;
int kdilate = 1;
int kblur = 1;
int threshval = 0;

Mat canny_output;


void Exe(String img)
{
	createTrackbars();
	on_trackbar(0, 0);

	Mat frame, hsvframe, rangeframe;
	int key;
	//VideoCapture cap(0);
	frame = imread(img);
	//cap >> frame;
	//flip(frame, frame, 180);
	cvtColor(frame, hsvframe, COLOR_BGR2GRAY);
	while ((key = waitKey(30)) != 27)
	{
		toggle(key);
		

		inRange(hsvframe, Scalar(H_MIN, S_MIN, V_MIN), Scalar(H_MAX, S_MAX, V_MAX), rangeframe);

		if (domorph)
			morphit(rangeframe);

		if (doblurthresh)
			blurthresh(rangeframe);

		if (showcontours)
			showimgcontours(rangeframe, frame);

		if (showchangedframe)
			imshow("Camera", frame);
		else
			imshow("Camera", rangeframe);

	}

}


void on_trackbar(int, void*)
{//This function gets called whenever a
 // trackbar position is changed
	if (kerode == 0)
		kerode = 1;
	if (kdilate == 0)
		kdilate = 1;
	if (kblur == 0)
		kblur = 1;
}
void createTrackbars()
{
	String trackbarWindowName = "TrackBars";
	namedWindow(trackbarWindowName, WINDOW_NORMAL);
	createTrackbar("H_MIN", trackbarWindowName, &H_MIN, H_MAX, on_trackbar);
	createTrackbar("H_MAX", trackbarWindowName, &H_MAX, H_MAX, on_trackbar);
	createTrackbar("S_MIN", trackbarWindowName, &S_MIN, S_MAX, on_trackbar);
	createTrackbar("S_MAX", trackbarWindowName, &S_MAX, S_MAX, on_trackbar);
	createTrackbar("V_MIN", trackbarWindowName, &V_MIN, V_MAX, on_trackbar);
	createTrackbar("V_MAX", trackbarWindowName, &V_MAX, V_MAX, on_trackbar);
	createTrackbar("Erode", trackbarWindowName, &kerode, 31, on_trackbar);
	createTrackbar("Dilate", trackbarWindowName, &kdilate, 31, on_trackbar);
	createTrackbar("Blur", trackbarWindowName, &kblur, 255, on_trackbar);
	createTrackbar("Thresh", trackbarWindowName, &threshval, 255, on_trackbar);
	//createTrackbar(" Canny thresh:", "Source", &thresh, max_thresh, thresh_callback);

}

void morphit(Mat &img)
{
	erode(img, img, getStructuringElement(MORPH_RECT, Size(kerode, kerode)));
	dilate(img, img, getStructuringElement(MORPH_RECT, Size(kdilate, kdilate)));
}
void blurthresh(Mat &img)
{
	//medianBlur(img,img,kblur%2+3+kblur);
	blur(img, img, Size(kblur, kblur), Point(-1, -1), BORDER_DEFAULT);
	threshold(img, img, threshval, 255, THRESH_BINARY_INV);
}
void toggle(int key)
{

	//toggle line start
	if (key == 'm')
		domorph = !domorph;
	if (key == 'b')
		doblurthresh = !doblurthresh;
	if (key == 'r')
		showchangedframe = !showchangedframe;
	if (key == 'c')
		showcontours = !showcontours;
	//toggle line end
}

void showimgcontours(Mat &threshedimg, Mat &original)
{
	vector<vector<Point> > contours;
	vector<Vec4i> hierarchy;
	int largest_area = 0;
	int largest_contour_index = 0;

	/// Detect edges using canny
	Canny(threshedimg, canny_output, 90, 90 * 3, 3);

	findContours(canny_output, contours, hierarchy, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_SIMPLE);
	//this will find largest contour
	for (int i = 0; i< contours.size(); i++) // iterate through each contour. 
	{
		double a = contourArea(contours[i], false);  //  Find the area of contour
		if (a>largest_area)
		{
			largest_area = a;
			largest_contour_index = i;                //Store the index of largest contour
		}

	}
	//search for largest contour has end

	if (contours.size() > 0)
	{
		drawContours(original, contours, largest_contour_index, CV_RGB(0, 255, 0), 2, 8, hierarchy);
		//if want to show all contours use below one
		//drawContours(original,contours,-1, CV_RGB(0, 255, 0), 2, 8, hierarchy);
	}
}