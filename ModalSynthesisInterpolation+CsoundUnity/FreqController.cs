using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FreqController : MonoBehaviour
{
    [Range(0.0f, 108.0f)]
    public int kFreq1;
    [Range(0.0f, 108.0f)]
    public int kFreq2;
    [Range(0.0f, 108.0f)]
    public int kFreq3;
    [Range(0.0f, 108.0f)]
    public int kFreq4;

    [Range(0, 3)]
    public int chordSwitcher1;

    [Range(0.0f, 1f)]
    public float mainKcontrol;

    public int[] chord1Notes;
    public int[] chord2Notes;
    public int[] chord3Notes;

    private int kOriginalFreq1;
    private int kOriginalFreq2;
    private int kOriginalFreq3;


    public CsoundSender[] Senders;



    // Update is called once per frame

    void Start()
    {
        kOriginalFreq1 = kFreq1;
        kOriginalFreq2 = kFreq2;
        kOriginalFreq3 = kFreq3;
    }
    void Update()
    {

        foreach (var Sender in Senders)
        {
            Sender.kControl = mainKcontrol;
        }

        if (Senders[0] != null)
        {
            switch (chordSwitcher1)
            {
                case 1:
                    kFreq1 = chord1Notes[0];
                    break;
                case 2:
                    kFreq1 = chord2Notes[1];
                    break;
                case 3:
                    kFreq1 = chord3Notes[2];
                    break;

            }

            Senders[0].kFreq = kFreq1;

        }



        if (Senders[1] != null)
        {
            switch (chordSwitcher1)
            {
                case 1:
                    kFreq2 = chord2Notes[0];
                    break;
                case 2:
                    kFreq2 = chord2Notes[1];
                    break;
                case 3:
                    kFreq2 = chord2Notes[2];
                    break;

            }

            Senders[1].kFreq = kFreq2;
        }

        if (Senders[2] != null)
        {

            switch (chordSwitcher1)
            {
                case 1:
                    kFreq3 = chord3Notes[0];
                    break;
                case 2:
                    kFreq3 = chord3Notes[1];
                    break;
                case 3:
                    kFreq3 = chord3Notes[2];
                    break;

            }
            Senders[2].kFreq = kFreq3;
        }
    }

}
