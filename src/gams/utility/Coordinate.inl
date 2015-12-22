/**
 * Copyright (c) 2015 Carnegie Mellon University. All Rights Reserved.
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
 * @file Coordinates.h
 * @author James Edmondson <jedmondson@gmail.com>
 *
 * This file contains the Location, Rotation, and Pose classes
 **/

#ifndef _GAMS_UTILITY_COORDINATE_INL_
#define _GAMS_UTILITY_COORDINATE_INL_

#include <iostream>
#include <cstdio>
#include <sstream>

#include "Coordinate.h"

namespace gams
{
  namespace utility
  {
    inline const ReferenceFrame &CoordinateBase::default_frame()
    {
      return *default_frame_;
    }

    template<typename CoordType>
    inline Coordinate<CoordType>::Coordinate()
      : frame_(&default_frame()) {}

    template<typename CoordType>
    inline constexpr Coordinate<CoordType>::Coordinate(
                            const ReferenceFrame &frame)
      : frame_(&frame) {}

    template<typename CoordType>
    inline constexpr Coordinate<CoordType>::Coordinate(
                            const ReferenceFrame *frame)
      : frame_(frame) {}

    template<typename CoordType>
    inline CoordType &Coordinate<CoordType>::as_coord_type()
    {
      return static_cast<CoordType &>(*this);
    }

    template<typename CoordType>
    inline constexpr const CoordType &
            Coordinate<CoordType>::as_coord_type() const
    {
      return static_cast<const CoordType &>(*this);
    }

    template<typename CoordType>
    template<typename Type>
    inline Type &Coordinate<CoordType>::as_type()
    {
        return static_cast<Type &>(as_coord_type());
    }

    template<typename CoordType>
    template<typename Type>
    inline constexpr const Type &Coordinate<CoordType>::as_type() const
    {
        return static_cast<const Type &>(as_coord_type());
    }

    template<typename CoordType>
    inline constexpr const ReferenceFrame &Coordinate<CoordType>::frame() const
    {
      return *frame_;
    }

    template<typename CoordType>
    inline const ReferenceFrame &Coordinate<CoordType>::frame(
        const ReferenceFrame &new_frame)
    {
      const ReferenceFrame *ret = &new_frame;
      using std::swap;
      swap(frame_, ret);
      return *ret;
    }

    template<typename CoordType>
    inline bool Coordinate<CoordType>::operator==(const CoordType &rhs) const
    {
      if(frame() == rhs.frame())
      {
        return as_type<typename CoordType::BaseType>() == rhs;
      }
      else
      {
        return false;
      }
    }

    template<typename CoordType>
    inline bool Coordinate<CoordType>::operator!=(const CoordType &rhs) const
    {
      return !(*this == rhs);
    }

    template<typename CoordType>
    inline bool Coordinate<CoordType>::approximately_equal(
        const CoordType &other, double epsilon) const
    {
      return distance_to(other) <= epsilon;
    }

    template<typename CoordType>
    inline bool Coordinate<CoordType>::operator<(
        const Coordinate<CoordType> &rhs) const
    {
      const CoordType &s = as_coord_type();
      const CoordType &o = rhs.as_coord_type();

      for(int i = 0; i < s.size(); ++i)
      {
        double l = s.get(i);
        double r = o.get(i);
        if(l<r)
          return true;
        if(r<l)
          return false;
      }
      return false;
    }

    template<typename CoordType>
    inline std::string Coordinate<CoordType>::to_string(
        const std::string &delim) const
    {
      std::stringstream buffer;
      const CoordType &s = as_coord_type();
      for(int i = 0; i < s.size(); ++i)
      {
        if(i > 0)
          buffer << delim;
        buffer << s.get(i);
      }
      return buffer.str();
    }

    namespace
    {
      static std::istream &skip_nonnum(std::istream &s)
      {
        int next;
        while(s && (next = s.peek()) != EOF)
        {
          if(next == '.' || next == '-' || (next >= '0' && next <= '9'))
            break;
          s.get();
        }
        return s;
      }
    }

    template<typename CoordType>
    inline void Coordinate<CoordType>::from_string(const std::string &in)
    {
      std::stringstream buffer(in);
      CoordType &s = as_coord_type();
      for(int i = 0; i < s.size(); ++i)
      {
        double val;
        buffer >> skip_nonnum;
        buffer >> val;
        s.set(i, val);
      }
    }

    template<typename CoordType>
    template<typename ContainType>
    inline void Coordinate<CoordType>::to_container(
                                ContainType &container) const
    {
      const CoordType &s = as_coord_type();
      for(int i = 0; i < s.size(); i++)
      {
        container.set(i, s.get(i));
      }
    }

    template<typename CoordType>
    template<typename O, typename ContainType>
    inline void Coordinate<CoordType>::to_container(
                                ContainType &container) const
    {
      const CoordType &s = as_coord_type();
      container.set(0, s.get(O::find(0)));
      container.set(1, s.get(O::find(1)));
      container.set(2, s.get(O::find(2)));
    }

    template<typename CoordType>
    template<typename ContainType>
    inline void Coordinate<CoordType>::from_container(
                              const ContainType &container)
    {
      CoordType &s = as_coord_type();
      for(int i = 0; i < s.size(); i++)
      {
        s.set(i, container[i]);
      }
    }

    template<typename CoordType>
    template<typename O, typename ContainType>
    inline void Coordinate<CoordType>::from_container(
                                ContainType &container)
    {
      CoordType &s = as_coord_type();
      s.set(0, container[O::get(0)]);
      s.set(1, container[O::get(1)]);
      s.set(2, container[O::get(2)]);
    }

    template<typename CoordType>
    template<typename ContainType>
    inline void Coordinate<CoordType>::to_array(
                                ContainType &out) const
    {
      const CoordType &s = as_coord_type();
      for(int i = 0; i < s.size(); i++)
      {
        out[i] = s.get(i);
      }
    }

    template<typename CoordType>
    template<typename ContainType>
    inline void Coordinate<CoordType>::from_array(
                              const ContainType &in)
    {
      CoordType &s = as_coord_type();
      for(int i = 0; i < s.size(); i++)
      {
        s.set(i, in[i]);
      }
    }

    template<typename CoordType>
    template<typename ContainType>
    inline bool Coordinate<CoordType>::operator==(
      const ContainType &container) const
    {
      const CoordType &s = as_coord_type();
      for(int i = 0; i < s.size(); i++)
      {
        if(s.get(i) != container[i])
          return false;
      }
      return true;
    }

    template<typename CoordType>
    template<typename ContainType>
    inline bool Coordinate<CoordType>::operator!=(
      const ContainType &container) const
    {
      return !operator==(container);
    }
  }
}

#endif
