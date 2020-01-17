using UnityEngine;

namespace Orbitality.Core.Pausable
{
    public class SpaceObject : PausableMonoBehaviour
    {
        public float speed;

        private Animation animation;
        private AnimationClip animationClip;

        private float timeSinceAnimationStart;

        private void Awake()
        {
            animation = GetComponent<Animation>();
            animationClip = animation.clip;

            Configure();
            animation.Play();
        }
        
        public override void Pause()
        {
            timeSinceAnimationStart = animation[animationClip.name].time;
            animation[animationClip.name].speed = 0;
        }

        public override void Resume()
        {
            animation[animationClip.name].time = timeSinceAnimationStart;
            animation[animationClip.name].speed = speed;
        }

        private void Configure()
        {
            animation.wrapMode = WrapMode.Loop;
            animation[animationClip.name].speed = speed;
        }
    }
}