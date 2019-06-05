Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAB4735D8B
	for <lists+ceph-devel@lfdr.de>; Wed,  5 Jun 2019 15:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbfFENLF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 5 Jun 2019 09:11:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:59426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727917AbfFENLE (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 5 Jun 2019 09:11:04 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95836206BA;
        Wed,  5 Jun 2019 13:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559740264;
        bh=vALxmBBOvPZeDJfZRf0KMUEu4cCJXBDiijSh6ziMZ8c=;
        h=From:To:Cc:Subject:Date:From;
        b=u5EKFZKNp6Toh3HYecIBeG6qaB9/oF0PHIEs2oQgszRHw99fub2EASEogp/G6wAjO
         FR9233qCxAkyUNigrcISn1vzssL6uM/xJemusLXifXyAishmEPoVDzF3LYR/ajI+VK
         7LR0HmBQKFQ39dcSUHJINuud0oeIiDPdggxuHXeg=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com, zyan@redhat.com, sage@redhat.com
Subject: [RFC PATCH 0/9] ceph: add support for addr2 decoding
Date:   Wed,  5 Jun 2019 09:10:53 -0400
Message-Id: <20190605131102.13529-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

CEPH_FEATURE_MSG_ADDR2 was added to the userland code a couple of
years ago, but the kclient never got support for it. This patchset
adds that support.

While addr2 doesn't add a lot of new functionality, it is a prerequisite
for msgr2 support, which we will eventually need.

Note that this set is not quite ready to go in just yet. A couple of
other cephfs features share the same feature bit with addr2, and those
patches aren't quite ready yet.

I was able to do a cephfs mount and some basic filesystem operations
with this series in place, but some of the more obscure messages
haven't yet been tested.

For now, I'm just posting this as an RFC to get some early feedback
on this piece while I work on the cephfs feature support. Once that's
ready I'll plan to merge this into the ceph-client/testing branch and
we can see about getting the whole thing merged for v5.3.

Jeff Layton (9):
  libceph: fix sa_family just after reading address
  libceph: add ceph_decode_entity_addr
  libceph: ADDR2 support for monmap
  libceph: switch osdmap decoding to use ceph_decode_entity_addr
  libceph: fix watch_item_t decoding to use ceph_decode_entity_addr
  libceph: correctly decode ADDR2 addresses in incremental OSD maps
  ceph: have MDS map decoding use entity_addr_t decoder
  ceph: fix decode_locker to use ceph_decode_entity_addr
  libceph: turn on CEPH_FEATURE_MSG_ADDR2

 fs/ceph/mdsmap.c                   | 12 +++--
 include/linux/ceph/ceph_features.h |  1 +
 include/linux/ceph/decode.h        |  2 +
 include/linux/ceph/mon_client.h    |  1 -
 net/ceph/Makefile                  |  2 +-
 net/ceph/cls_lock_client.c         |  7 ++-
 net/ceph/decode.c                  | 75 ++++++++++++++++++++++++++++++
 net/ceph/messenger.c               |  5 +-
 net/ceph/mon_client.c              | 21 +++++----
 net/ceph/osd_client.c              | 20 +++++---
 net/ceph/osdmap.c                  | 31 ++++++------
 11 files changed, 138 insertions(+), 39 deletions(-)
 create mode 100644 net/ceph/decode.c

-- 
2.21.0

