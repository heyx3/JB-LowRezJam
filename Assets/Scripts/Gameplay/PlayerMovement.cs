using System;
using UnityEngine;


[RequireComponent(typeof(CharacterController))]
public class PlayerMovement : Singleton<PlayerMovement>
{
    public float Speed = 2.5f;
	public float TurnSpeed = 5.0f;
    public float FallSpeed = -10.0f;


    public bool IsOnGround { get; private set; }
    public CharacterController Char { get; private set; }
    public Transform Tr { get; private set; }


    private Vector2 moveInput = Vector2.zero;


    public override void Awake()
    {
        base.Awake();

        IsOnGround = false;
        Char = GetComponent<CharacterController>();
        Tr = transform;
    }
    void Update()
    {
		//Accumulate movement input.
        if (Input.GetKey(KeyCode.W))
            moveInput.y += Time.deltaTime;
        if (Input.GetKey(KeyCode.S))
            moveInput.y -= Time.deltaTime;

        if (Input.GetKey(KeyCode.D))
            moveInput.x += Time.deltaTime;
        if (Input.GetKey(KeyCode.A))
            moveInput.x -= Time.deltaTime;


		//Apply turning input instantly; it doesn't affect physics.
		float yaw = Input.GetAxis("Mouse X"),
			  pitch = Input.GetAxis("Mouse Y");
		Tr.Rotate(new Vector3(0.0f, 1.0f, 0.0f), yaw * TurnSpeed, Space.World);
		Tr.Rotate(new Vector3(-1.0f, 0.0f, 0.0f), pitch * TurnSpeed, Space.Self);
    }
    void FixedUpdate()
    {
		//Apply movement input.
        CollisionFlags coll = Char.Move(new Vector3(0.0f, FallSpeed * Time.deltaTime, 0.0f) +
                                       (Tr.forward.GetHorzN() * moveInput.y * Speed).To3D() +
                                       (Tr.right.GetHorzN() * moveInput.x * Speed).To3D());
        if ((coll & CollisionFlags.Below) != CollisionFlags.None)
        {
            IsOnGround = true;
        }
        else
        {
            IsOnGround = false;
        }

        moveInput = Vector2.zero;
    }
}