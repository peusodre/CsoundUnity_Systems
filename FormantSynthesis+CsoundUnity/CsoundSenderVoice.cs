using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CsoundSenderVoice : MonoBehaviour
{
    public CsoundUnity csound;
    public float X;
    public float Y;
    public float Z;
    //Works Nicely at 2470
    [Range(0.0f, 7000.0f)]
    public float Multiplier;

    // Start is called before the first frame update
    void Start()
    {
        csound = GetComponent<CsoundUnity>();

    }

    // Update is called once per frame
    void Update()
    {
       
        X = transform.localRotation.x *  Multiplier;
        Y = transform.localRotation.y * Multiplier;
        Z = transform.localRotation.z * Multiplier;

        csound.setChannel("X", X);
        csound.setChannel("Y", Y);
        csound.setChannel("Z", Z);

    }
}
