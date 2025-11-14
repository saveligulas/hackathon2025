using System.Collections.Generic;
using Godot.Collections;

namespace hackathon_2025.core;

[GlobalClass]
public partial class Reel : Resource
{
	[Export] public Array<Symbol> Symbols { get; set; } = new();
}
