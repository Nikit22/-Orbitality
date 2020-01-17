using System.Collections;
using DG.Tweening;
using DG.Tweening.Core;
using DG.Tweening.Plugins.Options;
using Orbitality.Core.Extensions;
using Orbitality.Core.Models;
using UnityEngine;
using Random = UnityEngine.Random;

namespace Orbitality.Core.Pausable
{
    public class FallingObject : PausableMonoBehaviour
    {
        public Vector3 spawnPoint;
        public Vector3 endPoint;
    
        public float duration;
    
        private TweenerCore<Vector3, Vector3, VectorOptions> moveTween;
        private Coroutine waiting;

        private Vector3 RandomOffset => Random.insideUnitCircle * 300f;
        private Vector3 SpawnPoint => spawnPoint + RandomOffset;
        private Vector3 EndPoint => endPoint + RandomOffset;
        private float Duration => duration + Random.Range(-2f, 2f);
        private float WaitDuration => duration / 2 + Random.Range(-2f, 2f);

        private void Awake()
        {
            Spawn();
            Launch();
        }

        private void OnApplicationQuit() => waiting.StopFor(this);

        public override void Pause() => moveTween?.Pause();

        public override void Resume()
        {
            if (waiting == null)
                moveTween?.Play();
        }

        private void Launch()
        {
            moveTween = transform.DOLocalMove(EndPoint, Duration, true);
            moveTween.onComplete += () => { waiting = StartCoroutine(WaitForResume()); };
        }

        private IEnumerator WaitForResume()
        {
            yield return new WaitForSeconds(WaitDuration);
        
            if (Universe.OnPause)
                yield return new WaitUntil(() => !Universe.OnPause);

            waiting = null;
            
            Spawn();
            Launch();
        }

        private void Spawn() => 
            transform.localPosition = SpawnPoint;
    }
}
