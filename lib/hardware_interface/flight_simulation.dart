import 'dart:async';
import 'dart:math';
import 'package:matrices/matrices.dart';
import 'package:latlong2/latlong.dart';

import 'base_hardware_interface.dart';

import '../constants.dart';

class STATES {
  static const preFlight = 0;
  static const boost = 1;
  static const coast = 2;
  static const drogueChute = 3;
  static const mainChute = 4;
  static const landed = 5;
}

Matrix rotationMatrix(double theta) {
  return Matrix.fromList([
    [cos(theta), -sin(theta)],
    [sin(theta), cos(theta)]
  ]);
}

Matrix vector(double x, double y) {
  return Matrix.fromList([
    [x],
    [y]
  ]);
}

double vectorNorm(Matrix mat) {
  return sqrt(pow(mat[0][0], 2) + pow(mat[1][0], 2));
}

Matrix unitVector(Matrix mat) {
  var vectorLength = vectorNorm(mat);
  if (vectorLength == 0) {
    return mat;
  }
  return mat * (1 / vectorLength);
}

double degreesToRadians(double degrees) {
  return degrees / (180 / pi);
}

///Runs a simplified rocket sim to generate fake data
class FlightSimulation extends BaseHardwareInterface {
  var position = Matrix.zero(2, 1);
  var velocity = Matrix.zero(2, 1);
  var acceleration = Matrix.zero(2, 1);
  var theta = 0.0;

  var state = STATES.preFlight;
  var lastRunTime = 0.0;
  var stateStartTime = 0.0;

  //Physics values
  var rocketMass = 10.0; //Kg
  var liftoffTwr = 8.0; //G
  var G = 9.8; //m/s^2
  var burnTime = 2; // s
  var startingTheta = degreesToRadians(85); //5 degree pitch at launch
  var flightHeading = 45;
  var startPos = const LatLng(42.3601, -71.0589);

  FlightSimulation() {
    setState(STATES.preFlight);
  }

  void setState(int newState) {
    state = newState;
    stateStartTime = DateTime.now().millisecondsSinceEpoch / 1000;
  }

  @override
  void runWhileEnabled() {
    // Physics values that get set in the state machine
    var thrustForce = 0.0; //In vehicle's frame of referenece, in N
    var parachuteArea = 0.0;
    var parachuteCd = 1;
    var enablePhysics = true;

    var airDensity = 1.229; //kg/m^3 TODO: Change this as a function of altitude

    //Timing values
    var currentTime = DateTime.now().millisecondsSinceEpoch / 1000;
    var timeInState = currentTime - stateStartTime;
    var deltaTime = currentTime - lastRunTime;
    lastRunTime = currentTime;

    //State machine (sets forces on the rocket)
    if (state == STATES.preFlight) {
      theta = startingTheta;
      position = Matrix.zero(2, 1);
      velocity = Matrix.zero(2, 1);
      acceleration = Matrix.zero(2, 1);
      enablePhysics = false;

      if (timeInState > 5) {
        print("Launching rocket");
        setState(STATES.boost);
      }
    } else if (state == STATES.boost) {
      var thrustScale = 1 - (timeInState / burnTime) * 0.8;

      thrustForce = rocketMass * liftoffTwr * G * thrustScale;

      if (timeInState > burnTime) {
        setState(STATES.coast);
      }
    } else if (state == STATES.coast) {
      if (velocity[1][0] < 0) {
        print("Apogee");
        setState(STATES.drogueChute);
      }
    } else if (state == STATES.drogueChute) {
      parachuteArea = 0.2; //m^2
      if (position[1][0] < 100) {
        print("Main chute");
        setState(STATES.mainChute);
      }
    } else if (state == STATES.mainChute) {
      parachuteArea = 2; //m^2

      if (position[1][0] < 0) {
        //Altitude check
        setState(STATES.landed);
      }
    } else if (state == STATES.landed) {
      position = Matrix.zero(2, 1);
      velocity = Matrix.zero(2, 1);
      acceleration = Matrix.zero(2, 1);
      enablePhysics = false;

      if (timeInState > 5) {
        setState(STATES.preFlight);
      }
    } else {
      print("Invalid state");
      state = STATES.preFlight;
    }

    //"Actual" physics sim ----------------------------------------------------------------------------------
    if (enablePhysics) {
      //Some helper numbers
      var velocityMagnitude = vectorNorm(velocity);

      //Calculate component forces
      var thrustVector = rotationMatrix(theta) * vector(thrustForce, 0);
      var gravityVector = vector(0, -rocketMass * G);
      var parachuteForceMagnitude = parachuteCd * airDensity * pow(velocityMagnitude, 2) * parachuteArea / 2;
      var parachuteVector = unitVector(velocity) * -1 * parachuteForceMagnitude;
      //TODO: Calculate drag

      //Sum them to get the total force
      var totalForce = thrustVector + gravityVector + parachuteVector;

      //Convert that to acceleration
      acceleration = totalForce * (1 / rocketMass);

      //Integrate
      velocity = velocity + acceleration * deltaTime;
      position = position + velocity * deltaTime;

      //Make the rocket always point into the airflow
      theta = atan2(velocity[1][0], velocity[0][0]);
    }

    //Generate FCB data based on simulation ----------------------------------------------------------
    var altitude = position[1][0];
    var downrange = position[0][0];
    var verticalSpeed = velocity[1][0];

    var distance = const Distance();
    var coords = distance.offset(startPos, downrange, flightHeading);

    //Make sim packet
    var packet = <String, dynamic>{};
    packet[Constants.altitude] = altitude;
    packet[Constants.verticalSpeed] = verticalSpeed;
    packet[Constants.latitude] = coords.latitude;
    packet[Constants.longitude] = coords.longitude;
    packet[Constants.groundStationLatitude] = startPos.latitude;
    packet[Constants.groundStationLongitude] = startPos.longitude;
    packet[Constants.accelerometerX] = vectorNorm(acceleration) - G;
    packet[Constants.accelerometerY] = Random().nextDouble();
    packet[Constants.accelerometerZ] = Random().nextDouble();
    database.bulkUpdateDatabase(packet);
  }
}
