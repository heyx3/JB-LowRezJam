using System;
using UnityEngine;


[RequireComponent(typeof(Light))]
public class LightAnimator : MonoBehaviour
{
    public Color MinCol = Color.white,
                 MaxCol = Color.white;
    public ComplexCurve ColorLerper = new ComplexCurve();


    public Light Lght { get; private set; }


    void Awake()
    {
        Lght = GetComponent<Light>();
        ColorLerper.Elapsed = 0.0f;
    }
    void Update()
    {
        ColorLerper.Update(Time.deltaTime);
        Lght.color = Color.Lerp(MinCol, MaxCol, ColorLerper.GetValue());
    }
}