/* =============================================================================
:: Copyright © 2006 Roman Dzieciol
============================================================================= */
class swMeshBrowser extends BrushBuilder config(swMeshBrowser);


enum EAction
{
	ReadAll,
	WriteAll,
	WriteMesh,
	WriteLOD,
	WriteCollision,
	WriteSockets,
	WriteImpostor,
	WriteMaterial,
	Edit
};

var() EAction Action;


var(Edit) config vector									Scale;
var(Edit) config vector          						Translation;
var(Edit) config rotator         						Rotation;
var(Edit) config vector          						MinVisBound;
var(Edit) config vector			 						MaxVisBound;
var(Edit) config vector           						VisSphereCenter;
var(Edit) config float            						VisSphereRadius;
var(Edit) config int           							LODStyle; 			//Make drop-down box w. styles...
var(Edit) config MeshAnimation							DefaultAnimation;
var(Edit) config array<Material>						Material;
var(Edit) config float									LOD_Strength;
var(Edit) config array<MeshEditProps.LODLevel>			LODLevels;
var(Edit) config float									SkinTesselationFactor;
var(Edit) config float									TestCollisionRadius;	// Radius of collision cyllinder.
var(Edit) config float									TestCollisionHeight;	// Half-height cyllinder.
var(Edit) config array<MeshEditProps.MEPBonePrimSphere>	CollisionSpheres;		// Array of spheres linked to bones
var(Edit) config array<MeshEditProps.MEPBonePrimBox>	CollisionBoxes;			// Array of boxes linked to bones
var(Edit) config StaticMesh								CollisionStaticMesh;	// Optional static mesh used for traces.
var(Edit) config array<MeshEditProps.AttachSocket>		Sockets;  			// Sockets, with or without adjustment coordinates / bone aliases.
var(Edit) config bool									ApplyNewSockets;	// Explicit switch to apply changes
var(Edit) config bool									ContinuousUpdate;	// Continuous updating (to adjust socket angles interactively)
var(Edit) config bool									bImpostorPresent;
var(Edit) config Material								SpriteMaterial;
var(Edit) config vector									Scale3D;
var(Edit) config rotator								RelativeRotation;
var(Edit) config vector									RelativeLocation;
var(Edit) config color									ImpColor;           // Impostor base coloration.
var(Edit) config MeshEditProps.EImpSpaceMode			ImpSpaceMode;
var(Edit) config MeshEditProps.EImpDrawMode				ImpDrawMode;
var(Edit) config MeshEditProps.EImpLightMode			ImpLightMode;

var LevelInfo	MyLevel;

event bool Build()
{
	local MeshEditProps	Props;
	local LevelInfo			A;

	foreach AllObjects(class'LevelInfo', A)
	{
		MyLevel = A;
	}

	foreach AllObjects(class'MeshEditProps', Props)
	{
		switch( Action )
		{
		case ReadAll:			ReadAll( Props, self );			break;
		case WriteAll:			WriteAll( self, Props);			break;
		case WriteMesh:			WriteMesh( self, Props);		break;
		case WriteLOD:			WriteLOD( self, Props);			break;
		case WriteCollision:	WriteCollision( self, Props);	break;
		case WriteSockets:		WriteSockets( self, Props);		break;
		case WriteImpostor:		WriteImpostor( self, Props);	break;
		case WriteMaterial:		WriteMaterial( self, Props);	break;
		case Edit:				MyLevel.ConsoleCommand("editobj"@self);					break;
		}
	}

	MyLevel = None;
	return true;
}


