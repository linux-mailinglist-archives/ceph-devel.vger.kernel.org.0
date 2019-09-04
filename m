Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C618A84B3
	for <lists+ceph-devel@lfdr.de>; Wed,  4 Sep 2019 15:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730410AbfIDNp4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 4 Sep 2019 09:45:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:37740 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726943AbfIDNp4 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 4 Sep 2019 09:45:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 12D6AAD5D;
        Wed,  4 Sep 2019 13:45:55 +0000 (UTC)
From:   Abhishek Lekshmanan <abhishek@suse.com>
To:     ceph-announce@ceph.com, ceph-maintainers@ceph.com,
        ceph-users@ceph.com, dev@ceph.io, ceph-devel@vger.kernel.org
Subject: v14.2.3 Nautilus released
Date:   Wed, 04 Sep 2019 15:45:54 +0200
Message-ID: <87v9u8dvjh.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


This is the third bug fix release of Ceph Nautilus release series. This
release fixes a security issue. We recommend all Nautilus users upgrade
to this release. For upgrading from older releases of ceph, general
guidelines for upgrade to nautilus must be followed

Notable Changes
---------------
* CVE-2019-10222 - Fixed a denial of service vulnerability where an
  unauthenticated client of Ceph Object Gateway could trigger a crash from an
  uncaught exception
* Nautilus-based librbd clients can now open images on Jewel clusters.
* The RGW `num_rados_handles` has been removed. If you were using a value of
  `num_rados_handles` greater than 1, multiply your current
  `objecter_inflight_ops` and `objecter_inflight_op_bytes` parameters by the
  old `num_rados_handles` to get the same throttle behavior.
* The secure mode of Messenger v2 protocol is no longer experimental with this
  release. This mode is now the preferred mode of connection for monitors.
* "osd_deep_scrub_large_omap_object_key_threshold" has been lowered to detect an
  object with large number of omap keys more easily.

For a detailed changelog please refer to the official release notes 
entry at the ceph blog: https://ceph.io/releases/v14-2-3-nautilus-released/

Getting Ceph
------------

* Git at git://github.com/ceph/ceph.git
* Tarball at http://download.ceph.com/tarballs/ceph-14.2.3.tar.gz
* For packages, see http://docs.ceph.com/docs/master/install/get-packages/
* Release git sha1: 0f776cf838a1ae3130b2b73dc26be9c95c6ccc39

-- 
Abhishek Lekshmanan
SUSE Software Solutions Germany GmbH
