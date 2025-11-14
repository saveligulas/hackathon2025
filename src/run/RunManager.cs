using Godot.Collections;
using hackathon_2025.core;

namespace hackathon_2025.run;

public partial class RunManager : Node, Initializable
{
	[Export] public Array<Symbol> StartingSymbols { get; set; }
	[Export] public PlayerData PlayerData { get; set; }
	private SlotMachineManager _slotMachineManager;
	public void Initialize()
	{
		_slotMachineManager = new SlotMachineManager();
		if (StartingSymbols.Count < 1)
		{
			throw new ApplicationException("No starting symbols found");
		}
		if (PlayerData == null)
		{
			PlayerData = new PlayerData();
			PlayerData.Initialize();
			foreach (Reel reel in PlayerData.Reels)
			{
				reel.Symbols.Add(StartingSymbols.PickRandom().Duplicate() as Symbol);
			}
		}
	}

	public void Reset()
	{
		//TODO
	}

	public override void _Ready()
	{
		GD.Print("I LOADED RUNMANAGER");
	}
}
