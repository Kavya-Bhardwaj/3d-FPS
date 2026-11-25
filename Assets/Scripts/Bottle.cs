using UnityEngine;

public class Bottle : MonoBehaviour
{
    [Header("Audio")]
    public AudioClip breakSound;

    [Header("Optional Custom Prefab")]
    public GameObject customBreakEffectPrefab;

    private bool isBroken = false;

    public void Break()
    {
        if (isBroken) return;
        isBroken = true;

        // 1. Realistic Sound Play (Volume slightly balanced)
        if (breakSound != null)
        {
            AudioSource.PlayClipAtPoint(breakSound, transform.position, 0.85f);
        }

        // 2. Realistic Visual Shatter FX
        if (customBreakEffectPrefab != null)
        {
            Instantiate(customBreakEffectPrefab, transform.position, transform.rotation);
        }
        else
        {
            CreateRealisticGlassShatter();
        }

        // 3. Score Add
        if (GameManager.Instance != null)
        {
            GameManager.Instance.AddScore();
        }

        // 4. Bottle Destroy
        Destroy(gameObject);
    }

    /// <summary>
    /// Realistic glass shatter: Chote sharp shards, natural reflection color, aur quick downward gravity fall.
    /// </summary>
    void CreateRealisticGlassShatter()
    {
        GameObject shardFx = new GameObject("GlassShatter_Realistic");
        shardFx.transform.position = transform.position;

        ParticleSystem ps = shardFx.AddComponent<ParticleSystem>();
        var main = ps.main;
        
        // Short lifetime: Kaanch turant bikhar kar girta hai
        main.startLifetime = new ParticleSystem.MinMaxCurve(0.45f, 0.75f);
        
        // Realistic moderate outward speed
        main.startSpeed = new ParticleSystem.MinMaxCurve(1.5f, 3.2f);
        
        // Chote kaanch ke tukde (not huge blocks)
        main.startSize = new ParticleSystem.MinMaxCurve(0.025f, 0.06f);
        
        // Translucent natural glass shade (Halka grayish-white glass look)
        main.startColor = new Color(0.92f, 0.95f, 0.96f, 0.75f);
        
        // High gravity: Tukde hawa me tairne ke bajaye turant zameen par girenge
        main.gravityModifier = 3.2f;
        
        // Random rotation for shards
        main.startRotation = new ParticleSystem.MinMaxCurve(0f, 360f * Mathf.Deg2Rad);

        // Emission: 30-40 sharp shards ek sath burst hote hain
        var emission = ps.emission;
        emission.rateOverTime = 0;
        emission.SetBursts(new ParticleSystem.Burst[] { 
            new ParticleSystem.Burst(0f, 35) 
        });

        // Shape: Bottle ke volume se nikalta hua narrow cylinder/sphere
        var shape = ps.shape;
        shape.shapeType = ParticleSystemShapeType.Sphere;
        shape.radius = 0.12f; // Slim radius match with bottle width

        // Rotation over lifetime: Tukde ghumte hue girenge
        var rotOverLife = ps.rotationOverLifetime;
        rotOverLife.enabled = true;
        rotOverLife.z = new ParticleSystem.MinMaxCurve(-180f, 180f);

        // Size over lifetime: Dur jate hue shrink honge
        var sizeOverLife = ps.sizeOverLifetime;
        sizeOverLife.enabled = true;
        AnimationCurve curve = new AnimationCurve();
        curve.AddKey(0.0f, 1.0f);
        curve.AddKey(1.0f, 0.2f);
        sizeOverLife.size = new ParticleSystem.MinMaxCurve(1.0f, curve);

        ps.Play();
        
        // Destroy FX object cleanly after particles finish
        Destroy(shardFx, 1.2f);
    }
}
