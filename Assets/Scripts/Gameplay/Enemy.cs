using System;
using UnityEngine;


public class Enemy : Singleton<Enemy>
{
	public float StartEffectDistance;


	public Transform Tr { get; private set; }

	public float DistToPlayerLerp { get; private set; }


	public override void Awake()
	{
		base.Awake();

		Tr = transform;
	}
	void FixedUpdate()
	{
		float dist = Vector2.Distance(Tr.position, PlayerMovement.Instance.Tr.position);
		DistToPlayerLerp = Mathf.Clamp01(Mathf.InverseLerp(0.0f, StartEffectDistance, dist));
	}
}