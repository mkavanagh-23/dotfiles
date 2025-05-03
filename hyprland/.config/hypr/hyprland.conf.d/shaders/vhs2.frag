// This shader looks best in fullscreen (due to subpixel manipulation).
// vim: set ft=glsl:

#define INTERLACING_SEVERITY 0.001

#define TRACKING_HEIGHT 0.15
#define TRACKING_SEVERITY 0.025
#define TRACKING_SPEED 0.2

#define SHIMMER_SPEED 30.0

#define RGB_MASK_SIZE 2.0

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord.xy / iResolution.xy;
    
    // x wigglies (sampling error)
    uv.x -= sin(uv.y * 500.0 + iTime) * INTERLACING_SEVERITY;
    
    float scan = mod(fragCoord.y, 3.0);
  
    // Convert our xy coordinates into a linear index we can use in
    // the next step
    // periodically offset y by 1 pixel to get that shimmer
    float yOffset = floor(sin(iTime*SHIMMER_SPEED));
    float pix = (fragCoord.y+yOffset) * iResolution.x + fragCoord.x;
    pix = floor(pix);
    
    // Simulate pixel layout by using a repeating RGB mask
    vec4 colMask = vec4(mod(pix, RGB_MASK_SIZE), mod((pix+1.0), RGB_MASK_SIZE), mod((pix+2.0), RGB_MASK_SIZE), 1.0);
    colMask = colMask / (RGB_MASK_SIZE - 1.0) + 0.5;

    // Tracking
    float t = -iTime * TRACKING_SPEED;
    float fractionalTime = (t - floor(t)) * 1.3 - TRACKING_HEIGHT;
    if(fractionalTime + TRACKING_HEIGHT >= uv.y && fractionalTime <= uv.y)
    {
        uv.x -= fractionalTime * TRACKING_SEVERITY;
    }
    
    fragColor = texture(iChannel0, uv)*colMask*scan;
}

