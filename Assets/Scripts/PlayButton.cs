using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

[RequireComponent(typeof(Button))]
public class PlayButton : MonoBehaviour
{
    [Header("Scene Settings")]
    [Tooltip("Apne gameplay scene ka exact naam yahan likhein")]
    public string gameplaySceneName = "GameplayScene";

    void Start()
    {
        // Button component ko automatically detect karke click event attach karta hai
        Button btn = GetComponent<Button>();
        if (btn != null)
        {
            btn.onClick.AddListener(LoadGameScene);
        }
    }

    public void LoadGameScene()
    {
        Debug.Log("Loading Scene: " + gameplaySceneName);
        SceneManager.LoadScene(gameplaySceneName);
    }
}