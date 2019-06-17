Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD6D4876A
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Jun 2019 17:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbfFQPh5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 Jun 2019 11:37:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:54566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726047AbfFQPh5 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 11:37:57 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6745F2084A;
        Mon, 17 Jun 2019 15:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560785875;
        bh=zt1dB9fIhQiIsoZiWhYaAazaQWFTR42SrKJVRQDr0Lw=;
        h=From:To:Cc:Subject:Date:From;
        b=TKZSgFDWaV/0AYwz0YpkR4M0Yi+CJ4WwnCTER1JqK2OPN6YO70ax8frEGWUNw/3Ve
         2JDzUXsPbgpq8Ycrv3+oe8eyPOgrBAwVk13qLEpwwwDCljr5BmaSANugm/prSDG6jI
         t/Y6OkAG6C5/O2HNM1AhEGIsxKLAoyY3d0V9o6fg=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     zyan@redhat.com, sage@redhat.com, idryomov@gmail.com
Subject: [PATCH v2 00/18] ceph: addr2, btime and change_attr support
Date:   Mon, 17 Jun 2019 11:37:35 -0400
Message-Id: <20190617153753.3611-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

v2: properly handle later versions in entity_addr decoder
    internally track addresses as TYPE_LEGACY instead of TYPE_NONE
    minor cleanup and log changes

This is the second posting of this set. This one should handle decoding
later versions of the entity_addr_t struct, should there ever be any
(thanks, Zheng!).

This also breaks up that decoder into smaller helper functions, and
changes how we track the addresses internally for better compatibility
going forward.

Original patch description follows:

------------------------8<-------------------------

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

Jeff Layton (18):
  libceph: fix sa_family just after reading address
  libceph: add ceph_decode_entity_addr
  libceph: ADDR2 support for monmap
  libceph: switch osdmap decoding to use ceph_decode_entity_addr
  libceph: fix watch_item_t decoding to use ceph_decode_entity_addr
  libceph: correctly decode ADDR2 addresses in incremental OSD maps
  ceph: have MDS map decoding use entity_addr_t decoder
  ceph: fix decode_locker to use ceph_decode_entity_addr
  libceph: use TYPE_LEGACY for entity addrs instead of TYPE_NONE
  libceph: rename ceph_encode_addr to ceph_encode_banner_addr
  ceph: add btime field to ceph_inode_info
  ceph: handle btime in cap messages
  libceph: turn on CEPH_FEATURE_MSG_ADDR2
  ceph: allow querying of STATX_BTIME in ceph_getattr
  iversion: add a routine to update a raw value with a larger one
  ceph: add change_attr field to ceph_inode_info
  ceph: handle change_attr in cap messages
  ceph: increment change_attribute on local changes

 fs/ceph/addr.c                     |  2 +
 fs/ceph/caps.c                     | 37 +++++++------
 fs/ceph/file.c                     |  5 ++
 fs/ceph/inode.c                    | 23 ++++++--
 fs/ceph/mds_client.c               | 21 +++++---
 fs/ceph/mds_client.h               |  2 +
 fs/ceph/mdsmap.c                   | 12 +++--
 fs/ceph/snap.c                     |  3 ++
 fs/ceph/super.h                    |  4 +-
 include/linux/ceph/ceph_features.h |  1 +
 include/linux/ceph/decode.h        | 13 ++++-
 include/linux/ceph/mon_client.h    |  1 -
 include/linux/iversion.h           | 24 +++++++++
 net/ceph/Makefile                  |  2 +-
 net/ceph/cls_lock_client.c         |  7 ++-
 net/ceph/decode.c                  | 86 ++++++++++++++++++++++++++++++
 net/ceph/messenger.c               | 14 ++---
 net/ceph/mon_client.c              | 21 +++++---
 net/ceph/osd_client.c              | 20 ++++---
 net/ceph/osdmap.c                  | 31 ++++++-----
 20 files changed, 258 insertions(+), 71 deletions(-)
 create mode 100644 net/ceph/decode.c

-- 
2.21.0

