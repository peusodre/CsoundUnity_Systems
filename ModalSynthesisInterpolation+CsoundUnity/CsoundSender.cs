using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CsoundSender : MonoBehaviour
{
	public CsoundUnity csound;

    [Range(0.0f, 108.0f)]
    public float kFreq;
    [Range(1f, 3f)]
    public int chordSwitcher;
    [Range(0.0f, 2.0f)]
    public float kObject1;
    [Range(0.0f, 3.0f)]
    public float kObject2;
    [Range(0.0f, 1f)]
    public float kControl;
    [Range(0.0f, 100f)]
    public float kVerbSend;
    [Range(0.0f, 2f)]
    public float kVerbRatio;
    [Range(0.1f, 1f)]
    public float Increment;


    public bool sendTrigger;
    public bool sendTrigger1;
    public float speed;
    public float speedFinal;
    public float multiplier;
    private float triggerValue;
    public Renderer[] rinders;
    public Material material;
    private Vector3 originalScale;
    private float colisionVel;
    public Rigidbody rb;


    void Start()
    {
        rb = gameObject.GetComponent<Rigidbody>();
        csound = GetComponent<CsoundUnity>();
        transform.localScale = transform.localScale * (84 / kFreq);
        originalScale = transform.localScale;


    }

    private void Update()
    {


        transform.localScale = originalScale * (84 / kFreq);



        foreach(Renderer rinder in rinders)
        {
            Color color = rinder.material.color;

            color.a = 1-kControl;
            rinder.material.color = color;
        }


    }

    void FixedUpdate()
    {
        kControl = Mathf.Clamp(kControl, 0, 1);

        if (sendTrigger == true)
        {
            sendTrigger = false;
            triggerValue = 1;
        }

        speedFinal = speed * multiplier;
        speedFinal = Mathf.Clamp(speedFinal, 0f, 1f);

        csound.setChannel("Trigger", triggerValue);
        csound.setChannel("Dynamics", speedFinal);
        csound.setChannel("Freq", kFreq);
        csound.setChannel("Object1", kObject1);
        csound.setChannel("Control", kControl);
        csound.setChannel("Object2", kObject2);
        csound.setChannel("verbSend", kVerbSend);
        csound.setChannel("verbRatio", kVerbRatio);



        if (triggerValue == 1)
        {
            triggerValue = 0;
        }

    }

     private void OnCollisionEnter(Collision collision)
        {
  
        colisionVel = Mathf.Abs(rb.angularVelocity.x + rb.angularVelocity.y + rb.angularVelocity.z);


        sendTrigger = true;
        speed = colisionVel;
        }
    }
