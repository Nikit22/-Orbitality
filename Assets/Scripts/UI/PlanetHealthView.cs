using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class PlanetHealthView : MonoBehaviour
{
    public Slider slider;
    public Image image;
    public Color fullHealthColor = Color.green;
    public Color zeroHealthColor = Color.red;

    private void OnEnable() => UpdateUI(100f);

    public void UpdateUI(float health)
    {
        slider.value = health;
        image.color = Color.Lerp(zeroHealthColor, fullHealthColor, health / 100f);
    }
}