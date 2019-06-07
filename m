Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94A7938F36
	for <lists+ceph-devel@lfdr.de>; Fri,  7 Jun 2019 17:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729768AbfFGPiT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 7 Jun 2019 11:38:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:48152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728247AbfFGPiT (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 7 Jun 2019 11:38:19 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3E4220840;
        Fri,  7 Jun 2019 15:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559921898;
        bh=T0xcd+U5431XvAf/irQK/7jSer3NnVOLKkTQQDBac70=;
        h=From:To:Cc:Subject:Date:From;
        b=Vd4jpuQsn9L870tYgkx9UHuRDejOhLLJqaOoVbMjQP5Og9Cepp+dQRUqqEEnLpTSC
         V9HhnGZcxwh8ruzUfan+wgLLY81pnEphF+7MYDp5R89MrUvyxqa6nmkeNsdOPH1Ee1
         OGaPc6aU1etMjQQd7HvbQ0l4ETNS66NCFjvI7YE4=
From:   Jeff Layton <jlayton@kernel.org>
To:     idryomov@redhat.com, zyan@redhat.com, sage@redhat.com
Cc:     ceph-devel@vger.kernel.org, dev@ceph.io
Subject: [PATCH 00/16] ceph: addr2, btime and change_attr support
Date:   Fri,  7 Jun 2019 11:38:00 -0400
Message-Id: <20190607153816.12918-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

CEPH_FEATURE_MSG_ADDR2 was added to the userland code a couple of years
ago, but the kclient never got support for it. While addr2 doesn't add a
lot of new functionality, it is a prerequisite for msgr2 support, which
we will eventually need, and the feature bit is shared with
CEPH_FEATURE_FS_BTIME and CEPH_FEATURE_FS_CHANGE_ATTR.

This set adds support for all of three features (necessary since the bit
is shared). I've also added support for querying birthtime via statx().

I was able to do a cephfs mount and ran xfstests on it, but some of the
more obscure messages haven't yet been tested. Birthtime support works
as expected, but I don't have a great way to test the change attribute.

We don't set SB_I_VERSION, so none of the internal kernel users will
rely on it, and that value is not exposed to userspace via statx (yet).
Given that, we could leave off the last 4 patches for now.

Jeff Layton (16):
  libceph: fix sa_family just after reading address
  libceph: add ceph_decode_entity_addr
  libceph: ADDR2 support for monmap
  libceph: switch osdmap decoding to use ceph_decode_entity_addr
  libceph: fix watch_item_t decoding to use ceph_decode_entity_addr
  libceph: correctly decode ADDR2 addresses in incremental OSD maps
  ceph: have MDS map decoding use entity_addr_t decoder
  ceph: fix decode_locker to use ceph_decode_entity_addr
  ceph: add btime field to ceph_inode_info
  ceph: handle btime in cap messages
  libceph: turn on CEPH_FEATURE_MSG_ADDR2
  ceph: allow querying of STATX_BTIME in ceph_getattr
  iversion: add a routine to update a raw value with a larger one
  ceph: add change_attr field to ceph_inode_info
  ceph: handle change_attr in cap messages
  ceph: increment change_attribute on local changes

 fs/ceph/addr.c                     |  2 +
 fs/ceph/caps.c                     | 37 +++++++++------
 fs/ceph/file.c                     |  5 ++
 fs/ceph/inode.c                    | 23 +++++++--
 fs/ceph/mds_client.c               | 21 +++++----
 fs/ceph/mds_client.h               |  2 +
 fs/ceph/mdsmap.c                   | 12 +++--
 fs/ceph/snap.c                     |  3 ++
 fs/ceph/super.h                    |  4 +-
 include/linux/ceph/ceph_features.h |  1 +
 include/linux/ceph/decode.h        |  2 +
 include/linux/ceph/mon_client.h    |  1 -
 include/linux/iversion.h           | 24 ++++++++++
 net/ceph/Makefile                  |  2 +-
 net/ceph/cls_lock_client.c         |  7 ++-
 net/ceph/decode.c                  | 75 ++++++++++++++++++++++++++++++
 net/ceph/messenger.c               |  5 +-
 net/ceph/mon_client.c              | 21 +++++----
 net/ceph/osd_client.c              | 20 +++++---
 net/ceph/osdmap.c                  | 31 ++++++------
 20 files changed, 232 insertions(+), 66 deletions(-)
 create mode 100644 net/ceph/decode.c

-- 
2.21.0

