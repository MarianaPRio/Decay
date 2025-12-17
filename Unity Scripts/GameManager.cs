using System;
using System.IO;
using System.Net.Sockets;
using System.Threading;

using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using Unity.VisualScripting;
using System.Text.RegularExpressions;

public class PlayerStats
{
    public string name;
    public string rank;
    public string classe;

    public int hp;
    public int maxHp;

    public int level;
    public int xp;
    public int maxXp;

    public int strenght;
    public int health;
    public int agility;
    public int statsPoints;

    public int accuracy;
    public int dodging;
    public int strikeDamage;
    public int damageAbsobtion;

    public PlayerStats()
    { }

    public PlayerStats(string name, string rank, string classe, int hp, int level, int xp, int maxXp, int strenght, int health, int agility, int statsPoints, int accuracy, int dodging, int strikeDamage, int damageAbsobtion)
    {
        this.name = name;
        this.rank = rank;
        this.classe = classe;
        this.hp = hp;
        this.level = level;
        this.xp = xp;
        this.maxXp = maxXp;
        this.strenght = strenght;
        this.health = health;
        this.agility = agility;
        this.statsPoints = statsPoints;
        this.accuracy = accuracy;
        this.dodging = dodging;
        this.strikeDamage = strikeDamage;
        this.damageAbsobtion = damageAbsobtion;
    }

    public float XpPercentage
    {
        get
        {
            if (maxXp == 0) return 0;
            return (float)xp / maxXp;
        }
    }
}

public class GameManager : MonoBehaviour
{
    [Header("UI")]
    public TMP_InputField chatBox;
    [SerializeField] TMP_Text levelSmallText;
    [SerializeField] TMP_Text xpSmallText;
    [SerializeField] FillBar healthBar;
    [SerializeField] TMP_Text nameText;
    [SerializeField] TMP_Text rankText;
    [SerializeField] TMP_Text classText;
    [SerializeField] TMP_Text levelText;
    [SerializeField] TMP_Text xpText;
    [SerializeField] TMP_Text strengthText;
    [SerializeField] TMP_Text healthText;
    [SerializeField] TMP_Text agilityText;
    [SerializeField] TMP_Text statPointsText;
    [SerializeField] TMP_Text accuracyText;
    [SerializeField] TMP_Text dodgingText;
    [SerializeField] TMP_Text strikeDamageText;
    [SerializeField] TMP_Text damageAbsobtionText;

    [SerializeField] TMP_Text regionText;
    [SerializeField] TMP_Text roomText;
    [SerializeField] TMP_Text statusText;

    [SerializeField] int maxMessages = 40;
    [SerializeField] GameObject chatPanel;
    [SerializeField] TextMeshProUGUI textPrefab;
    [SerializeField] Scrollbar scrollBar;
    [SerializeField] Color playerColor = Color.white;
    [SerializeField] Color systemColor = Color.green;

    [Header("Servidor TCP")]
    public string host = "127.0.0.1";
    public int port = 5100;

    private TcpClient client;
    private StreamReader reader;
    private StreamWriter writer;
    private Thread listenThread;
    private PlayerStats playerStats = new PlayerStats();

    private bool injectedInitialNamePrompt = false;

    private bool initialKickSent = false;
    private bool initialInfoRequested = false;

    private bool pendingSilentStats = false;
    private bool inSilentStatsBlock = false;

    private bool canAutoRequestStats = false;

    [SerializeField]
    List<Message> messageList = new List<Message>();

    void Start()
    {
        UnityMainThreadDispatcher.Instance();
        try
        {
            client = new TcpClient(host, port);
            var stream = client.GetStream();

            reader = new StreamReader(stream);
            writer = new StreamWriter(stream) { AutoFlush = true };

            listenThread = new Thread(ListenForMessages);
            listenThread.IsBackground = true;
            listenThread.Start();

            SendInitialKick();

        }
        catch (Exception e)
        {
            SendMessageToChat("Error: " + e.Message, Message.MessageType.info);
        }
    }

    void Update()
    {
        if (chatBox.text != "")
        {
            if (Input.GetKeyDown(KeyCode.Return))
            {
                string msg = chatBox.text;
                SendInput(msg);

                SendMessageToChat(chatBox.text, Message.MessageType.playerMessage);
                chatBox.text = "";
            }
        }
        else
        {
            if (!chatBox.isFocused && Input.GetKeyDown(KeyCode.Return))
            {
                chatBox.ActivateInputField();
            }
        }
    }

