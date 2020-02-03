Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 147EE150621
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Feb 2020 13:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbgBCM0E convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Mon, 3 Feb 2020 07:26:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:40000 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727746AbgBCM0D (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 3 Feb 2020 07:26:03 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 36CBFADA1;
        Mon,  3 Feb 2020 12:26:01 +0000 (UTC)
From:   Abhishek Lekshmanan <abhishek@suse.com>
To:     ceph-announce@ceph.io, ceph-users@ceph.io, dev@ceph.io,
        ceph-devel@vger.kernel.org
Subject: v12.2.13 Luminous released
Date:   Mon, 03 Feb 2020 13:26:00 +0100
Message-ID: <87ftfreu1z.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


We're happy to announce 13th bug fix release of the Luminous v12.2.x
long term stable release series. We recommend that all users upgrade to
this release. Many thanks to all the contributors, in particular Yuri &
Nathan, in getting this release out of the door. This shall be the last
release of the Luminous series.

For a detailed release notes, please check out the official blog entry
at https://ceph.io/releases/v12-2-13-luminous-released/

Notable Changes
---------------

* Ceph now packages python bindings for python3.6 instead of python3.4,
  because EPEL7 recently switched from python3.4 to python3.6 as the
  native python3. see the announcement[1] for more details on the
  background of this change.

* We now have telemetry support via a ceph-mgr module. The telemetry module is
  absolutely on an opt-in basis, and is meant to collect generic cluster
  information and push it to a central endpoint. By default, we're pushing it
  to a project endpoint at https://telemetry.ceph.com/report, but this is
  customizable using by setting the 'url' config option with::

    ceph telemetry config-set url '<your url>'

  You will have to opt-in on sharing your information with::

    ceph telemetry on

  You can view exactly what information will be reported first with::

    ceph telemetry show

  Should you opt-in, your information will be licensed under the
  Community Data License Agreement - Sharing - Version 1.0, which you can
  read at https://cdla.io/sharing-1-0/

  The telemetry module reports information about CephFS file systems,
  including:

    - how many MDS daemons (in total and per file system)
    - which features are (or have been) enabled
    - how many data pools
    - approximate file system age (year + month of creation)
    - how much metadata is being cached per file system

  As well as:

    - whether IPv4 or IPv6 addresses are used for the monitors
    - whether RADOS cache tiering is enabled (and which mode)
    - whether pools are replicated or erasure coded, and
      which erasure code profile plugin and parameters are in use
    - how many RGW daemons, zones, and zonegroups are present; which RGW frontends are in use
    - aggregate stats about the CRUSH map, like which algorithms are used, how
      big buckets are, how many rules are defined, and what tunables are in use

* A health warning is now generated if the average osd heartbeat ping
  time exceeds a configurable threshold for any of the intervals
  computed. The OSD computes 1 minute, 5 minute and 15 minute intervals
  with average, minimum and maximum values. New configuration option
  `mon_warn_on_slow_ping_ratio` specifies a percentage of
  `osd_heartbeat_grace` to determine the threshold. A value of zero
  disables the warning. New configuration option
  `mon_warn_on_slow_ping_time` specified in milliseconds over-rides the
  computed value, causes a warning when OSD heartbeat pings take longer
  than the specified amount. New admin command `ceph daemon mgr.#
  dump_osd_network [threshold]` command will list all connections with a
  ping time longer than the specified threshold or value determined by
  the config options, for the average for any of the 3 intervals. New
  admin command `ceph daemon osd.# dump_osd_network [threshold]` will do
  the same but only including heartbeats initiated by the specified OSD.

* The configuration value `osd_calc_pg_upmaps_max_stddev` used for upmap
  balancing has been removed. Instead use the mgr balancer config
  `upmap_max_deviation` which now is an integer number of PGs of
  deviation from the target PGs per OSD. This can be set with a command
  like `ceph config set mgr mgr/balancer/upmap_max_deviation 2`. The
  default `upmap_max_deviation` is 1. There are situations where crush
  rules would not allow a pool to ever have completely balanced PGs. For
  example, if crush requires 1 replica on each of 3 racks, but there are
  fewer OSDs in 1 of the racks. In those cases, the configuration value
  can be increased.


Getting Ceph
------------

* Git at git://github.com/ceph/ceph.git
* Tarball at http://download.ceph.com/tarballs/ceph-12.2.13.tar.gz
* For packages, see http://docs.ceph.com/docs/master/install/get-packages/
* Release git sha1: 584a20eb0237c657dc0567da126be145106aa47e

[1]: https://lists.fedoraproject.org/archives/list/epel-announce@lists.fedoraproject.org/message/EGUMKAIMPK2UD5VSHXM53BH2MBDGDWMO/

--
Abhishek Lekshmanan
SUSE Software Solutions Germany GmbH
GF: Felix Imendörffer HRB 21284 (AG Nürnberg)
