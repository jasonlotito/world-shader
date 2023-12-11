shader_type canvas_item;
uniform sampler2D height;
uniform bool shadow = true;
uniform vec3 sunPos;
const float STEPS = 800.0;
const float shadowBrightness = 0.5;

vec4 rgb(int r, int g, int b) {
	return vec4(float(r)/255.0,float(g)/255.0,float(b)/255.0,1.0);
}

vec4 tile(sampler2D t, vec2 loc) {
	float n = texture(t, loc).r;
	if(n <= 0.3) {
		return rgb(98, 166, 169);
	} else if(n <= 0.4) {
		return rgb(214, 182, 158);
	} else if(n <= 0.5) {
		return rgb(152, 173, 90);
	} else if(n <= 0.6) {
		return rgb(101, 133, 65);
	} else if(n <= 0.7) {
		return rgb(71, 118, 69);
	} else if(n <= 0.8) {
		return rgb(109, 118, 135);
	} else if(n <= 0.9) {
		return rgb(132, 141, 154);
	} else {
		return rgb(210, 224, 222);
	}
}

void fragment() {
	//float noiseValue = texture(NOISE_PATTERN, UV).x;
	COLOR = tile(height, UV);
	if (shadow) {
		float ht = texture(height, UV).r;
		vec3 p = vec3(UV, ht);
		
		vec3 stepDir = (sunPos - p)/STEPS;
		float inShadow = 0.;
		for (float i = 0.0; i<STEPS; i++) {
			p += stepDir;
			
			float h = texture(height, p.xy).r;
			if (h < .3) {
				h = 0.0;
			}
			if (h > p.z) {
				inShadow = 1.;
				break;
			}
			if (p.z > 1.) {
				break;
			}
		}
		
		vec4 shd = vec4(COLOR.rgb * shadowBrightness, COLOR.a);
		COLOR = mix(COLOR, shd, inShadow);
	}

}