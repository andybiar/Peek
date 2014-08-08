Shader "Custom/RGBDShader" {
	 Properties {
      _MainTex("Texture Image", 2D) = "white" {}
    }
	
	SubShader {
		Pass{ 
			GLSLPROGRAM
			
			varying float visibility;
			varying vec2 vUv;
			uniform sampler2D _MainTex;
			uniform float _Opacity;
			
			#ifdef VERTEX // Begin vertex shader
	 
	 		// Convert RGB color to hue saturation lightness
			vec3 rgb2hsl( vec3 color ) {
 
				float h = 0.0;
				float s = 0.0; 
				float l = 0.0;
				float r = color.r;
				float g = color.g;
				float b = color.b;
				float cMin = min( r, min( g, b ) );
				float cMax = max( r, max( g, b ) );
				
				// Lightness
				//    corresponds with whether a pixel in the depth image appears in the model
				//    (ie makes the background transparent)
				l =  ( cMax + cMin ) / 2.0;
				
				// IF the pixel will appear in the model
				if ( cMax > cMin ) {

					float cDelta = cMax - cMin;

					// Saturation
					if ( l < 0.5 ) {
						s = cDelta / ( cMax + cMin );
					} else {
						s = cDelta / ( 2.0 - ( cMax + cMin ) );
					}

					// Hue
					//    corresponds with depth
					if ( r == cMax ) {
						h = ( g - b ) / cDelta;
					} else if ( g == cMax ) {
						h = 2.0 + ( b - r ) / cDelta;
					} else {
						h = 4.0 + ( r - g ) / cDelta;
					}

					if ( h < 0.0) {
						h += 6.0;
					}
					
					h = h / 6.0;
				}

				return vec3( h, s, l );
			}

			void main() {
				// A positive float the stretches or shrinks the model along the depth axis
				float DEPTH_SCALE = 6.0;
			
				// A positive float that scales the model.
				//    I recommend leaving this value at 1.0 and scaling with the Unity inspector
				float MODEL_SCALE = 1.0;
				
				vUv = gl_MultiTexCoord0.st;
				
				// Scale the texture along the y-axis by .5
				//   (because the source image with depth data is twice as tall as the model)
				vUv.y = vUv.y * 0.5;
				
				// Retrieve the hue, saturation, lightness of our color data
				vec3 hsl = rgb2hsl( texture2D( _MainTex, vUv ).xyz );
				
				// Position and scale the model
				vec4 pos = vec4( gl_Vertex.x, gl_Vertex.y, gl_Vertex.z -DEPTH_SCALE * hsl.x, MODEL_SCALE );

				// Translate the texture to align the color data with the model
				//    (Removing this line will use the encoded depth data as color data)
				vUv.y += 0.5;
				
				// Correct the division by 2 which occurrs in the vertex shader
				visibility = hsl.z * 2.0;

				gl_PointSize = 2.0;
				
				gl_Position = gl_ModelViewProjectionMatrix * pos;
				 
			}
	         
	        #endif // End vertex shader
	         
	        #ifdef FRAGMENT // Begin fragment shader

			void main() {

				if ( visibility < 0.98 ) discard;

				vec4 color = texture2D( _MainTex, vUv );
				color.w = _Opacity;

				gl_FragColor = color;
			}
	         
	        #endif 
	         
			ENDGLSL
		} 
	} 
}