    private void RequestStatsSilently()
    {
        pendingSilentStats = true;
        writer?.WriteLine("stats");
    }

    private void ListenForMessages()
    {
        try
        {
            while (true)
            {
                string line = reader.ReadLine();

                if (line != null)
                {
                    string cleaned = RemoveAnsiCodes(line);
                    if (cleaned.Contains("Fragments of your last session have been recovered"))
                    {
                        canAutoRequestStats = true;
                    }

                    if (!initialInfoRequested && cleaned.Contains("has entered"))
                    {
                        initialInfoRequested = true;
                        try
                        {
                            writer?.WriteLine("look");

                            if (canAutoRequestStats)
                            {
                                RequestStatsSilently();
                            }
                        }
                        catch (Exception e)
                        {
                            Debug.LogError("Erro ao enviar comandos iniciais: " + e.Message);
                        }
                    }

              
                    UnityMainThreadDispatcher.Instance().Enqueue(() =>
                    {
                        SendMessageToChat(cleaned, Message.MessageType.info);
                    });
                }


                Thread.Sleep(20);
            }
        }
        catch (Exception e)
        {
            UnityMainThreadDispatcher.Instance().Enqueue(() =>
            {
                SendMessageToChat("Erro de conexao: " + e.Message, Message.MessageType.info);
            });
        }
    }

    private void SendInitialKick()
    {
        if (initialKickSent) return;
        initialKickSent = true;

        try
        {
            writer?.WriteLine();
            Debug.Log("Kick inicial enviado ao servidor.");
        }
        catch (Exception e)
        {
            Debug.LogError("Erro ao enviar kick inicial: " + e.Message);
        }
    }

    public void SendInput(string input)
    {
        if (!string.IsNullOrWhiteSpace(input))
        {
            writer?.WriteLine(input);
        }
    }

    private bool TryExtractLifeBlock(string text, out int current, out int max)
    {
        Match match = Regex.Match(text, @"\[(\d+)/(\d+)\]");

        if (match.Success)
        {
            current = int.Parse(match.Groups[1].Value);
            max = int.Parse(match.Groups[2].Value);
            return true;
        }

        current = 0;
        max = 0;
        return false;
    }

    public void SendMessageToChat(string text, Message.MessageType messageType)
    {

        if (PlayerStatsParser.TryParse(text, playerStats))
        {
            rankText.text = $"<b>Rank</b>:{playerStats.rank}";
            nameText.text = $"<b>Name</b>:{playerStats.name}";
            classText.text = $"<b>Class</b>:{playerStats.classe}";
            levelText.text = $"<b>Level</b>: {playerStats.level}";
            xpText.text = $"<b>Xp</b>: {playerStats.xp}/{playerStats.maxXp} ({playerStats.XpPercentage:P1})";

            if (levelSmallText != null)
                levelSmallText.text = $"Level: {playerStats.level}";

            if (xpSmallText != null)
                xpSmallText.text = $"Xp: {playerStats.XpPercentage:P0}";

            strengthText.text = $"<b>Strength</b>: {playerStats.strenght}";
            healthText.text = $"<b>Health</b>: {playerStats.health}";
            agilityText.text = $"<b>Agility</b>: {playerStats.agility}";
            statPointsText.text = $"<b>StatPoints</b>: {playerStats.statsPoints}";
            accuracyText.text = $"<b>Accuracy</b>: {playerStats.accuracy}";
            dodgingText.text = $"<b>Dodging</b>: {playerStats.dodging}";
            strikeDamageText.text = $"<b>Strike Damage</b>: {playerStats.strikeDamage}";
            damageAbsobtionText.text = $"<b>Damage Absorb</b>: {playerStats.damageAbsobtion}";
        }

        if (LocationParser.TryParseRoomHeader(text, out var regionName, out var roomName))
        {
            if (regionText != null)
                regionText.text = $"Region: {regionName}";

            if (roomText != null)
                roomText.text = $"Room: {roomName}";
        }
        else if (LocationParser.TryParseRegionTag(text, out var regionOnly))
        {
            if (regionText != null)
                regionText.text = $"Region: {regionOnly}";
        }

        if (StatusParser.TryParse(text, out var statusLabel, out var statusValue))
        {
            if (statusText != null)
                statusText.text = $"{statusLabel}: {statusValue}";
        }

        if (TryExtractLifeBlock(text, out int current, out int max))
        {
            healthBar.SetFillAmount(current, max);
            Debug.Log($"Vida atual: {current}, Vida máxima: {max}");
        }
        else
        {
            Debug.Log($"Bloco de vida não encontrado {text}");
        }

        if (pendingSilentStats && text.Contains("Your Stats"))
        {
            inSilentStatsBlock = true;
            pendingSilentStats = false;
        }

        if (inSilentStatsBlock)
        {
            if (string.IsNullOrWhiteSpace(text) ||
                text.StartsWith("---") || text.StartsWith("-----"))
            {
                inSilentStatsBlock = false;
            }

            return; 
        }


        if (messageList.Count >= maxMessages)
        {
            Destroy(messageList[0].textObject.gameObject);
            messageList.RemoveAt(0);
        }

        Debug.Log("Adding message to chat: " + text);
        Message newMessage = new Message
        {
            text = text
        };

        TextMeshProUGUI newText = Instantiate(textPrefab, chatPanel.transform);
        newMessage.textObject = newText;
        newMessage.textObject.text = newMessage.text;
        newMessage.textObject.color = MessageTypeColor(messageType);

        messageList.Add(newMessage);

        Canvas.ForceUpdateCanvases();
        scrollBar.value = 0;
    }

