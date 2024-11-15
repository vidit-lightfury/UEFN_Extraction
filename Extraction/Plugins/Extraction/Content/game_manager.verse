
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Verse.org/Random }
using { /Fortnite.com/Teams }
using { /Fortnite.com/Playspaces }
using { /UnrealEngine.com/Temporary/Diagnostics }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

# A Verse-authored creative device that can be placed in a level
game_manager := class(creative_device):

    
    @editable
    ExtractionButton:button_device = button_device{}

    @editable
    ExtractItemSpawner:item_spawner_device = item_spawner_device{}

    @editable
    ExtractItemChecker: conditional_button_device = conditional_button_device{}

    @editable
    Boat : vehicle_spawner_boat_device = vehicle_spawner_boat_device{}

    @editable
    EndGameDevice : end_game_device = end_game_device{}

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        ExtractionButton.InteractedWithEvent.Subscribe(OnExtractionComplete)
        Boat.AgentEntersVehicleEvent.Subscribe(OnPlayerEnterVehicle)

        Players := GetPlayspace().GetPlayers()
        if(Player := Players[3]):
            AssignToTeamByIndex(Player, 1)
        else:
            Print("No index found")



    
    AssignToTeamByIndex(Agent: agent, Index:int):void=
        TeamCollection := Self.GetPlayspace().GetTeamCollection()
        Teams := TeamCollection.GetTeams()
        if :
            Team := Teams[Index]
            TeamCollection.AddToTeam[Agent, Team]
        then:
            Print("Team assigned {Index}")
        else:
            Print("Could not assign team")    


    OnPlayerEnterVehicle(Agent:agent):void=
        if(ExtractItem:=ExtractItemChecker.HasAllItems[Agent]):
            spawn:
                EndGame(Agent)

    EndGame(Agent:agent)<suspends>:void=
        Sleep(2.0)
        EndGameDevice.Activate(Agent)

    OnExtractionComplete(Agent:agent):void=
        Print("spawner Complete")
        ExtractItemSpawner.SpawnItem()
