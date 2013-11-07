Shader "Custom/RGBDShader" {
	 Properties {
      _MainTex("Texture Image", 2D) = "white" {} 
    
     _Opacity ("opacity", Float) = 1.0
    }
	
	SubShader {
		Pass{

			GLSLPROGRAM
			
			varying float visibility;
			varying vec2 vUv;
			uniform sampler2D _MainTex;
			uniform float _Opacity;
			
			
			#ifdef VERTEX // here begins the vertex shader
	 
			vec3 rgb2hsl( vec3 color ) {
 
				float h = 0.0;
				float s = 0.0; 
				float l = 0.0;
				float r = color.r;
				float g = color.g;
				float b = color.b;
				float cMin = min( r, min( g, b ) );
				float cMax = max( r, max( g, b ) );

				l =  ( cMax + cMin ) / 2.0;

				if ( cMax > cMin ) {

					float cDelta = cMax - cMin;

					// saturation

					if ( l < 0.5 ) {

						s = cDelta / ( cMax + cMin );

					} else {

						s = cDelta / ( 2.0 - ( cMax + cMin ) );

					}

					// hue

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

//			const float minD = 555.0;
//			const float maxD = 1005.0;
//			const float fx = 1.11087;
//			const float fy = 0.832305;
//
//			vec3 xyz( float x, float y, float depth ) {
//
//				float z = depth * ( maxD - minD ) + minD;
//
//				return vec3( ( x / 640.0 ) * z * fx, ( y / 480.0 ) * z * fy, - z );
//
//			}

			void main() {

				vUv = gl_MultiTexCoord0.st;
				vUv.x = vUv.x * 0.5;
				vUv.y += .2;

				vec3 hsl = rgb2hsl( texture( _MainTex, vUv ).xyz );
				vec4 pos = vec4( gl_Vertex.x, gl_Vertex.y, gl_Vertex.z + -1.5 * hsl.x, 1.0 );

				vUv.x += 0.5;

				visibility = hsl.z * 2.0;

				gl_PointSize = 2.0;

				gl_Position = gl_ModelViewProjectionMatrix * pos;
				 
			}
	         
	        #endif // here ends the definition of the vertex shader
	         
	        #ifdef FRAGMENT // here begins the fragment shader

			void main() {

				if ( visibility < 0.75 ) discard;

				vec4 color = texture2D( _MainTex, vUv );
				//vec4 color = vec4(vUv.x, vUv.y, 0, 1.0);
				color.w = _Opacity;

				gl_FragColor = color;
			}
	         
	        #endif 
	         
			ENDGLSL
		} 
	} 
}
