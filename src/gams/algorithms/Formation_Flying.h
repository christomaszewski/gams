/**
 * Copyright (c) 2014 Carnegie Mellon University. All Rights Reserved.
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
 *      are those of the author(s) and do not necessarily reflect the views of
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
 * @file Formation_Flying.h
 * @author Anton Dukeman <anton.dukeman@gmail.com>
 *
 * Declaration of Formation_Flying class
 **/

#ifndef   _GAMS_ALGORITHMS_FORMATION_FLYING_H_
#define   _GAMS_ALGORITHMS_FORMATION_FLYING_H_

#include "gams/variables/Sensor.h"
#include "gams/platforms/Base_Platform.h"
#include "gams/variables/Algorithm_Status.h"
#include "gams/variables/Self.h"
#include "gams/algorithms/Base_Algorithm.h"
#include "gams/utility/GPS_Position.h"
#include "gams/algorithms/Algorithm_Factory.h"

namespace gams
{
  namespace algorithms
  {
    /**
    * An algorithm for moving in formation
    **/
    class GAMS_Export Formation_Flying : public Base_Algorithm
    {
    public:
      /**
       * Constructor
       * @param  head_id       target of the formation
       * @param  offset       offset of formation
       * @param  destination  destination of the formation
       * @param  members      number of members
       * @param  modifier     modifier that influences the formation
       * @param  knowledge    the context containing variables and values
       * @param  platform     the underlying platform the algorithm will use
       * @param  sensors      map of sensor names to sensor information
       * @param  self         self-referencing variables
       **/
      Formation_Flying (
        const Madara::Knowledge_Record & head_id,
        const Madara::Knowledge_Record & offset,
        const Madara::Knowledge_Record & destination,
        const Madara::Knowledge_Record & members,
        const Madara::Knowledge_Record & modifier,
        Madara::Knowledge_Engine::Knowledge_Base * knowledge = 0,
        platforms::Base_Platform * platform = 0,
        variables::Sensors * sensors = 0,
        variables::Self * self = 0);

      /**
       * Destructor
       **/
      ~Formation_Flying ();

      /**
       * Assignment operator
       * @param  rhs   values to copy
       **/
      void operator= (const Formation_Flying & rhs);
      
      /**
       * Analyzes environment, platform, or other information
       * @return bitmask status of the platform. @see Status.
       **/
      virtual int analyze (void);
      
      /**
       * Plans the next execution of the algorithm
       * @return bitmask status of the platform. @see Status.
       **/
      virtual int execute (void);

      /**
       * Plans the next execution of the algorithm
       * @return bitmask status of the platform. @see Status.
       **/
      virtual int plan (void);

      /**
       * Return true if this agent is head
       */
      bool is_head () const;

      /**
       * Get ready value
       * @return true if agents are in formation, false otherwise
       */
      bool is_ready () const;
      
    protected:
      /**
       * Get head's destination
       * @return utility::Position object of head's destination
       */
      utility::GPS_Position get_destination();

      /// formation wait string
      struct compiled
      {
        Madara::Knowledge_Engine::Compiled_Expression ref;
        size_t agent;
      };
      std::vector<compiled> compiled_formation_;

      /// are we in formation?
      Madara::Knowledge_Engine::Containers::Integer formation_ready_;

      /// am i the head?
      bool head_;

      /// head id
      int head_id_;

      /// head location
      Madara::Knowledge_Engine::Containers::Native_Double_Array head_location_;

      /// head destination
      Madara::Knowledge_Engine::Containers::Native_Double_Array head_destination_;

      /// destination as GPS_Position
      utility::GPS_Position destination_;

      /// am i in formation?
      Madara::Knowledge_Engine::Containers::Integer in_formation_;

      /// modifier enum
      enum
      {
        NONE,
        ROTATE
      } modifier_;

      /// do we need to move?
      bool need_to_move_;

      /// next position
      utility::GPS_Position next_position_;

      /// number of agents in formation; only head_id_ needs to know this
      unsigned int num_agents_;

      /// angular formation offsets
      double phi_;

      /// directional angular formation offsets
      double phi_dir_;

      /// planar distance formation offsets
      double rho_;

      /// list of sensor names
      variables::Sensor_Names sensor_names_;

      /// altitude formation offsets
      double z_;
    };
    
    /**
     * A factory class for creating Formation Flying algorithms
     **/
    class GAMS_Export Formation_Flying_Factory : public Algorithm_Factory
    {
    public:

      /**
       * Creates a Formation Flying Algorithm.
       * @param   args      args[0] = the target of the formation
       *                    args[1] = the cylindrical offset from the target
       *                    args[2] = the destination of the movement
       *                    args[3] = the number of members in the formation
       *                    args[4] = a modifier on the formation
       *                              (NONE or ROTATE)
       * @param   knowledge the knowledge base to use
       * @param   platform  the platform. This will be set by the
       *                    controller in init_vars.
       * @param   sensors   the sensor info. This will be set by the
       *                    controller in init_vars.
       * @param   self      self-referencing variables. This will be
       *                    set by the controller in init_vars
       * @param   devices   the list of devices, which is dictated by
       *                    init_vars when a number of processes is set. This
       *                    will be set by the controller in init_vars
       **/
      virtual Base_Algorithm * create (
        const Madara::Knowledge_Vector & args,
        Madara::Knowledge_Engine::Knowledge_Base * knowledge,
        platforms::Base_Platform * platform,
        variables::Sensors * sensors,
        variables::Self * self,
        variables::Devices * devices);
    };
  }
}

#endif // _GAMS_ALGORITHMS_FORMATION_FLYING_H_
