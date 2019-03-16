import processing.video.*;

Capture video;

void captureEvent(Capture video) {
  video.read();
}

void setup() 
{  
  size(640, 480);

  video = new Capture(this, 640, 480);
  video.start();
}

void draw() 
{  
  edgeDetection(15);
}

void edgeDetection(int threshold)
{
  loadPixels();
  video.loadPixels();

  for (int x = 0; x < video.width; x++)
  {
    for (int y = 0; y < video.height; y++)
    {
      int loc = x + y * video.width;

      float r = red(video.pixels[loc]);
      float g = green(video.pixels[loc]);
      float b = blue(video.pixels[loc]);

      float rr = -1;
      float gr = -1;
      float br = -1;

      float rb = -1;
      float gb = -1;
      float bb = -1;

      if (loc % video.width - 1 != 0 && loc < video.width * video.height - 1)
      {
        rr = red(video.pixels[loc + 1]);
        gr = green(video.pixels[loc + 1]);
        br = blue(video.pixels[loc + 1]);
      }

      if (loc < video.width * video.height - video.width)
      {
        rb = red(video.pixels[loc + video.width]);
        gb = green(video.pixels[loc + video.width]);
        bb = blue(video.pixels[loc + video.width]);
      }

      if (rr != -1 && gr != -1 && br != -1 && rb != -1 && gb != -1 && bb != -1)
      {
        float differenceR = sqrt(sq(r - rr) + sq(g - gr) + sq(b - br));
        float differenceB = sqrt(sq(r - rb) + sq(g - gb) + sq(b - bb));

        if (differenceR > threshold || differenceB > threshold)
        {
          pixels[loc] = color(0);
        } else
        {
          pixels[loc] = color(255);
        }
      } else
      {
        pixels[loc] = color(255);
      }
    }
  }
  updatePixels();
}
