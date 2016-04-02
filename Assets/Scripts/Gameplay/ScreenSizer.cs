using UnityEngine;
using System.Collections;

public class ScreenSizer : Singleton<ScreenSizer>
{
    public int Width = 64,
               Height = 64;

    private int oldW = 0,
                oldH = 0;


    void Update()
    {
        //Update window size if necessary.
        if (Width != oldW && Height != oldH)
        {
            Screen.SetResolution(Width, Height, false);
            oldW = Width;
            oldH = Height;
        }
    }
}
