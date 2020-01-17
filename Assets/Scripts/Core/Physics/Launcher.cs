using System.Collections;
using Orbitality.Core.Enums;
using Orbitality.Core.Extensions;
using Orbitality.Core.Input;
using Orbitality.Core.Models;
using Orbitality.Core.Views;
using UnityEngine;
using Random = UnityEngine.Random;

namespace Orbitality.Core.Physics
{
    public class Launcher : MonoBehaviour
    {
        public float maxLaunchSpeed;
        public float launchSpeed;

        private RocketType rocketType;
        private float extraSpeedPerFrame;

        private Coroutine launching;
        public bool ReadyToLaunch { get; private set; }

        public void Awake()
        {
            extraSpeedPerFrame = maxLaunchSpeed * Time.fixedDeltaTime;
            rocketType = (RocketType) Random.Range(0, 3);
        }

        public void StartLaunching()
        {
            launchSpeed = 0;
            ReadyToLaunch = true;

            launching = StartCoroutine(IncreaseLaunchSpeed(Time.deltaTime));
        }

        private IEnumerator IncreaseLaunchSpeed(float waitTime)
        {
            while (ReadyToLaunch)
            {
                yield return new WaitForSeconds(waitTime);

                IncreaseLaunchSpeed();
            }
        }

        public void Launch(float percentage = 0f)
        {
            if (percentage > 0f)
                launchSpeed = maxLaunchSpeed * percentage;
            
            ReadyToLaunch = false;

            launching.StopFor(this);

            var rocket = Universe.RocketBy(rocketType);
            if (rocket == null)
                return;
            
            rocket.transform.SetParent(transform.parent);
            rocket.transform.localPosition = transform.localPosition;
            rocket.transform.localRotation = transform.localRotation;
            rocket.SetActive(true);

            var rocketView = rocket.GetComponent<RocketView>();
            var direction = rocketView.transform.up.normalized;
            var launchVelocity = direction * (launchSpeed * rocketView.Rocket.Characteristics.acceleration);

            rocketView.Rocket.AddForce(launchVelocity);
        }

        private void IncreaseLaunchSpeed()
        {
            if (launchSpeed <= maxLaunchSpeed)
                launchSpeed += extraSpeedPerFrame;
        }
    }
}