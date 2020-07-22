Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 322EE2296AC
	for <lists+ceph-devel@lfdr.de>; Wed, 22 Jul 2020 12:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbgGVKzP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 22 Jul 2020 06:55:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:53550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbgGVKzN (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 22 Jul 2020 06:55:13 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E7EE206F5;
        Wed, 22 Jul 2020 10:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595415313;
        bh=jNNt/bsuWIHQWyR1dsIv87KolvZCSH1K4SO1ljkTz7U=;
        h=From:To:Cc:Subject:Date:From;
        b=1lXdXSCl0XPJR2LVkBA175zmzn5voauLHenj+MXGQwBvG95X3mGqTQLEx1HUwSYy8
         fDqQOpVOE3zazWQTzgk+s/4fNdCOuakynUL01+PNmYzSjXWVZC3OxWN05Pn2V4xffI
         Yfh+oW/qW0OwJRiUDr4U3vFfvOH4GLWfJr8cVFcs=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     dhowells@redhat.com, dwysocha@redhat.com, smfrench@gmail.com
Subject: [RFC PATCH 00/11] ceph: convert to new fscache API
Date:   Wed, 22 Jul 2020 06:55:00 -0400
Message-Id: <20200722105511.11187-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Here's my first pass at a conversion to the new fscache API. It starts
with a few cleanup/reorganization patches to prepare the code. I then
rip out most of the old ceph fscache helpers and replace them with new
ones for the new API.

The last patches then plug buffered read and write support back into the
new infrastructure, with most of the read-side routines using the new
fscache_read_helper routines.

This passes xfstests' quick group run with the cache disabled. With it
enabled, it passed most of it, but I hit some OOM kills on generic/531.
Still tracking that bit down, but I suspect the problem is in
fscache/cachefiles code and not in these patches.

Note that this depends on a some patches that were not in David's last
posting of the fscache update, so all of this is not ready for merge. We
could probably take a few of the initial patches earlier though.

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

 fs/ceph/Kconfig |   3 +-
 fs/ceph/addr.c  | 939 +++++++++++++++++++++++++++---------------------
 fs/ceph/cache.c | 290 ++++-----------
 fs/ceph/cache.h | 106 ++----
 fs/ceph/caps.c  |  11 +-
 fs/ceph/file.c  |  13 +-
 fs/ceph/inode.c |  14 +-
 fs/ceph/super.h |   1 -
 8 files changed, 644 insertions(+), 733 deletions(-)

-- 
2.26.2