    Color MessageTypeColor(Message.MessageType messageType)
    {
        Color color = Color.green;

        switch (messageType)
        {
            case Message.MessageType.playerMessage:
                color = playerColor;
                break;
            case Message.MessageType.info:
                color = systemColor;
                break;
        }

        return color;
    }

    private string RemoveAnsiCodes(string input)
    {
        return System.Text.RegularExpressions.Regex.Replace(input, @"\x1B\[[0-9;]*[mK]", "");
    }

    private void OnApplicationQuit()
    {
        listenThread?.Abort();
        writer?.Close();
        reader?.Close();
    }
}

public static class PlayerStatsParser
{
    private static readonly Regex hpRegex = new Regex(@"HP/Max:\s*(\d+)/(\d+)", RegexOptions.Compiled);
    private static readonly Regex experienceRegex = new Regex(@"Experience:\s*(\d+)/(\d+)", RegexOptions.Compiled);
    private static readonly Regex levelRegex = new Regex(@"Level:\s*(\d+)", RegexOptions.Compiled);

    private static readonly Regex nameRegex = new Regex(@"Name:\s*(.+)", RegexOptions.Compiled);
    private static readonly Regex rankRegex = new Regex(@"Rank:\s*(.+)", RegexOptions.Compiled);
    private static readonly Regex classRegex = new Regex(@"Class:\s*(.+)", RegexOptions.Compiled);

    private static readonly Regex labelIntRegex =
        new Regex(@"(?<label>[A-Za-z ]+):\s*(?<value>\d+)", RegexOptions.Compiled);

    public static bool TryParse(string text, PlayerStats stats)
    {
        bool anyMatch = false;

        if (stats == null) return false;

        if (TryMatch(nameRegex, text, ref stats.name)) anyMatch = true;
        if (TryMatch(rankRegex, text, ref stats.rank)) anyMatch = true;
        if (TryMatch(classRegex, text, ref stats.classe)) anyMatch = true;

        if (TryMatch(hpRegex, text, ref stats.hp, ref stats.maxHp)) anyMatch = true;
        if (TryMatch(levelRegex, text, ref stats.level)) anyMatch = true;
        if (TryMatch(experienceRegex, text, ref stats.xp, ref stats.maxXp)) anyMatch = true;

        if (TryMatchLabel(text, stats)) anyMatch = true;

        return anyMatch;
    }

    private static bool TryMatch(Regex regex, string text, ref string attribute)
    {
        Match match = regex.Match(text);

        if (!match.Success) return false;

        attribute = match.Groups[1].Value.Trim();
        return true;
    }

    private static bool TryMatch(Regex regex, string text, ref int attribute)
    {
        Match match = regex.Match(text);

        if (!match.Success) return false;

        attribute = int.Parse(match.Groups[1].Value.Trim());
        return true;
    }

    private static bool TryMatch(Regex regex, string text, ref int attribute1, ref int attribute2)
    {
        Match match = regex.Match(text);

        if (!match.Success) return false;

        attribute1 = int.Parse(match.Groups[1].Value.Trim());
        attribute2 = int.Parse(match.Groups[2].Value.Trim());
        return true;
    }

