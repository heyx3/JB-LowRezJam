using System;
using System.Collections.Generic;
using UnityEngine;


/// <summary>
/// The quad that renders the game into the screen camera.
/// </summary>
[RequireComponent(typeof(MeshFilter))]
[RequireComponent(typeof(MeshRenderer))]
public class ScreenQuad : MonoBehaviour
{
    private static Mesh m = null;
    private static void InitMesh()
    {
        if (m == null)
        {
            m = new Mesh();
            m.vertices = new Vector3[] { new Vector3(-1.0f, -1.0f), new Vector3(1.0f, -1.0f),
                                         new Vector3(-1.0f, 1.0f), new Vector3(1.0f, 1.0f) };
            m.uv = new Vector2[] { new Vector2(0.0f, 0.0f), new Vector2(1.0f, 0.0f),
                                   new Vector2(0.0f, 1.0f), new Vector2(1.0f, 1.0f) };
            m.triangles = new int[] { 0, 1, 2, 1, 3, 2 };
            m.UploadMeshData(true);
        }
    }


	private MeshRenderer mr;

    void Awake()
    {
        InitMesh();
        GetComponent<MeshFilter>().sharedMesh = m;

		mr = GetComponent<MeshRenderer>();
    }
	void Update()
	{
		mr.sharedMaterial.SetFloat("_DistanceToEnemy", Enemy.Instance.DistToPlayerLerp);
	}
}
