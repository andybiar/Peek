using UnityEngine;
using System.Collections;


public class RunFrames : MonoBehaviour {
		
	ArrayList imageBuffer = new ArrayList();
	int frameNum;
	
	//Loads all frames into buffer from directory
	private void LoadImages()
	{
	    string pathPrefix = @"file://";
	    string pathImageAssets = @"C:\RGBDTest\AndyTest\";
	    string filename = @"save.";
	    string fileSuffix = @".png";
	     
	    //create filename index suffix "001",...,"999"
	    for (int i=0; i < 97; i++)
	    {
	    	string indexSuffix = "";
	    	float logIdx = Mathf.Log10(i+1);
	    	
	    	if (logIdx < 1.0)
	    		indexSuffix += "0000";
	    	else if (logIdx < 2.0)
	    		indexSuffix += "000";
			else if (logIdx < 3.0)
	    		indexSuffix += "00";
			else if (logIdx < 4.0)
	    		indexSuffix += "0";
	    	
	    	
	    	indexSuffix += (i+1);
	     
	    	string fullFilename = pathPrefix + pathImageAssets + filename + indexSuffix + fileSuffix;
	     
	    	WWW www = new WWW(fullFilename);
	    	Texture2D texTmp = new Texture2D(512, 1024, TextureFormat.DXT5, false);
	    	//LoadImageIntoTexture compresses JPGs by DXT1 and PNGs by DXT5
	    	www.LoadImageIntoTexture(texTmp);
	     
	    	imageBuffer.Add(texTmp);
		}
	}
	
	// Use this for initialization
	void Start () {
		QualitySettings.vSyncCount = 0;
		Application.targetFrameRate = 24;
		LoadImages();
		frameNum = 0;
	}
	
	// Update is called once per frame
	void Update () {
//		if(frameNum < imageBuffer.Count){
//			
//			Texture2D temp = (Texture2D)imageBuffer[frameNum];
//			renderer.material.SetTexture("_MainTex", temp);
//			frameNum++;
//			
//		}
		
		Texture2D temp = (Texture2D)imageBuffer[frameNum];
		renderer.material.SetTexture("_MainTex", temp);
		frameNum = (frameNum + 1)%97;
	}
}
