import 'package:flutter/material.dart';
import 'package:map4d_map/map4d_map.dart';

import 'page.dart';

class PlaceBuildingPage extends Map4dMapExampleAppPage {
  PlaceBuildingPage()
      : super(const Icon(Icons.home_outlined), 'Place Building');

  @override
  Widget build(BuildContext context) {
    return const PlaceBuildingBody();
  }
}

class PlaceBuildingBody extends StatefulWidget {
  const PlaceBuildingBody();

  @override
  State<StatefulWidget> createState() => PlaceBuildingBodyState();
}

class PlaceBuildingBodyState extends State<PlaceBuildingBody> {
  PlaceBuildingBodyState();

  static final MFLatLng _kInitPosition =
      MFLatLng(12.205748339991535, 109.21646118164062);
  static final MFLatLng _kInitExtrudeBuildingPosition =
      MFLatLng(12.204364143802083, 109.21652555465698);
  static final MFLatLng _kInitTextureBuildingPosition =
      MFLatLng(12.206755023585973, 109.21641826629639);

  late MFMapViewController controller;
  Map<MFBuildingId, MFBuilding> buildings = <MFBuildingId, MFBuilding>{};
  int _buildingIdCounter = 1;
  MFBuildingId? selectedBuilding;
  MFBuildingId? _extrudeBuildingId;
  MFBuildingId? _textureBuildingId;

  void _onMapCreated(MFMapViewController controller) {
    this.controller = controller;
    this.controller.enable3DMode(true);
  }

  void _onBuildingTapped(MFBuildingId id) {
    print('Selected building: $id');
    setState(() {
      selectedBuilding = id;
    });
  }

  void _remove(MFBuildingId id) {
    setState(() {
      if (buildings.containsKey(id)) {
        buildings.remove(id);
      }
      if (id == _extrudeBuildingId) {
        _extrudeBuildingId = null;
      } else if (id == _textureBuildingId) {
        _textureBuildingId = null;
      }
      if (id == selectedBuilding) {
        selectedBuilding = null;
      }
    });
  }

  void _addExtrudeBuilding() {
    final String buildingIdVal = 'building_id_$_buildingIdCounter';
    _buildingIdCounter++;

    final List<MFLatLng> coordinates = <MFLatLng>[
      MFLatLng(12.204259280159668, 109.21635255217552),
      MFLatLng(12.204259280159668, 109.2167267203331),
      MFLatLng(12.20450177726977, 109.2167267203331),
      MFLatLng(12.20450177726977, 109.21635255217552),
      MFLatLng(12.204259280159668, 109.21635255217552)
    ];
    final MFBuildingId buildingId = MFBuildingId(buildingIdVal);
    final MFBuilding building = MFBuilding(
      buildingId: buildingId,
      consumeTapEvents: true,
      position: _kInitExtrudeBuildingPosition,
      name: 'Extrude Building',
      coordinates: coordinates,
      height: 100,
      onTap: () {
        _onBuildingTapped(buildingId);
      },
    );

    _extrudeBuildingId = buildingId;
    setState(() {
      buildings[buildingId] = building;
    });
  }

  void _addTextureBuilding() {
    final String buildingIdVal = 'building_id_$_buildingIdCounter';
    _buildingIdCounter++;
    final MFBuildingId buildingId = MFBuildingId(buildingIdVal);

    final MFBuilding building = MFBuilding(
      buildingId: buildingId,
      consumeTapEvents: true,
      position: _kInitTextureBuildingPosition,
      name: 'Texture Building',
      modelUrl:
          'https://sw-hcm-1.vinadata.vn/v1/AUTH_d0ecabcbdcd74f6aa6ac9a5da528eb78/sdk/models/5b21d9a5cd18d02d045a5e99',
      textureUrl:
          'https://sw-hcm-1.vinadata.vn/v1/AUTH_d0ecabcbdcd74f6aa6ac9a5da528eb78/sdk/textures/0cb35e1610c34e55946a7839356d8f66.jpg',
      onTap: () {
        _onBuildingTapped(buildingId);
      },
    );

    _textureBuildingId = buildingId;
    setState(() {
      buildings[buildingId] = building;
    });
  }

  void _toggleVisible(MFBuildingId buildingId) {
    final MFBuilding building = buildings[buildingId]!;
    setState(() {
      buildings[buildingId] = building.copyWith(
        visibleParam: !building.visible,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final MFBuildingId? selectedId = selectedBuilding;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
          child: SizedBox(
            width: 350.0,
            height: 500.0,
            child: MFMapView(
              initialCameraPosition: MFCameraPosition(target: _kInitPosition),
              buildings: Set<MFBuilding>.of(buildings.values),
              onMapCreated: _onMapCreated,
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        TextButton(
                          child: const Text('Add Texture Building'),
                          onPressed: (_textureBuildingId != null)
                              ? null
                              : () => _addTextureBuilding(),
                        ),
                        TextButton(
                          child: const Text('Remove'),
                          onPressed: (selectedId == null)
                              ? null
                              : () => _remove(selectedId),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        TextButton(
                          child: const Text('Add Extrude Building'),
                          onPressed: (_extrudeBuildingId != null)
                              ? null
                              : () => _addExtrudeBuilding(),
                        ),
                        TextButton(
                          child: const Text('Toggle Visible'),
                          onPressed: (selectedId == null)
                              ? null
                              : () => _toggleVisible(selectedId),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
