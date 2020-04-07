/**
 * Copyright(c) 2014 Carnegie Mellon University. All Rights Reserved.
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
 * @file test_control_loop.cpp
 * @author James Edmondson <jedmondson@gmail.com>
 *
 * This file contains a test driver for the GAMS controllers loop.
 **/

#include "madara/knowledge/KnowledgeBase.h"
#include "gams/controllers/Multicontroller.h"
#include "madara/logger/GlobalLogger.h"

// default transport settings
std::string host("");
const std::string default_multicast("239.255.0.1:4150");
madara::transport::QoSTransportSettings settings;

// create shortcuts to MADARA classes and namespaces
namespace engine = madara::knowledge;
namespace controllers = gams::controllers;
typedef madara::knowledge::KnowledgeRecord   Record;
typedef Record::Integer Integer;

std::string platform("debug");
std::string algorithm("debug");
std::vector <std::string> accents;

// controllers variables
double period = 1.0;
double max_wait = 50.0;

int gams_fails = 0;

size_t num_controllers = 100;

// handle command line arguments
void handle_arguments(int argc, char ** argv)
{
  for (int i = 1; i < argc; ++i)
  {
    std::string arg1(argv[i]);

    if (arg1 == "-a" || arg1 == "--algorithm")
    {
      if (i + 1 < argc)
      {
        algorithm = argv[i + 1];
      }
      ++i;
    }
    else if (arg1 == "-aa" || arg1 == "--accent")
    {
      if (i + 1 < argc)
      {
        accents.push_back(argv[i + 1]);
      }
      ++i;
    }
    else if (arg1 == "-b" || arg1 == "--broadcast")
    {
      if (i + 1 < argc)
      {
        settings.hosts.push_back(argv[i + 1]);
        settings.type = madara::transport::BROADCAST;
      }
      ++i;
    }
    else if (arg1 == "-u" || arg1 == "--udp")
    {
      if (i + 1 < argc)
      {
        settings.hosts.push_back(argv[i + 1]);
        settings.type = madara::transport::UDP;
      }
      ++i;
    }
    else if (arg1 == "-o" || arg1 == "--host")
    {
      if (i + 1 < argc)
        host = argv[i + 1];

      ++i;
    }
    else if (arg1 == "-d" || arg1 == "--domain")
    {
      if (i + 1 < argc)
        settings.write_domain = argv[i + 1];

      ++i;
    }
    else if (arg1 == "-e" || arg1 == "--period")
    {
      if (i + 1 < argc)
      {
        std::stringstream buffer(argv[i + 1]);
        buffer >> period;
      }

      ++i;
    }
    else if (arg1 == "-f" || arg1 == "--logfile")
    {
      if (i + 1 < argc)
      {
        madara::logger::global_logger->add_file(argv[i + 1]);
      }

      ++i;
    }
    else if (arg1 == "-i" || arg1 == "--id")
    {
      if (i + 1 < argc)
      {
        std::stringstream buffer(argv[i + 1]);
        buffer >> settings.id;
      }

      ++i;
    }
    else if (arg1 == "-l" || arg1 == "--level")
    {
      if (i + 1 < argc)
      {
        std::stringstream buffer(argv[i + 1]);
        int level;
        buffer >> level;
        gams::loggers::global_logger->set_level(level);
      }

      ++i;
    }
    else if (arg1 == "-m" || arg1 == "--multicast")
    {
      if (i + 1 < argc)
      {
        settings.hosts.push_back(argv[i + 1]);
        settings.type = madara::transport::MULTICAST;
      }
      ++i;
    }
    else if (arg1 == "-p" || arg1 == "--platform")
    {
      if (i + 1 < argc)
      {
        platform = argv[i + 1];
      }
      ++i;
    }
    else if (arg1 == "-r" || arg1 == "--reduced")
    {
      settings.send_reduced_message_header = true;
    }
    else if (arg1 == "-e" || arg1 == "--rebroadcasts")
    {
      if (i + 1 < argc)
      {
        int hops;
        std::stringstream buffer(argv[i + 1]);
        buffer >> hops;

        settings.set_rebroadcast_ttl(hops);
        settings.enable_participant_ttl(hops);
      }

      ++i;
    }
    else if (arg1 == "-q" || arg1 == "--queue-length")
    {
      if (i + 1 < argc)
      {
        std::stringstream buffer(argv[i + 1]);
        buffer >> settings.queue_length;
      }

      ++i;
    }
    else if (arg1 == "-n" || arg1 == "--num-controllers")
    {
      if (i + 1 < argc)
      {
        std::stringstream buffer(argv[i + 1]);
        buffer >> num_controllers;
      }

      ++i;
    }
    else if (arg1 == "-st" || arg1 == "--slack-time")
    {
      if (i + 1 < argc)
      {
        std::stringstream buffer(argv[i + 1]);
        buffer >> settings.slack_time;
      }

      ++i;
    }
    else if (arg1 == "-w" || arg1 == "--max-wait")
    {
      if (i + 1 < argc)
      {
        std::stringstream buffer(argv[i + 1]);
        buffer >> max_wait;
      }

      ++i;
    }
    else
    {
      madara::logger::global_logger->log(madara::logger::LOG_ALWAYS,
"\nProgram summary for %s:\n\n" \
"  Attempts to send a file over the network with a certain number\n" \
"  of rebroadcasts(-e|--rebroadcasts controls the number of rebroadcasts)\n\n" \
" [-a|--algorithm type]    algorithm to start with\n" \
" [-aa|--accent type]      accent algorithm to start with\n" \
" [-b|--broadcast ip:port] the broadcast ip to send and listen to\n" \
" [-d|--domain domain]     the knowledge domain to send and listen to\n" \
" [-e|--period period]     time, in seconds, between control loop executions\n" \
" [-f|--logfile file]      log to a file\n" \
" [-i|--id id]             the id of this agent(should be non-negative)\n" \
" [-l|--level level]       the logger level(0+, higher is higher detail)\n" \
" [-m|--multicast ip:port] the multicast ip to send and listen to\n" \
" [-n|--num-controllers n] the number of controllers to spawn\n" \
" [-o|--host hostname]     the hostname of this process(def:localhost)\n" \
" [-p|--platform type]     platform for loop(vrep, dronerk)\n" \
" [-q|--queue-length length] length of transport queue in bytes\n" \
" [-r|--reduced]           use the reduced message header\n" \
" [-st|--slack-time time]  time in seconds to sleep between fragment sends\n" \
"                         (.001 seconds by default)\n" \
" [-t|--target path]       file system location to save received files to\n" \
" [-u|--udp ip:port]       a udp ip to send to(first is self to bind to)\n" \
" [-w|--max-wait time]     maximum time to wait in seconds(double format)\n"\
"\n",
        argv[0]);
      exit(0);
    }
  }
}

// perform main logic of program
int main(int argc, char ** argv)
{
  handle_arguments(argc, argv);

  // create knowledge base and a control loop
  controllers::Multicontroller loop;

  // initialize variables and function stubs
  loop.resize(num_controllers);

  // initialize the platform and algorithm
  loop.init_algorithm(algorithm);
  loop.init_platform(platform);

  // run a mape loop every 1s for 50s
  loop.run(period, max_wait);

  //if (knowledge.get(".executions").to_double() >=(1/period) * max_wait * 0.5)
  //{
  //  knowledge.print("SUCCESS: {.executions} is enough to pass\n");
  //}
  //else
  //{
  //  knowledge.print("SUCCESS: {.executions} is not enough to pass\n");
  //  ++gams_fails;
  //}
  
  if (gams_fails > 0)
  {
    std::cerr << "OVERALL: FAIL. " << gams_fails << " tests failed.\n";
  }
  else
  {
    std::cerr << "OVERALL: SUCCESS.\n";
  }

  return gams_fails;
}
