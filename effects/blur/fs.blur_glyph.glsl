precision mediump float;
uniform highp int nTexCount;
uniform sampler2D texTextures[8];
uniform float fAlpha;
varying vec2 texCoord[8];

const mat3 GAUSS = mat3(
	0.0947416, 0.118318, 0.0947416,
	0.118318, 0.147761, 0.118318,
	0.0947416, 0.118318, 0.0947416
);
const float OFFSET = 0.03;

void main() 
{
	if (nTexCount > 0)
	{
		mat3 gaussMat = mat3(0.0);
		vec4 gaussPoint = texture2D(texTextures[0], vec2(texCoord[0].x - OFFSET, texCoord[0].y + OFFSET));
		gaussMat[0][0] = gaussPoint.a;
		gaussPoint = texture2D(texTextures[0], vec2(texCoord[0].x, texCoord[0].y + OFFSET));
		gaussMat[0][1] = gaussPoint.a;
		gaussPoint = texture2D(texTextures[0], vec2(texCoord[0].x + OFFSET, texCoord[0].y + OFFSET));
		gaussMat[0][2] = gaussPoint.a;
		gaussPoint = texture2D(texTextures[0], vec2(texCoord[0].x - OFFSET, texCoord[0].y));
		gaussMat[1][0] = gaussPoint.a;
		gaussPoint = texture2D(texTextures[0], texCoord[0]);
		gaussMat[1][1] = gaussPoint.a;
		gaussPoint = texture2D(texTextures[0], vec2(texCoord[0].x + OFFSET, texCoord[0].y));
		gaussMat[1][2] = gaussPoint.a;
		gaussPoint = texture2D(texTextures[0], vec2(texCoord[0].x - OFFSET, texCoord[0].y - OFFSET));
		gaussMat[2][0] = gaussPoint.a;
		gaussPoint = texture2D(texTextures[0], vec2(texCoord[0].x, texCoord[0].y - OFFSET));
		gaussMat[2][1] = gaussPoint.a;
		gaussPoint = texture2D(texTextures[0], vec2(texCoord[0].x + OFFSET, texCoord[0].y - OFFSET));
		gaussMat[2][2] = gaussPoint.a;
		float alpha = dot(gaussMat[0], GAUSS[0]) + dot(gaussMat[1], GAUSS[1]) + dot(gaussMat[2], GAUSS[2]);
		
		vec4 texColor = texture2D(texTextures[0], texCoord[0]);
		gl_FragColor = vec4(texColor.r, texColor.g, texColor.b, alpha * fAlpha);
	}
}
