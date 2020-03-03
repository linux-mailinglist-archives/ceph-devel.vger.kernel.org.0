Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 648BE177629
	for <lists+ceph-devel@lfdr.de>; Tue,  3 Mar 2020 13:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728497AbgCCMgD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Tue, 3 Mar 2020 07:36:03 -0500
Received: from mx2.suse.de ([195.135.220.15]:38284 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727993AbgCCMgD (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 3 Mar 2020 07:36:03 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 19A3FAE99;
        Tue,  3 Mar 2020 12:36:00 +0000 (UTC)
From:   Abhishek Lekshmanan <abhishek@suse.com>
To:     ceph-announce@ceph.io, ceph-users@ceph.io, dev@ceph.io,
        ceph-devel@vger.kernel.org
Subject: v14.2.8 Nautilus released 
Date:   Tue, 03 Mar 2020 13:36:00 +0100
Message-ID: <87sgipaa4v.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


This is the eighth update to the Ceph Nautilus release series. This release
fixes issues across a range of subsystems. We recommend that all users upgrade
to this release. Please note the following important changes in this
release; as always the full changelog is posted at:
https://ceph.io/releases/v14-2-8-nautilus-released

Notable Changes
---------------

* The default value of `bluestore_min_alloc_size_ssd` has been changed
  to 4K to improve performance across all workloads.

* The following OSD memory config options related to bluestore cache autotuning can now
  be configured during runtime:

    - osd_memory_base (default: 768 MB)
    - osd_memory_cache_min (default: 128 MB)
    - osd_memory_expected_fragmentation (default: 0.15)
    - osd_memory_target (default: 4 GB)

  The above options can be set with::

    ceph config set osd <option> <value>

* The MGR now accepts `profile rbd` and `profile rbd-read-only` user caps.
  These caps can be used to provide users access to MGR-based RBD functionality
  such as `rbd perf image iostat` an `rbd perf image iotop`.

* The configuration value `osd_calc_pg_upmaps_max_stddev` used for upmap
  balancing has been removed. Instead use the mgr balancer config
  `upmap_max_deviation` which now is an integer number of PGs of deviation
  from the target PGs per OSD.  This can be set with a command like
  `ceph config set mgr mgr/balancer/upmap_max_deviation 2`.  The default
  `upmap_max_deviation` is 1.  There are situations where crush rules
  would not allow a pool to ever have completely balanced PGs.  For example, if
  crush requires 1 replica on each of 3 racks, but there are fewer OSDs in 1 of
  the racks.  In those cases, the configuration value can be increased.

* RGW: a mismatch between the bucket notification documentation and the actual
  message format was fixed. This means that any endpoints receiving bucket
  notification, will now receive the same notifications inside a JSON array
  named 'Records'. Note that this does not affect pulling bucket notification
  from a subscription in a 'pubsub' zone, as these are already wrapped inside
  that array.

* CephFS: multiple active MDS forward scrub is now rejected. Scrub currently
  only is permitted on a file system with a single rank. Reduce the ranks to one
  via `ceph fs set <fs_name> max_mds 1`.

* Ceph now refuses to create a file system with a default EC data pool. For
  further explanation, see:
  https://docs.ceph.com/docs/nautilus/cephfs/createfs/#creating-pools

* Ceph will now issue a health warning if a RADOS pool has a `pg_num`
  value that is not a power of two. This can be fixed by adjusting
  the pool to a nearby power of two::

    ceph osd pool set <pool-name> pg_num <new-pg-num>

  Alternatively, the warning can be silenced with::

    ceph config set global mon_warn_on_pool_pg_num_not_power_of_two false

Getting Ceph
------------

* Git at git://github.com/ceph/ceph.git
* Tarball at http://download.ceph.com/tarballs/ceph-14.2.8.tar.gz
* For packages, see http://docs.ceph.com/docs/master/install/get-packages/
* Release git sha1: 2d095e947a02261ce61424021bb43bd3022d35cb

-- 
Abhishek Lekshmanan
SUSE Software Solutions Germany GmbH
GF: Felix Imendörffer HRB 21284 (AG Nürnberg)
