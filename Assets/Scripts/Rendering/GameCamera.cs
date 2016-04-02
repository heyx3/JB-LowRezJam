using UnityEngine;


[RequireComponent(typeof(Camera))]
public class GameCamera : Singleton<GameCamera>
{
    public Camera Cam { get; private set; }

    public bool UseDepthTexture = true;

    public override void Awake()
    {
        Cam = GetComponent<Camera>();

        if (RenderSettings.fog)
            RenderSettings.fogColor = Cam.backgroundColor;

        if (UseDepthTexture)
            Cam.depthTextureMode = DepthTextureMode.Depth;
    }
}