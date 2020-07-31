Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6471523467F
	for <lists+ceph-devel@lfdr.de>; Fri, 31 Jul 2020 15:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731302AbgGaNEY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 31 Jul 2020 09:04:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:33596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727040AbgGaNEX (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 31 Jul 2020 09:04:23 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D859B2245C;
        Fri, 31 Jul 2020 13:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596200663;
        bh=RKaOYQtHSkvyIsidzWGLLE+alk9OwCyfGAitLjeQsa4=;
        h=From:To:Cc:Subject:Date:From;
        b=nkgGhGh8hdqE4wTLWiOYwNfnAWr7+z3d9SBhiqTZWGmhEXAvX/qlUkqAVJH/38DhK
         0CTjrpQNLfL7dWg5Btio48I0Y47V3eWi6/AVpYhT487ln1Nre2d7gtdJtiDjkjR6oZ
         Z8VpBYsbLr8QvK6O4+wkMt0zyvt7bnjp88lyuae8=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     linux-cachefs@redhat.com, idryomov@gmail.com
Subject: [RFC PATCH v2 00/11] ceph: convert to new FSCache API
Date:   Fri, 31 Jul 2020 09:04:10 -0400
Message-Id: <20200731130421.127022-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This patchset converts ceph to use the new (not yet merged) FSCache API.
Trying to use fscache+ceph today usually results in oopses. With this
series, it seems to be quite stable.

Where possible, I've converted the code to use the new read helper,
which hides away a lot of the gory details of page handling, which I think
makes the resulting code clearer than it was.

It starts with a few cleanup/reorganization patches to prepare the code. I then
rip out most of the old ceph fscache helpers and replace them with new
ones for the new API.

The rest of the series then plugs buffered read/write caching support
back into the code, with the most of the read-side routines using the
fscache_read_helper.

This passes xfstests' quick group run with the cache disabled. With it
enabled, it passed most of it, but I hit some OOM kills on generic/531.
Still tracking that bit down, but we suspect the problem is in
fscache/cachefiles code and not in these patches.

This is based on top of David's latest fscache-iter branch:

    https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=fscache-iter

...my branch is here:

    https://git.kernel.org/pub/scm/linux/kernel/git/jlayton/linux.git/log/?h=ceph-fscache-iter

Jeff Layton (11):
  ceph: break out writeback of incompatible snap context to separate
    function
  ceph: don't call ceph_update_writeable_page from page_mkwrite
  ceph: fold ceph_sync_readpages into ceph_readpage
  ceph: fold ceph_sync_writepages into writepage_nounlock
  ceph: fold ceph_update_writeable_page into ceph_write_begin
  ceph: conversion to new fscache API
  ceph: convert readpage to fscache read helper
  ceph: plug write_begin into read helper
  ceph: convert readpages to fscache_read_helper
  ceph: add fscache writeback support
  ceph: re-enable fscache support

 fs/ceph/Kconfig |   4 +-
 fs/ceph/addr.c  | 939 +++++++++++++++++++++++++++---------------------
 fs/ceph/cache.c | 290 ++++-----------
 fs/ceph/cache.h | 106 ++----
 fs/ceph/caps.c  |  11 +-
 fs/ceph/file.c  |  13 +-
 fs/ceph/inode.c |  14 +-
 fs/ceph/super.h |   1 -
 8 files changed, 645 insertions(+), 733 deletions(-)

-- 
2.26.2

