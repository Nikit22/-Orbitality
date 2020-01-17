using System.Collections.Generic;
using System.Linq;
using Orbitality.Core.Enums;
using Orbitality.Core.Extensions;
using Orbitality.Core.Input;
using Orbitality.Core.Pausable;
using Orbitality.Core.Views;
using UnityEngine;

namespace Orbitality.Core.Models
{
    public static class Universe
    {
        public static bool OnPause;

        public static readonly List<IPausable> PausableObjects = new List<IPausable>();
        public static readonly List<IGravityObject> GravityObjects = new List<IGravityObject>();
        public static readonly List<PlanetView> Planets = new List<PlanetView>();

        public static readonly Dictionary<RocketType, List<GameObject>> Rockets =
            new Dictionary<RocketType, List<GameObject>>
            {
                {RocketType.Light, new List<GameObject>()},
                {RocketType.Medium, new List<GameObject>()},
                {RocketType.Heavy, new List<GameObject>()}
            };

        public static Transform RocketsParent { get; private set; }

        public static void MakeBigBang()
        {
            Debug.Log("Big Bang");

            RocketsParent = new GameObject("Rockets").transform;
            foreach (var type in Rockets.Keys)
                for (var rocketIndex = 0; rocketIndex < 100; rocketIndex++)
                    Rockets[type].Add(type.CreateRocketWith(RocketsParent));
        }

        public static void CheckPlanets()
        {
            if (!Planets.Any(x => x.GetComponent<PlayerInput>()))
                GameOver();
            else if (!Planets.Any(x => x.GetComponent<AIInput>()))
                Win();
        }

        public static GameObject RocketBy(RocketType type)
        {
            var rockets = Rockets[type];
            if (rockets.Any())
            {
                var rocket = rockets.First();
                rockets.RemoveAt(0);
                return rocket;
            }

            var newRocket = type.CreateRocketWith(RocketsParent);
            rockets.Add(newRocket);

            return newRocket;
        }

        public static void ReturnRocketOfType(GameObject rocket, RocketType type)
        {
            rocket.transform.SetParent(RocketsParent);
            rocket.SetActive(false);

            Rockets[type].Add(rocket);
        }

        public static void Pause()
        {
            OnPause = true;

            foreach (var @object in PausableObjects)
                @object.Pause();

            Time.timeScale = 0f;
        }

        public static void Resume()
        {
            OnPause = false;

            foreach (var @object in PausableObjects)
                @object.Resume();

            Time.timeScale = 1f;
        }

        public static void MakeBigCrunch() => Application.Quit();

        private static void GameOver() =>
            Object.FindObjectOfType<GameOverMenu>().ActivateGameOverMenu();

        private static void Win() =>
            Object.FindObjectOfType<GameOverMenu>().ActivateYouWinMenuMenu();
    }
}