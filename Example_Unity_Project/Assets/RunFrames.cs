using UnityEngine;
using System.Collections;


public class RunFrames : MonoBehaviour {

	// The number of frames in your animation
	public int NUM_FRAMES;

	// The directory (Resources/<FOLDER>) where your frames are stored
	//    Be sure to include a "/" at the end!
	public string FOLDER;

	// All frame filenames must begin with this naming convention
	//    If nothing is provided, defaults to RGBD Toolkit export
	public string FRAME_NAME_CONV;
		
	private ArrayList frames = new ArrayList();
	private int frameNum;
	
	//Loads all frames into RAM from file structure
	private void LoadImages()
	{
		if (FRAME_NAME_CONV.Equals ("")) 
		{
			FRAME_NAME_CONV = @"save.";
		}
	     
	    for (int i=0; i < NUM_FRAMES; i++)
	    {
			// This mess prepends the correct amount of zeroes to the current frame number
	    	string index = "";
	    	float logIdx = Mathf.Log10(i+1);
	    	
	    	if (logIdx < 1.0)
	    		index += "0000";
	    	else if (logIdx < 2.0)
	    		index += "000";
			else if (logIdx < 3.0)
	    		index += "00";
			else if (logIdx < 4.0)
	    		index += "0";
			else if (logIdx < 5.0)
				index += "";
			else Debug.Log("Too many frames in animation!");
	    	
	    	index += (i+1);
	     
			// This is deprecated functionality for compiling to mobile. We'll fix this soon

			//string pathPrefix = @"file://";
			//string fileSuffix = @".png";
			//string pathImageAssets = Application.dataPath + "/depthPNGs";
			//string fullFilename = pathPrefix + pathImageAssets + filename + indexSuffix + fileSuffix;
			//WWW www = new WWW(fullFilename);
	    	//Texture2D texTmp = new Texture2D(512, 1024, TextureFormat.DXT5, false);
	    	//LoadImageIntoTexture compresses JPGs by DXT1 and PNGs by DXT5
	    	//www.LoadImageIntoTexture(texTmp);

			// Create a Texture2D from the specified image file
			Texture2D frame = Resources.Load<Texture2D>(FOLDER + FRAME_NAME_CONV + index);
	     
			// Add this frame to the ArrayList in RAM
	    	frames.Add(frame);
		}
	}
	
	// Use this for initialization
	void Start () {
		QualitySettings.vSyncCount = 0;
		Application.targetFrameRate = 24;
		LoadImages();
		frameNum = 0;
	}
	
	// Set the texture of the model and increment the frame counter
	void Update () {
		Texture2D tex = (Texture2D)frames[frameNum];
		renderer.material.SetTexture("_MainTex", tex);
		frameNum = (frameNum + 1) % NUM_FRAMES;
	}
}
