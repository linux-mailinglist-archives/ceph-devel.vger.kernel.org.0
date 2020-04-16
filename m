Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49BA81ACFE7
	for <lists+ceph-devel@lfdr.de>; Thu, 16 Apr 2020 20:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbgDPSq0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Thu, 16 Apr 2020 14:46:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:52690 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727962AbgDPSq0 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 16 Apr 2020 14:46:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 72BBAAED9;
        Thu, 16 Apr 2020 18:46:23 +0000 (UTC)
From:   Abhishek Lekshmanan <abhishek@suse.com>
To:     ceph-announce@ceph.io, ceph-users@ceph.io, dev@ceph.io,
        ceph-devel@vger.kernel.org, ceph-maintainers@ceph.io
Subject: v13.2.9 Mimic released
Date:   Thu, 16 Apr 2020 20:46:12 +0200
Message-ID: <87zhbbl157.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


We're glad to announce the availability of the ninth and very likely the
last stable release in the Ceph Mimic stable release series. This
release fixes bugs across all components and also contains a RGW
security fix. We recommend all mimic users to upgrade to this version.
We thank everyone for making this release a possibility.

Notable Changes
---------------

* CVE-2020-1760: Fixed XSS due to RGW GetObject header-splitting
* The configuration value `osd_calc_pg_upmaps_max_stddev` used for upmap
  balancing has been removed. Instead use the mgr balancer config
  `upmap_max_deviation` which now is an integer number of PGs of deviation
  from the target PGs per OSD.  This can be set with a command like
  `ceph config set mgr mgr/balancer/upmap_max_deviation 2`.  The default
  `upmap_max_deviation` is 1.  There are situations where crush rules
  would not allow a pool to ever have completely balanced PGs.  For example, if
  crush requires 1 replica on each of 3 racks, but there are fewer OSDs in 1 of
  the racks.  In those cases, the configuration value can be increased.
* The `cephfs-data-scan scan_links` command now automatically repair inotables
  and snaptable.

For the full changelog please refer to the official release blog entry
at https://ceph.io/releases/v13-2-9-mimic-released

Getting Ceph
------------
* Git at git://github.com/ceph/ceph.git
* Tarball at http://download.ceph.com/tarballs/ceph-13.2.9.tar.gz
* For packages, see
http://docs.ceph.com/docs/master/install/get-packages/
* Release git sha1: 58a2a9b31fd08d8bb3089fce0e312331502ff945

-- 
Abhishek Lekshmanan
SUSE Software Solutions Germany GmbH
GF: Felix Imendörffer 