function ReadAll( MeshEditProps Source, swMeshBrowser Target )
{
	Target.Scale					= Source.Scale;
	Target.Translation				= Source.Translation;
	Target.Rotation					= Source.Rotation;
	Target.MinVisBound				= Source.MinVisBound;
	Target.MaxVisBound				= Source.MaxVisBound;
	Target.VisSphereCenter			= Source.VisSphereCenter;
	Target.VisSphereRadius			= Source.VisSphereRadius;
	Target.LODStyle					= Source.LODStyle;
	Target.DefaultAnimation			= Source.DefaultAnimation;
	Target.Material					= Source.Material;
	Target.LOD_Strength				= Source.LOD_Strength;
	Target.LODLevels				= Source.LODLevels;
	Target.SkinTesselationFactor	= Source.SkinTesselationFactor;
	Target.TestCollisionRadius		= Source.TestCollisionRadius;
	Target.TestCollisionHeight		= Source.TestCollisionHeight;
	Target.CollisionSpheres			= Source.CollisionSpheres;
	Target.CollisionBoxes			= Source.CollisionBoxes;
	Target.CollisionStaticMesh		= Source.CollisionStaticMesh;
	Target.Sockets					= Source.Sockets;
	Target.ApplyNewSockets			= Source.ApplyNewSockets;
	Target.ContinuousUpdate			= Source.ContinuousUpdate;
	Target.bImpostorPresent			= Source.bImpostorPresent;
	Target.SpriteMaterial			= Source.SpriteMaterial;
	Target.Scale3D					= Source.Scale3D;
	Target.RelativeRotation			= Source.RelativeRotation;
	Target.RelativeLocation			= Source.RelativeLocation;
	Target.ImpColor					= Source.ImpColor;
	Target.ImpSpaceMode				= Source.ImpSpaceMode;
	Target.ImpDrawMode				= Source.ImpDrawMode;
	Target.ImpLightMode				= Source.ImpLightMode;
	SaveConfig();


	MyLevel.CopyObjectToClipboard(Source);
}

function WriteAll( swMeshBrowser Source, MeshEditProps Target  )
{
//	Target.DefaultAnimation			= Source.DefaultAnimation;
	WriteMesh(Source, Target);
	WriteLOD(Source, Target);
	WriteCollision(Source, Target);
	WriteSockets(Source, Target);
	WriteImpostor(Source, Target);
	WriteMaterial(Source, Target);
}

function WriteMesh( swMeshBrowser Source, MeshEditProps Target  )
{
	Target.Scale					= Source.Scale;
	Target.Translation				= Source.Translation;
	Target.Rotation					= Source.Rotation;
	Target.MinVisBound				= Source.MinVisBound;
	Target.MaxVisBound				= Source.MaxVisBound;
	Target.VisSphereCenter			= Source.VisSphereCenter;
	Target.VisSphereRadius			= Source.VisSphereRadius;
}

function WriteLOD( swMeshBrowser Source, MeshEditProps Target  )
{
	Target.LODStyle					= Source.LODStyle;
	Target.LOD_Strength				= Source.LOD_Strength;
	Target.LODLevels				= Source.LODLevels;
	Target.SkinTesselationFactor	= Source.SkinTesselationFactor;
}

function WriteCollision( swMeshBrowser Source, MeshEditProps Target  )
{
	Target.TestCollisionRadius		= Source.TestCollisionRadius;
	Target.TestCollisionHeight		= Source.TestCollisionHeight;
	Target.CollisionSpheres			= Source.CollisionSpheres;
	Target.CollisionBoxes			= Source.CollisionBoxes;
	Target.CollisionStaticMesh		= Source.CollisionStaticMesh;
}

function WriteSockets( swMeshBrowser Source, MeshEditProps Target  )
{
	Target.Sockets					= Source.Sockets;
	Target.ApplyNewSockets			= Source.ApplyNewSockets;
	Target.ContinuousUpdate			= Source.ContinuousUpdate;
}

function WriteImpostor( swMeshBrowser Source, MeshEditProps Target  )
{
	Target.bImpostorPresent			= Source.bImpostorPresent;
	Target.SpriteMaterial			= Source.SpriteMaterial;
	Target.Scale3D					= Source.Scale3D;
	Target.RelativeRotation			= Source.RelativeRotation;
	Target.RelativeLocation			= Source.RelativeLocation;
	Target.ImpColor					= Source.ImpColor;
	Target.ImpSpaceMode				= Source.ImpSpaceMode;
	Target.ImpDrawMode				= Source.ImpDrawMode;
	Target.ImpLightMode				= Source.ImpLightMode;
}

function WriteMaterial( swMeshBrowser Source, MeshEditProps Target  )
{
	Target.Material					= Source.Material;
}

defaultproperties
{
     BitmapFilename="swMeshBrowser"
     ToolTip="Mesh Browser"
}
