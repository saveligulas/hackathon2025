using Godot.Collections;

namespace hackathon_2025.core;
using System.Collections.Generic;

[GlobalClass]
public partial class Symbol : Resource
{
	[Export] public SymbolType Type { get; set; }
	[Export] public Array<SpinModifier> Modifiers { get; set; } = new();
	[Export] public int Points { get; set; } = 1;
	[Export] public int Mult { get; set; } = 1;
	[Export] public string Description { get; set; } = "Placeholder";
}
