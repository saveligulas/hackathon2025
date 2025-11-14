using hackathon_2025.core;

namespace hackathon_2025.run;

public partial class SlotMachineManager : Node
{
    public Symbol[,] ResultGrid = new Symbol[5, 3];
    public void Spin(PlayerData playerData)
    {
        for (int column = 0; column < 5; column++)
        {
            for (int row = 0; row < 3; row++)
            {
                ResultGrid[column, row] = playerData.Reels[column].Symbols.PickRandom(); //TODO: fix duplicates
            }
        }
    }
}