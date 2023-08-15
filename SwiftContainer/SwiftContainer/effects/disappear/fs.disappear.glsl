precision mediump float;
uniform highp int nTexCount;
uniform sampler2D texTextures[8];
uniform float fAlpha;
varying vec2 texCoord[8];


void main() 
{
	if (nTexCount > 0)
	{
        vec4 vSampleBasic = texture2D(texTextures[0], texCoord[0]);
        vec4 vMix = texture2D(texTextures[1], texCoord[1]);
        gl_FragColor = vec4(vSampleBasic.r, vSampleBasic.g, vSampleBasic.b, vMix.a * fAlpha);
	}
}
