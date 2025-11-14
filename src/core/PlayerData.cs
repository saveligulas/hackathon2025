namespace hackathon_2025.core;

public partial class PlayerData : Resource, Initializable
{
    [Export] public Reel[] Reels { get; set; } = new Reel[5];

    public void Initialize()
    {
        for (int i = 0; i < Reels.Length; i++)
        {
            Reels[i] = new Reel();
        }
    }
}