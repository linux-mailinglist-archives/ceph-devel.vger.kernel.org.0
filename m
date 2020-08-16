Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE8832459CA
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Aug 2020 00:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729086AbgHPWKu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 16 Aug 2020 18:10:50 -0400
Received: from smtprelay0185.hostedemail.com ([216.40.44.185]:41170 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726114AbgHPWKu (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Sun, 16 Aug 2020 18:10:50 -0400
X-Greylist: delayed 348 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 Aug 2020 18:10:49 EDT
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave02.hostedemail.com (Postfix) with ESMTP id 4C0E31801629E
        for <ceph-devel@vger.kernel.org>; Sun, 16 Aug 2020 22:05:02 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 1ED8F182CED2A;
        Sun, 16 Aug 2020 22:05:01 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:69:355:379:541:968:988:989:1260:1311:1314:1345:1437:1515:1534:1541:1711:1730:1747:1777:1792:1981:2194:2198:2199:2200:2393:2559:2562:3138:3139:3140:3141:3142:3352:3867:3868:4605:5007:6261:10004:10848:11658:11914:12043:12296:12297:12679:12683:12895:13069:13095:13311:13357:13894:14096:14110:14384:14394:14721:21080:21325:21433:21451:21627:21965:30030:30054,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: stamp42_5612a0827011
X-Filterd-Recvd-Size: 1779
Received: from joe-laptop.perches.com (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf16.hostedemail.com (Postfix) with ESMTPA;
        Sun, 16 Aug 2020 22:05:00 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     ceph-devel@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] ceph: Neaten debugging
Date:   Sun, 16 Aug 2020 15:04:51 -0700
Message-Id: <cover.1597615399.git.joe@perches.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Convert special case dout macro to pr_debug and neatening.

Joe Perches (2):
  ceph: Use generic debugging facility
  ceph: Remove embedded function names from pr_debug uses

 fs/ceph/addr.c                  | 266 ++++++++--------
 fs/ceph/cache.c                 |  22 +-
 fs/ceph/caps.c                  | 533 ++++++++++++++++----------------
 fs/ceph/debugfs.c               |   4 +-
 fs/ceph/dir.c                   | 141 ++++-----
 fs/ceph/export.c                |  36 +--
 fs/ceph/file.c                  | 170 +++++-----
 fs/ceph/inode.c                 | 338 ++++++++++----------
 fs/ceph/ioctl.c                 |   6 +-
 fs/ceph/locks.c                 |  42 +--
 fs/ceph/mds_client.c            | 374 +++++++++++-----------
 fs/ceph/mdsmap.c                |  16 +-
 fs/ceph/metric.c                |   4 +-
 fs/ceph/quota.c                 |   4 +-
 fs/ceph/snap.c                  | 135 ++++----
 fs/ceph/super.c                 |  67 ++--
 fs/ceph/xattr.c                 |  64 ++--
 include/linux/ceph/ceph_debug.h |  30 --
 include/linux/ceph/messenger.h  |   2 +-
 19 files changed, 1139 insertions(+), 1115 deletions(-)

-- 
2.26.0

