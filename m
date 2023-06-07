Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D338726800
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Jun 2023 20:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232474AbjFGSKi (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 7 Jun 2023 14:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230461AbjFGSKf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 7 Jun 2023 14:10:35 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80119E46
        for <ceph-devel@vger.kernel.org>; Wed,  7 Jun 2023 11:10:31 -0700 (PDT)
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 100563F166
        for <ceph-devel@vger.kernel.org>; Wed,  7 Jun 2023 18:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1686161429;
        bh=OHIZE55DRONU2M77dhxlQwcXUrc0vedFNZBupvTYJA8=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=Th2M6SrMZucEpfnTH71I81TQWrSOpNWFimS9QRHY78U4vJ8r2aeL+D/dFvvXx+F3r
         UwJZx0+b8+0RE5Djnc32Hj4Mtj6nYTA73JlP88IZp5e03494dPempiINw6MPYpH/1G
         mVZlmBTEg8UlA9G6X/i+awTvyKmjWl086ko1JndwoI22x8wQrY2rt33GuZhYdP9HsI
         bnPrN8O1Ug51tn3HBTfnjomSj4URRGntjRB0H2dIeaTxSSDKO1++VViE6yzg0CiZS+
         RTAlIgUJhpRhOcORUa8FzOcoosjDvYXL7dkemqIkoZHCIAq0+g3+BNXAk7brUiE9EU
         cToYkHtzHLbFQ==
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-97467e06580so610435666b.1
        for <ceph-devel@vger.kernel.org>; Wed, 07 Jun 2023 11:10:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686161427; x=1688753427;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OHIZE55DRONU2M77dhxlQwcXUrc0vedFNZBupvTYJA8=;
        b=aNL/7RkgBUOgkj1AEWqD3haR7D+FjeBVOwuJxf9gpQM2XFMEx6UXtTAhZON4X7BYAb
         DzSGjbtx0d93HbjREQDmhwCmiyaV/b+oGj1hNqH5tFBqQ2vVIu5H4ntKgrQCc+PxVbTQ
         VB5EUBzQZrpMMHNkNPCMCgL7Gev4olJwH3N74J0u6ghSGDPD1sAjCT4IjU5L1Q/6NdhJ
         XUFmunjP0QbLkQXEKVOV7+OR+264iXmPUQN/jrGW+KACPcS86pkwbf5+VYLddScp/f1d
         MS8hse2NOInDWN8o3QDHAb6BBp07JgJC+bYljeaYYB9j0jQ8XUD+jRz0VNA3a7ROKNP+
         A9LA==
X-Gm-Message-State: AC+VfDwlPTkkqOHYxd+THJkksYfYAlVoq4oZxDYa20yD+wt5SvpWRCdb
        kJwOnvwQJWlxpFgb9SKeFAypAzpbIDKSFVga6QBY+RqfFMh9zYIQWGIGionsqwyaJ+KUYmruAX3
        IEcWgLcThlpu5JMWJwyS1FpSoVnJIhGy5t2E3XSE3YYG7bNY=
X-Received: by 2002:a17:907:7214:b0:961:2956:2ed9 with SMTP id dr20-20020a170907721400b0096129562ed9mr7225601ejc.25.1686161427444;
        Wed, 07 Jun 2023 11:10:27 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7TzQDMnY9ZtzKPlEgYEISnubYKzZaXxCRQdVkWZzOxtVRNf+KG9DQRnjRHSU58QLBt6djIow==
X-Received: by 2002:a17:907:7214:b0:961:2956:2ed9 with SMTP id dr20-20020a170907721400b0096129562ed9mr7225583ejc.25.1686161427163;
        Wed, 07 Jun 2023 11:10:27 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-002-205-064-187.002.205.pools.vodafone-ip.de. [2.205.64.187])
        by smtp.gmail.com with ESMTPSA id oz17-20020a170906cd1100b009745edfb7cbsm7170494ejb.45.2023.06.07.11.10.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 11:10:26 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 00/14] ceph: support idmapped mounts
Date:   Wed,  7 Jun 2023 20:09:43 +0200
Message-Id: <20230607180958.645115-1-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Dear friends,

