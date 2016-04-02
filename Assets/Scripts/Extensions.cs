using System;
using System.Collections.Generic;
using UnityEngine;


public static class Extensions
{
    public static Vector2 GetHorz(this Vector3 v) { return new Vector2(v.x, v.z); }
    public static Vector2 GetHorzN(this Vector3 v) { return v.GetHorz().normalized; }

    public static Vector3 To3D(this Vector2 v, float z = 0.0f) { return new Vector3(v.x, z, v.y); }
}