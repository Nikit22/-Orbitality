using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Orbitality.Core;
using Orbitality.Core.Models;
using Orbitality.Core.Views;
using UnityEngine;
using UnityEngine.UI;
using Random = UnityEngine.Random;

public class MainMenu : MonoBehaviour
{
    public GameObject mainBackground;
    
    public GameObject planets;
    public Transform universe;

    public InputField minField;
    public InputField maxField;

    public int min = 1;
    public int max = 4;

    private bool subsrcibed;
    private GameObject planetsPrefab;


    private void Update()
    {
        if (minField == null || !minField.IsActive() || subsrcibed)
            return;

        minField.text = min.ToString();
        maxField.text = max.ToString();

        minField.onEndEdit.AddListener(value =>
        {
            var min = int.Parse(value);
            if (min <= 0 || min > 4 || min > max)
            {
                min = 1;
                minField.text = min.ToString();
            }

            this.min = min;
        });
        maxField.onEndEdit.AddListener(value =>
        {
            var max = int.Parse(value);
            if (max <= 0 || max > 4 || max < min)
            {
                max = 4;
                maxField.text = max.ToString();
            }

            this.max = max;
        });

        subsrcibed = true;
    }

    public void StartGame()
    {
        if (planets == null)
            planets = Instantiate(Resources.Load<GameObject>("Planets"), universe);
        
        var sunAndEarth = new List<GameObject>
        {
            planets.transform.GetChild(0).gameObject,
            planets.transform.GetChild(1).gameObject
        };

        foreach (var planet in sunAndEarth)
            planet.SetActive(true);

        var numberOfPlanets = Random.Range(min, max + 1);
        foreach (var planet in planets.transform.GetComponentsInChildren<PlanetView>(true).Skip(2)
            .OrderBy(x => Random.Range(0f, 1f)).Take(numberOfPlanets))
            planet.gameObject.SetActive(true);

        mainBackground.SetActive(false);

        if (Universe.OnPause)
            Universe.Resume();
    }
}