This patchset was originally developed by Christian Brauner but I'll continue
to push it forward. Christian allowed me to do that :)

This feature is already actively used/tested with LXD/LXC project.

Git tree (based on https://github.com/ceph/ceph-client.git master):
https://github.com/mihalicyn/linux/tree/fs.idmapped.ceph

In the version 3 I've changed only two commits:
- fs: export mnt_idmap_get/mnt_idmap_put
- ceph: allow idmapped setattr inode op
and added a new one:
- ceph: pass idmap to __ceph_setattr

In the version 4 I've reworked the ("ceph: stash idmapping in mdsc request")
commit. Now we take idmap refcounter just in place where req->r_mnt_idmap
is filled. It's more safer approach and prevents possible refcounter underflow
on error paths where __register_request wasn't called but ceph_mdsc_release_request is
called.

I can confirm that this version passes xfstests.

Links to previous versions:
v1: https://lore.kernel.org/all/20220104140414.155198-1-brauner@kernel.org/
v2: https://lore.kernel.org/lkml/20230524153316.476973-1-aleksandr.mikhalitsyn@canonical.com/
v3: https://lore.kernel.org/lkml/20230607152038.469739-1-aleksandr.mikhalitsyn@canonical.com/#t

Kind regards,
Alex

Original description from Christian:
========================================================================
This patch series enables cephfs to support idmapped mounts, i.e. the
ability to alter ownership information on a per-mount basis.

Container managers such as LXD support sharaing data via cephfs between
the host and unprivileged containers and between unprivileged containers.
They may all use different idmappings. Idmapped mounts can be used to
create mounts with the idmapping used for the container (or a different
one specific to the use-case).

There are in fact more use-cases such as remapping ownership for
mountpoints on the host itself to grant or restrict access to different
users or to make it possible to enforce that programs running as root
will write with a non-zero {g,u}id to disk.

The patch series is simple overall and few changes are needed to cephfs.
There is one cephfs specific issue that I would like to discuss and
solve which I explain in detail in:

[PATCH 02/12] ceph: handle idmapped mounts in create_request_message()

It has to do with how to handle mds serves which have id-based access
restrictions configured. I would ask you to please take a look at the
explanation in the aforementioned patch.

The patch series passes the vfs and idmapped mount testsuite as part of
xfstests. To run it you will need a config like:

[ceph]
export FSTYP=ceph
export TEST_DIR=/mnt/test
export TEST_DEV=10.103.182.10:6789:/
export TEST_FS_MOUNT_OPTS="-o name=admin,secret=$password

and then simply call

sudo ./check -g idmapped

========================================================================

Alexander Mikhalitsyn (2):
  fs: export mnt_idmap_get/mnt_idmap_put
  ceph: pass idmap to __ceph_setattr

Christian Brauner (12):
  ceph: stash idmapping in mdsc request
  ceph: handle idmapped mounts in create_request_message()
  ceph: allow idmapped mknod inode op
  ceph: allow idmapped symlink inode op
  ceph: allow idmapped mkdir inode op
  ceph: allow idmapped rename inode op
  ceph: allow idmapped getattr inode op
  ceph: allow idmapped permission inode op
  ceph: allow idmapped setattr inode op
  ceph/acl: allow idmapped set_acl inode op
  ceph/file: allow idmapped atomic_open inode op
  ceph: allow idmapped mounts

 fs/ceph/acl.c                 |  6 +++---
 fs/ceph/dir.c                 |  4 ++++
 fs/ceph/file.c                | 10 ++++++++--
 fs/ceph/inode.c               | 29 +++++++++++++++++------------
 fs/ceph/mds_client.c          | 27 +++++++++++++++++++++++----
 fs/ceph/mds_client.h          |  1 +
 fs/ceph/super.c               |  2 +-
 fs/ceph/super.h               |  3 ++-
 fs/mnt_idmapping.c            |  2 ++
 include/linux/mnt_idmapping.h |  3 +++
 10 files changed, 64 insertions(+), 23 deletions(-)

-- 
2.34.1

