using System;
using UnityEngine;


[Serializable]
public class ComplexCurve
{
    public static float ModTime(float t, AnimationCurve c)
    {
        Keyframe kf = c.keys[c.keys.Length - 1];
        while (t > kf.time)
            t -= kf.time;
        return t;
    }


    public AnimationCurve MinCurve, MaxCurve, CurveIntepolator;

    public float SpeedScale = 1.0f;

    [NonSerialized]
    public float Elapsed = 0.0f;


    public void Update(float deltaT)
    {
        Elapsed += SpeedScale * deltaT;
    }
    public float GetValue()
    {
        return Mathf.Lerp(MinCurve.Evaluate(ModTime(Elapsed, MinCurve)),
                          MaxCurve.Evaluate(ModTime(Elapsed, MaxCurve)),
                          CurveIntepolator.Evaluate(ModTime(Elapsed, CurveIntepolator)));
    }
}