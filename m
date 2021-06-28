Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD77D3B5A27
	for <lists+ceph-devel@lfdr.de>; Mon, 28 Jun 2021 09:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbhF1H6W (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 28 Jun 2021 03:58:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48344 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231725AbhF1H6V (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 28 Jun 2021 03:58:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624866955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=m1+/A2py54pf+pIJbOSXnemtLQV2ZdAqfhK4Sfigjrc=;
        b=Oj0SogMe/8ylQwUJfeGs8WZPo5QSmeWmVeFtj4Ab7b4gzDWePFaCl7lc8Ndki6hLQuyoQ7
        0dacaNfhj0nw+HSEgDfY+/rZL6Nu44Mw3PqD5SyYRxVR3DrtWZGrLQml9bvBSlVIGcw1nO
        hPRdS/wRrUKxIhT5gS1s2VsMqtvJUyM=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-46-GbmnbxFeNTSCrsO_JOcIOQ-1; Mon, 28 Jun 2021 03:55:54 -0400
X-MC-Unique: GbmnbxFeNTSCrsO_JOcIOQ-1
Received: by mail-pf1-f198.google.com with SMTP id z197-20020a627ece0000b02903088fd1d830so5466446pfc.7
        for <ceph-devel@vger.kernel.org>; Mon, 28 Jun 2021 00:55:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m1+/A2py54pf+pIJbOSXnemtLQV2ZdAqfhK4Sfigjrc=;
        b=j57aKXPh0iazhnsp4TYhSGBTNzA+5jEm6NH5mqKTmKNVsa+oaYyLj9lYNf0vojC853
         xrypE+n43Jn38G19CrcpJ2V53hNspmK32FwsUXGPxkH4/M7oXhGJsnTRMRU/v2TN51l8
         yLz7E8iZ9UcahHvEXr8Lo/F6hp/3PkiyUY8uNGzpGYQyuDjDZGEaywfmR4LXpgliTcjB
         KUtS8DNYwR2iFp5ll3lPRU7i/cpcnc9pIDs3+8wuNd2EvU9gAwV4AltWupNTPG1+5oC+
         tocbvqjnmSk48Gd+tdXKvdIFA+LUdi902ALIzzPOvTL+ml3yKtQA+7QP+F5+C7DY+oee
         gmfQ==
X-Gm-Message-State: AOAM530l/rAFSgucBwwd0uZ33+zthogRnXYei9PV1sX/AlYFMl7TWQgf
        ZrLPZitg33wluTipgFmclZquAH3gDeWZSlHMJI5ZL+XmTjrEOEkd/e8vfdjE9RXKfATdUGs5Hpc
        PuN21GESekGtgkD9ftkzBKw==
X-Received: by 2002:a05:6a00:138f:b029:304:2af5:1e12 with SMTP id t15-20020a056a00138fb02903042af51e12mr23925032pfg.5.1624866953070;
        Mon, 28 Jun 2021 00:55:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxDyBssh3+iLRG6BU3nIWkQcPxseM/OPT9Ir4RkaSTZARifqDR9rA1/Qj/79TiKxrH14EFaAA==
X-Received: by 2002:a05:6a00:138f:b029:304:2af5:1e12 with SMTP id t15-20020a056a00138fb02903042af51e12mr23925012pfg.5.1624866952830;
        Mon, 28 Jun 2021 00:55:52 -0700 (PDT)
Received: from localhost.localdomain ([49.207.209.6])
        by smtp.gmail.com with ESMTPSA id g123sm8304959pfb.187.2021.06.28.00.55.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 00:55:52 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org, Venky Shankar <vshankar@redhat.com>
Subject: [PATCH 0/4] ceph: new mount device syntax
Date:   Mon, 28 Jun 2021 13:25:41 +0530
Message-Id: <20210628075545.702106-1-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

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

 Documentation/filesystems/ceph.rst |  23 ++++-
 fs/ceph/super.c                    | 132 ++++++++++++++++++++++++++---
 fs/ceph/super.h                    |   4 +
 include/linux/ceph/libceph.h       |   1 +
 net/ceph/ceph_common.c             |   3 +-
 5 files changed, 149 insertions(+), 14 deletions(-)

-- 
2.27.0

