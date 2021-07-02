Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4B923B9C51
	for <lists+ceph-devel@lfdr.de>; Fri,  2 Jul 2021 08:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbhGBGvD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 2 Jul 2021 02:51:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22698 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229975AbhGBGvD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 2 Jul 2021 02:51:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625208511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=CPT/34s5Ew51AmhkmbZyonEaC5m6KkKnDDhTeD1BRtY=;
        b=fSniX6g5GWcbIrohcFsNGxm5NjNlWr0FCUzmoGl7Cay7uHJXs7Z+xc0vXogLIEQcINWRk6
        +fDK3eBH7fcKw4IXWzn6OxrngUlucQSjzZXTdgNnZM7XMDQbY+QyfHhGjd/MblJtawvKz9
        Ht8RPSu4LujC4l8JlxMepeVbMFu4H+E=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-576-zEysrDJjNyew_BD6BkpLnA-1; Fri, 02 Jul 2021 02:48:30 -0400
X-MC-Unique: zEysrDJjNyew_BD6BkpLnA-1
Received: by mail-pf1-f198.google.com with SMTP id t17-20020a62ea110000b029030fd2a30515so5426718pfh.20
        for <ceph-devel@vger.kernel.org>; Thu, 01 Jul 2021 23:48:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CPT/34s5Ew51AmhkmbZyonEaC5m6KkKnDDhTeD1BRtY=;
        b=ax7GxrP9bISgAYct2VDnKAKBeBubphkYHTf5wPvJh+GES86WHsiG2Q2YW0mLtluIzF
         m9fdDw9GvX315pfUx/2RP2jB0QoeJ188AJBXTcKhvszmW9TizhNQdAMUJfvBBn0UL6JR
         OM6ONSMYS2LxowrzOGTI1gWLelhQ934ZEwzSynO+qzfzA7RCobPoX/+H6nNoKro8uWMU
         WPw4m19mzk4FjAM/QMVlae8bJX+CSTyzEg8q5bGB7XLvc2Y8PTQYYoPHeKqxkVfiFmSl
         jdi/0GbnpdAG4Oom0m8ht1ubAJrRR/8JkmE+AbWl3pXyKhyAPRHtf3vkrOjhtRRcj0xl
         GVbg==
X-Gm-Message-State: AOAM533O183UJC2f8cFx4BnN3gzh7fjLXStST3GJCxX26uZKuKH0mU2M
        MCpMQYBdrv2+3UEQ3VFDMz/wF0NZQYaREtwQekzTl8pBoHRalB3+cCJgln/zTDrFfR0HmWNtvbo
        HDQy9ehkSmSuSGR/BvVS6yA==
X-Received: by 2002:a17:90a:3ccf:: with SMTP id k15mr3518595pjd.226.1625208509322;
        Thu, 01 Jul 2021 23:48:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJysBQYuVrgDzDneJ33vizAVPtIEmNS1LxULql65F5LHU+x/1Qgv91qO6EzesmEPdlB54mj7MA==
X-Received: by 2002:a17:90a:3ccf:: with SMTP id k15mr3518582pjd.226.1625208509160;
        Thu, 01 Jul 2021 23:48:29 -0700 (PDT)
Received: from localhost.localdomain ([49.207.212.118])
        by smtp.gmail.com with ESMTPSA id o34sm2394364pgm.6.2021.07.01.23.48.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 23:48:28 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, idryomov@gmail.com, lhenriques@suse.de
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Venky Shankar <vshankar@redhat.com>
Subject: [PATCH v2 0/4] ceph: new mount device syntax
Date:   Fri,  2 Jul 2021 12:18:17 +0530
Message-Id: <20210702064821.148063-1-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

v2:
 - doc suggestions/fixes by Jeff
 - parse_fsid -> ceph_parse_fsid
 - avoid kstrdup whereever possible, also fixes a memleak
 - fail mount when mon_addr is unavailable (for new syntax)
 - use dout() instead of invalfc() during new syntax check

This series introduces changes Ceph File System mount device string.
Old mount device syntax (source) has the following problems:

mounts to the same cluster but with different fsnames
and/or creds have identical device string which can
confuse xfstests.

Userspace mount helper tool resolves monitor addresses
and fill in mon addrs automatically, but that means the
device shown in /proc/mounts is different than what was
used for mounting.

New device syntax is as follows:

  cephuser@fsid.mycephfs2=/path

Note, there is no "monitor address" in the device string.
That gets passed in as mount option. This keeps the device
string same when monitor addresses change (on remounts).

Also note that the userspace mount helper tool is backward
compatible. I.e., the mount helper will fallback to using
old syntax after trying to mount with the new syntax.

Venky Shankar (4):
  ceph: new device mount syntax
  ceph: validate cluster FSID for new device syntax
  ceph: record updated mon_addr on remount
  doc: document new CephFS mount device syntax

 Documentation/filesystems/ceph.rst |  25 +++++-
 fs/ceph/super.c                    | 137 ++++++++++++++++++++++++++---
 fs/ceph/super.h                    |   4 +
 include/linux/ceph/libceph.h       |   1 +
 net/ceph/ceph_common.c             |   5 +-
 5 files changed, 157 insertions(+), 15 deletions(-)

-- 
2.27.0

