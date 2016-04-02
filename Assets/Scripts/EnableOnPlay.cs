using UnityEngine;


public class EnableOnPlay : MonoBehaviour
{
    public GameObject ToEnable;

    void Awake()
    {
        ToEnable.SetActive(true);
        Destroy(this);
    }
}