    private static bool TryMatchLabel(string text, PlayerStats stats)
    {
        bool any = false;

        MatchCollection labelMatches = labelIntRegex.Matches(text);

        for (int i = 0; i < labelMatches.Count; i++)
        {
            Match match = labelMatches[i];

            if (!match.Success) continue;

            string label = match.Groups["label"].Value.Trim();
            int value = int.Parse(match.Groups["value"].Value.Trim());

            switch (label)
            {
                case "Strength":
                    stats.strenght = value;
                    any = true;
                    break;
                case "Health":
                    stats.health = value;
                    any = true;
                    break;
                case "Agility":
                    stats.agility = value;
                    any = true;
                    break;
                case "StatPoints":
                    stats.statsPoints = value;
                    any = true;
                    break;
                case "Accuracy":
                    stats.accuracy = value;
                    any = true;
                    break;
                case "Dodging":
                    stats.dodging = value;
                    any = true;
                    break;
                case "Strike Damage":
                    stats.strikeDamage = value;
                    any = true;
                    break;
                case "Damage Absorb":
                    stats.damageAbsobtion = value;
                    any = true;
                    break;
            }
        }

        return any;
    }
}

public static class LocationParser
{
    private static readonly Regex roomHeaderRegex =
        new Regex(@"^(?<region>[^:]+):\s*(?<room>.+)$", RegexOptions.Compiled);

    private static readonly Regex regionTagRegex =
        new Regex(@"\[Region\]\s*(.+)", RegexOptions.Compiled);

    private static readonly HashSet<string> ValidRegions =
        new HashSet<string>
        {
            "Initial Core",
            "Static Urban Mesh",
            "Processing Sub-layers",
            "Procedural Forest Sector",
            "Data Sea",
            "Abyssal Core"
        };

    private static readonly Dictionary<string, HashSet<string>> ValidRoomsByRegion =
        new Dictionary<string, HashSet<string>>
        {
            { "Initial Core", new HashSet<string> { "Boot Terminal", "Sync Corridor" } },
            { "Static Urban Mesh", new HashSet<string> { "Fragmented Square" } },
        };

    public static bool TryParseRoomHeader(string text, out string region, out string room)
    {
        region = null;
        room = null;

        var trimmed = text.TrimStart();

        if (trimmed.StartsWith("["))
            return false;

        var match = roomHeaderRegex.Match(text);
        if (!match.Success)
            return false;

        var regionName = match.Groups["region"].Value.Trim();
        var roomName = match.Groups["room"].Value.Trim();

        if (!ValidRegions.Contains(regionName))
            return false;

        if (ValidRoomsByRegion.TryGetValue(regionName, out var validRooms) &&
            !validRooms.Contains(roomName))
        {
            return false;
        }

        region = regionName;
        room = roomName;
        return true;
    }

    public static bool TryParseRegionTag(string text, out string region)
    {
        region = null;

        var match = regionTagRegex.Match(text);
        if (!match.Success)
            return false;

        var regionName = match.Groups[1].Value.Trim();

        if (!ValidRegions.Contains(regionName))
            return false;

        region = regionName;
        return true;
    }
}

public static class StatusParser
{
    private static readonly Regex statusRegex =
        new Regex(@"\[Status\]\s*(?<label>.+?):\s*(?<value>.+)$",
                  RegexOptions.Compiled);

    private static readonly HashSet<string> ValidLabels =
        new HashSet<string> { "System integrity" };

    private static readonly HashSet<string> ValidValues =
        new HashSet<string>
        {
            "STABLE",
            "LIGHT DISTORTION",
            "HEAVY CORRUPTION",
            "ABYSSAL DECAY"
        };

    public static bool TryParse(string text, out string label, out string value)
    {
        label = null;
        value = null;

        var match = statusRegex.Match(text);
        if (!match.Success)
            return false;

        var lbl = match.Groups["label"].Value.Trim();
        var val = match.Groups["value"].Value.Trim();

        if (!ValidLabels.Contains(lbl))
            return false;

        if (!ValidValues.Contains(val))
            return false;

        label = lbl;
        value = val;
        return true;
    }
}

[System.Serializable]
public class Message
{
    public string text;
    public TextMeshProUGUI textObject;
    public MessageType messageType;

    public enum MessageType
    {
        playerMessage,
        info
    }
}
