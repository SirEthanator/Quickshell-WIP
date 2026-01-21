# Porting Shadertoy Shaders

Shadertoy shaders will not work on Qt out of the box. They must be ported. This involves getting some values from Qt and defining some variables.

### Set the Version

Shadertoy automatically sets the version, Qt does not. To define the version that should be used, add this line to the very top of your .frag file:

```glsl
#version 440
```

This will set the version to 440, which is a good choice for most shaders.

### Define the Stage Interface

You must define how data enters and exits your shader. The shader receives coordinates, and returns a final pixel color.

1. The input (interpolated coordinates) defines the variable that receives coordinates from the vertex shader. It tells the shader what part of the surface it is painting. The default vertex shader passes it with the name of qt_TexCoord0, so that is what should be used. Place this at the top of your .frag file (below the version):

```glsl
layout(location = 0) in vec2 qt_TexCoord0;
```

2. The output (final pixel color) defines the final color that should be sent. In Shadertoy, the name is found in the mainImage parameters (usually fragColor). Place this underneath the input:

```glsl
layout(location = 0) out vec4 fragColor;
```

### Renaming the mainImage Function

Qt does not recognise the mainImage function, it uses the main function. The mainImage function needs to be renamed to main. The main function will no longer take parameters. The input and output variables are now defined separately, from the previous step. Before removing the parameters, take note of the input variable's name, which is typically called fragCoord.

### Converting Coordinates

Next, the coordinates form qt_TexCoord0 need to be translated to match Shadertoy's coordinate system. At the beginning of the main function, define a new variable with the name of the input variable (such as fragCoord) as shown below:

```glsl
vec2 fragCoord = vec2(qt_TexCoord0.x, 1.0 - qt_TexCoord0.y) * iResolution;
```

Shadertoy's x coordinates match with Qt's, but the y coordinates are opposite. In Shadertoy, Y moves up, so the bottom is 0. In Qt, Y moves down, so subtracting from 1 will flip it. Additionally, Shadertoy uses pixel coordinates, whereas Qt uses normalised coordinates, meaning they range from 0 to 1. To resolve this, the coordinates must be multiplied by the resolution.

### The Uniform Buffer

Now, the uniform buffer must be defined. This is like a bridge between the QML code and the shader. The order is important here. The GPU processes data in blocks of 16 bytes, so if consecutive values cannot fit into a block, padding will be automatically added to compensate. It is best to avoid this when possible, as it can reduce efficiency. You should always begin with `qt_Matrix` and `qt_Opacity` as these are always sent by Qt.

Macros are used so that the rest of the shader can continue to use iTime, iResolution, etc. but it will use to the values from ubuf, sort of like aliases.

```glsl
layout(std140, binding = 0) uniform buf {
  mat4 qt_Matrix; // 4 * 4 * 4 bytes (4 blocks filled)
  float qt_Opacity; // 4 bytes (Total 4/16)

  float time; // 4 bytes (Total 8/16)
  vec2 resolution; // 2 * 4 bytes (Total 16/16 - Block filled)
  // No padding needed here - Starting on a new 16-byte boundary
  vec4 mouse; // 4 * 4 bytes (Total 16/16 - Block filled)
} ubuf;

// Macros for Shadertoy value names
#define iTime ubuf.time
#define iResolution ubuf.resolution
#define iMouse ubuf.mouse
```

This shell currently provides time, resolution, and mouse. Every shader will require resolution, but mouse and time can be omitted if it not required. Additional inputs can be implemented in Wallpaper.qml if required.

### Setting Opacity

If you want QML's opacity property to work, it is as simple as multiplying the output by ubuf.qt_Opacity. This is not necessary in this case, as the wallpaper always has full opacity, but does not hurt. You can achieve this with the following line at the end of main:

```glsl
fragColor *= ubuf.qt_Opacity;
```

### Baking

Shaders for qt must be baked with the Qt Shader Baker (qsb). This will take your shader and generate a .qsb file that can be used by a Qt application. You can manually run qsb with the following syntax:

```sh
/usr/lib/qt6/bin/qsb --qt6 -o MyShader.frag.qsb MyShader.frag
```

Or you can use the provided `bakeAll.sh` script. If you have added your own shaders, add them to the list in `bakeAll.sh` before running. The script will bake all shaders in the list.
