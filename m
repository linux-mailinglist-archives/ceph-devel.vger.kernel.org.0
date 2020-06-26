Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7C620B553
	for <lists+ceph-devel@lfdr.de>; Fri, 26 Jun 2020 17:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbgFZPxY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Fri, 26 Jun 2020 11:53:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:41670 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727062AbgFZPxX (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 26 Jun 2020 11:53:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 90D4DAEA7;
        Fri, 26 Jun 2020 15:53:22 +0000 (UTC)
From:   Abhishek Lekshmanan <abhishek@suse.com>
To:     ceph-announce@ceph.io, ceph-users@ceph.io, dev@ceph.io,
        ceph-devel@vger.kernel.org, ceph-maintainers@ceph.io
Subject: v14.2.10 Nautilus released
Date:   Fri, 26 Jun 2020 17:51:35 +0200
Message-ID: <87a70pzuyg.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


We're happy to announce the tenth release in the Nautilus series. In
addition to fixing a security-related bug in RGW, this release brings a
number of bugfixes across all major components of Ceph. We recommend
that all Nautilus users upgrade to this release. For a detailed
changelog please refer to the ceph release blog at:
https://ceph.io/releases/v14-2-10-nautilus-released

Notable Changes
---------------
* CVE-2020-10753: rgw: sanitize newlines in s3 CORSConfiguration's ExposeHeader
  (William Bowling, Adam Mohammed, Casey Bodley)

* RGW: Bucket notifications now support Kafka endpoints. This requires librdkafka of
  version 0.9.2 and up. Note that Ubuntu 16.04.6 LTS (Xenial Xerus) has an older
  version of librdkafka, and would require an update to the library.

* The pool parameter `target_size_ratio`, used by the pg autoscaler,
  has changed meaning. It is now normalized across pools, rather than
  specifying an absolute ratio. For details, see :ref:`pg-autoscaler`.
  If you have set target size ratios on any pools, you may want to set
  these pools to autoscale `warn` mode to avoid data movement during
  the upgrade::

    ceph osd pool set <pool-name> pg_autoscale_mode warn

* The behaviour of the `-o` argument to the rados tool has been reverted to
  its orignal behaviour of indicating an output file. This reverts it to a more
  consistent behaviour when compared to other tools. Specifying object size is now
  accomplished by using an upper case O `-O`.

* The format of MDSs in `ceph fs dump` has changed.

* Ceph will issue a health warning if a RADOS pool's `size` is set to 1
  or in other words the pool is configured with no redundancy. This can
  be fixed by setting the pool size to the minimum recommended value
  with::

    ceph osd pool set <pool-name> size <num-replicas>

  The warning can be silenced with::

    ceph config set global mon_warn_on_pool_no_redundancy false

* RGW: bucket listing performance on sharded bucket indexes has been
  notably improved by heuristically -- and significantly, in many
  cases -- reducing the number of entries requested from each bucket
  index shard.

Getting Ceph
------------
* Git at git://github.com/ceph/ceph.git
* Tarball at http://download.ceph.com/tarballs/ceph-14.2.10.tar.gz
* For packages, see http://docs.ceph.com/docs/master/install/get-packages/
* Release git sha1: b340acf629a010a74d90da5782a2c5fe0b54ac20

--
Abhishek Lekshmanan
SUSE Software Solutions Germany GmbH
GF: Felix Imendörffer, HRB 36809 (AG Nürnberg)
