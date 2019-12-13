Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 595B911E8F5
	for <lists+ceph-devel@lfdr.de>; Fri, 13 Dec 2019 18:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728401AbfLMRKQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 13 Dec 2019 12:10:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:33786 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728382AbfLMRKQ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 13 Dec 2019 12:10:16 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 81A53AD12;
        Fri, 13 Dec 2019 17:10:14 +0000 (UTC)
From:   Abhishek Lekshmanan <abhishek@suse.com>
To:     ceph-announce@ceph.io, ceph-users@ceph.io, dev@ceph.io,
        ceph-devel@vger.kernel.org
Subject: v13.2.8 Mimic released 
Date:   Fri, 13 Dec 2019 18:10:14 +0100
Message-ID: <877e30cft5.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


This is the eighth backport release in the Ceph Mimic stable release
series. Its sole purpose is to fix a regression that found its way into
the previous release. 

Notable Changes
---------------

* Due to a missed backport, clusters in the process of being upgraded from
  13.2.6 to 13.2.7 might suffer an OSD crash in build_incremental_map_msg.
  This regression was reported in https://tracker.ceph.com/issues/43106
  and is fixed in 13.2.8 (this release). Users of 13.2.6 can upgrade to 13.2.8
  directly - i.e., skip 13.2.7 - to avoid this.

Changelog
---------

* osd: fix sending incremental map messages (issue#43106 pr#32000, Sage Weil)
* tests: added missing point release versions (pr#32087, Yuri Weinstein)
* tests: rgw: add missing force-branch: ceph-mimic for swift tasks (pr#32033, Casey Bodley)

For a blog with links to PRs and issues please check out
https://ceph.io/releases/v13-2-8-mimic-released/

Getting Ceph
------------

* Git at git://github.com/ceph/ceph.git
* Tarball at http://download.ceph.com/tarballs/ceph-13.2.8.tar.gz
* For packages, see http://docs.ceph.com/docs/master/install/get-packages/
* Release git sha1: 5579a94fafbc1f9cc913a0f5d362953a5d9c3ae0

-- 
Abhishek Lekshmanan
SUSE Software Solutions Germany GmbH
