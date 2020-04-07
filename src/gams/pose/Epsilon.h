/**
 * Copyright (c) 2019 Carnegie Mellon University. All Rights Reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following acknowledgments and disclaimers.
 * 
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 
 * 3. The names "Carnegie Mellon University," "SEI" and/or "Software
 *    Engineering Institute" shall not be used to endorse or promote products
 *    derived from this software without prior written permission. For written
 *    permission, please contact permission@sei.cmu.edu.
 * 
 * 4. Products derived from this software may not be called "SEI" nor may "SEI"
 *    appear in their names without prior written permission of
 *    permission@sei.cmu.edu.
 * 
 * 5. Redistributions of any form whatsoever must retain the following
 *    acknowledgment:
 * 
 *      This material is based upon work funded and supported by the Department
 *      of Defense under Contract No. FA8721-05-C-0003 with Carnegie Mellon
 *      University for the operation of the Software Engineering Institute, a
 *      federally funded research and development center. Any opinions,
 *      findings and conclusions or recommendations expressed in this material
 *      are those of the author (s) and do not necessarily reflect the views of
 *      the United States Department of Defense.
 * 
 *      NO WARRANTY. THIS CARNEGIE MELLON UNIVERSITY AND SOFTWARE ENGINEERING
 *      INSTITUTE MATERIAL IS FURNISHED ON AN "AS-IS" BASIS. CARNEGIE MELLON
 *      UNIVERSITY MAKES NO WARRANTIES OF ANY KIND, EITHER EXPRESSED OR
 *      IMPLIED, AS TO ANY MATTER INCLUDING, BUT NOT LIMITED TO, WARRANTY OF
 *      FITNESS FOR PURPOSE OR MERCHANTABILITY, EXCLUSIVITY, OR RESULTS
 *      OBTAINED FROM USE OF THE MATERIAL. CARNEGIE MELLON UNIVERSITY DOES
 *      NOT MAKE ANY WARRANTY OF ANY KIND WITH RESPECT TO FREEDOM FROM PATENT,
 *      TRADEMARK, OR COPYRIGHT INFRINGEMENT.
 * 
 *      This material has been approved for public release and unlimited
 *      distribution.
 **/

/**
 * @file Epsilon.h
 * @author James Edmondson <jedmondson@gmail.com>
 *
 * This file contains the PoseBounds, Epsilon, PositionBounds, and
 * OrientationBounds classes
 **/

#ifndef _GAMS_POSE_EPSILON_H_
#define _GAMS_POSE_EPSILON_H_

#include <iostream>
#include <string>

#include "gams/GamsExport.h"
#include "gams/pose/Position.h"
#include "gams/pose/Orientation.h"

namespace gams { namespace pose {

/// Interface for defining a bounds checker for Positions
class GAMS_EXPORT PositionBounds {
public:
/// Override to return whether the current position
/// is within the expected bounds of target
virtual bool check_position(
    const pose::Position &current,
    const pose::Position &target) const = 0;

virtual ~PositionBounds() = default;
};

/// Interface for defining a bounds checker for Orientations
class GAMS_EXPORT OrientationBounds {
public:
/// Override to return whether the current orientation
/// is within the expected bounds of target
virtual bool check_orientation(
    const pose::Orientation &current,
    const pose::Orientation &target) const = 0;

virtual ~OrientationBounds() = default;
};

/// Interface for defining a bounds checker for Poses,
/// a combination of position and orientation checking.
class GAMS_EXPORT PoseBounds :
public PositionBounds, public OrientationBounds {};

/// A simple bounds checker which tests whether the
/// current position is within the given number of
/// meters of the expected position, and whether the
/// difference in angles is within the given number
/// of radians.
class GAMS_EXPORT Epsilon : public PoseBounds {
private:
double dist_ = 0.1, radians_ = M_PI/16;
public:
/// Use default values for position and angle tolerance.
Epsilon() {}

/// Use default value for angle tolerance.
///
/// @param dist the position tolerance (in meters)
Epsilon(double dist)
: dist_(dist) {}

/// Use specified tolerances
///
/// @param dist_tol the position tolerance (in meters)
/// @param radians_tol the angle tolerance (in radians)
Epsilon(double dist_tol, double radians_tol)
: dist_(dist_tol), radians_(radians_tol) {}

/// Use specified tolerances, with custom angle units
///
/// @param dist the position tolerance (in meters)
/// @param angle the angle tolerance (in units given)
/// @param u an angle units object (such as pose::radians,
///      pose::degrees, or pose::revolutions)
//
/// @tparam AngleUnits the units type for angle (inferred from u)
template<typename AngleUnits>
Epsilon(double dist, double angle, AngleUnits u)
: dist_(dist), radians_(u.to_radians(angle)) {}

bool check_position(
    const pose::Position &current,
    const pose::Position &target) const override {
return current.distance_to(target) <= dist_;
}

bool check_orientation(
    const pose::Orientation &current,
    const pose::Orientation &target) const override {
return fabs(current.angle_to(target)) <= radians_;
}
};

} }

#endif // _GAMS_POSE_EPSILON_H_