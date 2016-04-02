using UnityEngine;


public class Singleton<T> : MonoBehaviour
    where T : Singleton<T>
{
    public static T Instance;


    public virtual void Awake()
    {
        UnityEngine.Assertions.Assert.IsNull(Instance);
        Instance = (T)this;
    }
    public virtual void OnDestroy()
    {
        if (Instance == this)
            Instance = null;
    }
}