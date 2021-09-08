Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 492DE403A3C
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Sep 2021 15:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235502AbhIHNEv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Sep 2021 09:04:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:42330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232097AbhIHNEp (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 8 Sep 2021 09:04:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0BAC61139;
        Wed,  8 Sep 2021 13:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631106218;
        bh=cHuDhM60sT/5MlF7sYcM+5xwn8RfRchfh6+8x9fc/7o=;
        h=From:To:Cc:Subject:Date:From;
        b=tkuxfUGTsAnlQnVXETa6pY3Z41LDlnQtIejHByGgOhmKv8yKylttARggxpE3BPBwB
         bqd4+JMM3YegdpIOJf6sUSkKrj12MqpH1ynrtFuiv+orrqh8i4ugz0qjFoTcFcMtlt
         sp4erF+4chd9lXYmGouFA6B8ZqnP0kwHnktU844RpvyRcXhs4MMpwzNN6X4FD+QT+B
         BJoTb4554qU+RPIGJ3Ska36VepAfOKIuE9eykTTT3IVEiCxMpEZ+g9lYJA310/OUHi
         nteB0RJqPMg7ZZiIQ4GyDceAGcIn06RVXCZnVev0UQYUs8ycyjyOZZPDloy8hkcQJG
         9LJP0CQp0VFlQ==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com
Subject: [PATCH 0/6] ceph: better error handling for failed async creates
Date:   Wed,  8 Sep 2021 09:03:30 -0400
Message-Id: <20210908130336.56668-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

We've had an ongoing problem with hung umounts in teuthology, the start
of which seems to coincide with us starting to test "-o nowsync" more
regularly. Recently, we were able to get better debug output, and saw
that in at least one case, the issue was that the MDS started returning
-ENOSPC on an async create attempt, which left the client trying to
flush caps for an inode that never existed.

This patchset adds a new mechanism for "shutting down" inodes after the
fact. If an async create fails, we already d_drop the dentry associated
with it. This situation in this case is somewhat similar to the case
where we have dirty inodes at forced umount time, so the idea is to
extend the infrastructure that handles that case to also handle inodes
that failed create too.

There are also some cleanup/bugfix patches in here. This was tested
using a fault injection patch on the MDS that makes it start rejecting
openc calls with -ENOSPC.

Jeff Layton (6):
  ceph: print inode numbers instead of pointer values
  ceph: don't use -ESTALE as special return code in try_get_cap_refs
  ceph: drop private list from remove_session_caps_cb
  ceph: fix auth cap handling logic in remove_session_caps_cb
  ceph: refactor remove_session_caps_cb
  ceph: shut down access to inode when async create fails

 fs/ceph/addr.c       |  16 +++--
 fs/ceph/caps.c       | 150 ++++++++++++++++++++++++++++++++++++++-----
 fs/ceph/export.c     |  12 +++-
 fs/ceph/file.c       |  12 +++-
 fs/ceph/inode.c      |  39 +++++++++--
 fs/ceph/locks.c      |   6 ++
 fs/ceph/mds_client.c | 112 +-------------------------------
 fs/ceph/super.h      |  12 ++++
 8 files changed, 220 insertions(+), 139 deletions(-)

-- 
2.31.1

