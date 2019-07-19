Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8CE16E763
	for <lists+ceph-devel@lfdr.de>; Fri, 19 Jul 2019 16:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729686AbfGSOcZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 19 Jul 2019 10:32:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:41186 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727717AbfGSOcZ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 19 Jul 2019 10:32:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 36936AFF1;
        Fri, 19 Jul 2019 14:32:24 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.com>
To:     Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Henriques <lhenriques@suse.com>
Subject: [PATCH 0/4] Sleeping functions in invalid context bug fixes
Date:   Fri, 19 Jul 2019 15:32:18 +0100
Message-Id: <20190719143222.16058-1-lhenriques@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi,

I'm sending three "sleeping function called from invalid context" bug
fixes that I had on my TODO for a while.  All of them are ceph_buffer_put
related, and all the fixes follow the same pattern: delay the operation
until the ci->i_ceph_lock is released.

The first patch simply allows ceph_buffer_put to receive a NULL buffer so
that the NULL check doesn't need to be performed in all the other patches.
IOW, it's not really required, just convenient.

(Note: maybe these patches should all be tagged for stable.)

Luis Henriques (4):
  libceph: allow ceph_buffer_put() to receive a NULL ceph_buffer
  ceph: fix buffer free while holding i_ceph_lock in __ceph_setxattr()
  ceph: fix buffer free while holding i_ceph_lock in
    __ceph_build_xattrs_blob()
  ceph: fix buffer free while holding i_ceph_lock in fill_inode()

 fs/ceph/caps.c              |  5 ++++-
 fs/ceph/inode.c             |  7 ++++---
 fs/ceph/snap.c              |  4 +++-
 fs/ceph/super.h             |  2 +-
 fs/ceph/xattr.c             | 19 ++++++++++++++-----
 include/linux/ceph/buffer.h |  3 ++-
 6 files changed, 28 insertions(+), 12 deletions(-)

