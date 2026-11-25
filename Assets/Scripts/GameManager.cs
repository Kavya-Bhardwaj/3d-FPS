using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using TMPro; // <-- TextMeshPro support ke liye

public class GameManager : MonoBehaviour
{
    public static GameManager Instance;

    [Header("Game Settings")]
    public int maxBullets = 5;
    public int totalBottles = 5;

    [Header("UI Elements (TextMeshPro)")]
    public TextMeshProUGUI scoreText;      // TMP Text drag karne ke liye
    public TextMeshProUGUI ammoText;       // TMP Text drag karne ke liye
    public TextMeshProUGUI resultText;     // TMP Text drag karne ke liye

    [Header("UI Panels & Buttons")]
    public GameObject gameOverPanel;
    public Button restartButton;

    

    private int currentScore = 0;
    private int currentBullets;
    private bool isGameOver = false;

    void Awake()
    {
        if (Instance == null) Instance = this;
        else Destroy(gameObject);
    }

    void Start()
    {
        currentBullets = maxBullets;
        UpdateUI();
        if (gameOverPanel != null) gameOverPanel.SetActive(false);
        if (restartButton != null) restartButton.onClick.AddListener(RestartGame);
    }

    public bool CanShoot()
    {
        return currentBullets > 0 && !isGameOver;
    }

    public void BulletUsed()
    {
        currentBullets--;
        UpdateUI();
        CheckGameCondition();
    }

    public void AddScore()
    {
        currentScore++;
        UpdateUI();
        CheckGameCondition();
    }

    void UpdateUI()
    {
        if (scoreText != null) scoreText.text = "Score: " + currentScore + " / " + totalBottles;
        if (ammoText != null) ammoText.text = "Bullets: " + currentBullets + " / " + maxBullets;
    }

    void CheckGameCondition()
    {
        if (currentScore >= totalBottles)
        {
            EndGame(true);
        }
        else if (currentBullets <= 0)
        {
            EndGame(false);
        }
    }

    void EndGame(bool won)
    {
        isGameOver = true;
        if (gameOverPanel != null) gameOverPanel.SetActive(true);
        if (resultText != null)
        {
            resultText.text = won ? "You Won! All Bottles Destroyed!" : "Game Over! Out of Bullets!";
        }
    }

    public void RestartGame()
    {
        SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
    }
    
}
