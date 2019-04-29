Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07AB1EAC3
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Apr 2019 21:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729159AbfD2TSI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 29 Apr 2019 15:18:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:46834 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728928AbfD2TSH (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 29 Apr 2019 15:18:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BB2B4AE27;
        Mon, 29 Apr 2019 19:18:06 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 29 Apr 2019 21:18:06 +0200
From:   Abhishek <abhishek@suse.com>
To:     ceph-devel@vger.kernel.org, ceph-users@ceph.com,
        ceph-maintainers@ceph.com, ceph-announce@ceph.com
Subject: v14.2.1 Nautilus released
Message-ID: <cbfed3591a3224536aa02f71ca469714@suse.com>
X-Sender: abhishek@suse.com
User-Agent: Roundcube Webmail
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

We're happy to announce the first bug fix release of Ceph Nautilus 
release series.
We recommend all nautilus users upgrade to this release. For upgrading 
from older releases of
ceph, general guidelines for upgrade to nautilus must be followed

Notable Changes
---------------

* The default value for `mon_crush_min_required_version` has been
   changed from `firefly` to `hammer`, which means the cluster will
   issue a health warning if your CRUSH tunables are older than hammer.
   There is generally a small (but non-zero) amount of data that will
   move around by making the switch to hammer tunables; for more 
information,
   see :ref:`crush-map-tunables`.

   If possible, we recommend that you set the oldest allowed client to 
`hammer`
   or later.  You can tell what the current oldest allowed client is 
with::

     ceph osd dump | min_compat_client

   If the current value is older than hammer, you can tell whether it
   is safe to make this change by verifying that there are no clients
   older than hammer current connected to the cluster with::

     ceph features

   The newer `straw2` CRUSH bucket type was introduced in hammer, and
   ensuring that all clients are hammer or newer allows new features
   only supported for `straw2` buckets to be used, including the
   `crush-compat` mode for the :ref:`balancer`.

* Ceph now packages python bindings for python3.6 instead of
   python3.4, because EPEL7 recently switched from python3.4 to
   python3.6 as the native python3. see the `announcement 
<https://lists.fedoraproject.org/archives/list/epel-announce@lists.fedoraproject.org/message/EGUMKAIMPK2UD5VSHXM53BH2MBDGDWMO/>`_
   for more details on the background of this change.

Known Issues
------------

* Nautilus-based librbd clients cannot open images stored on 
pre-Luminous
   clusters


For a detailed changelog please refer to the official release notes
entry at the ceph blog 
https://ceph.com/releases/v14-2-1-nautilus-released/

Getting ceph:
------------
* Git at git://github.com/ceph/ceph.git
* Tarball at http://download.ceph.com/tarballs/ceph-14.2.1.tar.gz
* For packages, see
http://docs.ceph.com/docs/master/install/get-packages/
* Release git sha1: d555a9489eb35f84f2e1ef49b77e19da9d113972


