Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95A1F1183E3
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Dec 2019 10:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbfLJJpT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Dec 2019 04:45:19 -0500
Received: from mx2.suse.de ([195.135.220.15]:52248 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727016AbfLJJpT (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 10 Dec 2019 04:45:19 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0AF22AD76;
        Tue, 10 Dec 2019 09:45:17 +0000 (UTC)
From:   Abhishek Lekshmanan <abhishek@suse.com>
To:     ceph-announce@ceph.io, ceph-users@ceph.io, dev@ceph.io,
        ceph-devel@vger.kernel.org
Subject: v14.2.5 Nautilus released
Date:   Tue, 10 Dec 2019 10:45:16 +0100
Message-ID: <87sglscy4z.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This is the fifth release of the Ceph Nautilus release series. Among the many
notable changes, this release fixes a critical BlueStore bug that was introduced
in 14.2.3. All Nautilus users are advised to upgrade to this release.

For the complete changelog entry, please visit the release blog at
https://ceph.io/releases/v14-2-5-nautilus-released/

Notable Changes
---------------

Critical fix:

* This release fixes a `critical BlueStore bug <https://tracker.ceph.com/issues/42223>`_
  introduced in 14.2.3 (and also present in 14.2.4) that can lead to data
  corruption when a separate "WAL" device is used.

New health warnings:

* Ceph will now issue health warnings if daemons have recently crashed. Ceph
  has been collecting crash reports since the initial Nautilus release, but the
  health alerts are new. To view new crashes (or all crashes, if you've just
  upgraded)::

    ceph crash ls-new

  To acknowledge a particular crash (or all crashes) and silence the health warning::

    ceph crash archive <crash-id>
    ceph crash archive-all

* Ceph will now issue a health warning if a RADOS pool has a ``pg_num``
  value that is not a power of two. This can be fixed by adjusting
  the pool to a nearby power of two::

    ceph osd pool set <pool-name> pg_num <new-pg-num>

  Alternatively, the warning can be silenced with::

    ceph config set global mon_warn_on_pool_pg_num_not_power_of_two false

* Ceph will issue a health warning if a RADOS pool's ``size`` is set to 1
  or, in other words, if the pool is configured with no redundancy. Ceph will
  stop issuing the warning if the pool size is set to the minimum
  recommended value::

    ceph osd pool set <pool-name> size <num-replicas>

  The warning can be silenced with::

    ceph config set global mon_warn_on_pool_no_redundancy false

* A health warning is now generated if the average osd heartbeat ping
  time exceeds a configurable threshold for any of the intervals
  computed. The OSD computes 1 minute, 5 minute and 15 minute
  intervals with average, minimum and maximum values.  New configuration
  option `mon_warn_on_slow_ping_ratio` specifies a percentage of
  `osd_heartbeat_grace` to determine the threshold.  A value of zero
  disables the warning. New configuration option `mon_warn_on_slow_ping_time`
  specified in milliseconds over-rides the computed value, causes a warning
  when OSD heartbeat pings take longer than the specified amount.
  A new admin command, `ceph daemon mgr.# dump_osd_network [threshold]`, will
  list all connections with a ping time longer than the specified threshold or
  value determined by the config options, for the average for any of the 3 intervals.
  Another new admin command, `ceph daemon osd.# dump_osd_network [threshold]`,
  will do the same but only including heartbeats initiated by the specified OSD.

Changes in the telemetry module:

* The telemetry module now has a 'device' channel, enabled by default, that
  will report anonymized hard disk and SSD health metrics to telemetry.ceph.com
  in order to build and improve device failure prediction algorithms. Because
  the content of telemetry reports has changed, you will need to re-opt-in
  with::

    ceph telemetry on

  You can view exactly what information will be reported first with::

    ceph telemetry show
    ceph telemetry show device   # specifically show the device channel

  If you are not comfortable sharing device metrics, you can disable that
  channel first before re-opting-in:

    ceph config set mgr mgr/telemetry/channel_crash false
    ceph telemetry on

* The telemetry module now reports more information about CephFS file systems,
  including:

    - how many MDS daemons (in total and per file system)
    - which features are (or have been) enabled
    - how many data pools
    - approximate file system age (year + month of creation)
    - how many files, bytes, and snapshots
    - how much metadata is being cached

  We have also added:

    - which Ceph release the monitors are running
    - whether msgr v1 or v2 addresses are used for the monitors
    - whether IPv4 or IPv6 addresses are used for the monitors
    - whether RADOS cache tiering is enabled (and which mode)
    - whether pools are replicated or erasure coded, and
      which erasure code profile plugin and parameters are in use
    - how many hosts are in the cluster, and how many hosts have each type of daemon
    - whether a separate OSD cluster network is being used
    - how many RBD pools and images are in the cluster, and how many pools have RBD mirroring enabled
    - how many RGW daemons, zones, and zonegroups are present; which RGW frontends are in use
    - aggregate stats about the CRUSH map, like which algorithms are used, how
      big buckets are, how many rules are defined, and what tunables are in
      use

  If you had telemetry enabled, you will need to re-opt-in with::

    ceph telemetry on

  You can view exactly what information will be reported first with::

    ceph telemetry show        # see everything
    ceph telemetry show basic  # basic cluster info (including all of the new info)

OSD:

* A new OSD daemon command, 'dump_recovery_reservations', reveals the
  recovery locks held (in_progress) and waiting in priority queues.

* Another new OSD daemon command, 'dump_scrub_reservations', reveals the
  scrub reservations that are held for local (primary) and remote (replica) PGs.

RGW:

* RGW now supports S3 Object Lock set of APIs allowing for a WORM model for
  storing objects. 6 new APIs have been added put/get bucket object lock,
  put/get object retention, put/get object legal hold.

* RGW now supports List Objects V2

Getting Ceph
------------

* Git at git://github.com/ceph/ceph.git
* Tarball at http://download.ceph.com/tarballs/ceph-14.2.5.tar.gz
* For packages, see http://docs.ceph.com/docs/master/install/get-packages/
* Release git sha1: ad5bd132e1492173c85fda2cc863152730b16a92

-- 
Abhishek Lekshmanan
SUSE Software Solutions Germany GmbH
