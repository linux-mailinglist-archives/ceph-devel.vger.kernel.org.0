Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC7270FA3C
	for <lists+ceph-devel@lfdr.de>; Wed, 24 May 2023 17:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235851AbjEXPej (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 24 May 2023 11:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233455AbjEXPef (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 24 May 2023 11:34:35 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6978135
        for <ceph-devel@vger.kernel.org>; Wed, 24 May 2023 08:34:10 -0700 (PDT)
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 9A48A3F189
        for <ceph-devel@vger.kernel.org>; Wed, 24 May 2023 15:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1684942430;
        bh=EWhp3bFE5YGNYZTeqnLuyw/BwJKRfP8fBMMP2Kg8LVA=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=CAjO2sTzn/pC/n8wkfnTaCEnfgEqjyibCGDy8xPg64gA1a48Ar3UwrbpzaqrdzFy1
         oUyIYE47N7LMp1IpsEUqrnceNWU7Fz5wQPmQcinMCrdt6ZyKvTXk/ItF/64F6cp4ug
         VpS9yn7cLq7kEAv1VLDF/r48tJFfjLJ3CUF/uwDwHklZzeAQNVfNb+z/fR69lvdz2E
         1FsXzylHHU5bq8eyxLbeNqewRVSZRVaH4NB73J+sM9NiNIq+39+/luLbOknMeYwjYj
         RdYb8DOLge6fsQuUB/beDPeqhDNKm+zfFR5/JzYf1pcngtFPtdhhOVzsZB1lknw8mX
         znkN3rM2ZN+vw==
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-96f83b44939so108109266b.1
        for <ceph-devel@vger.kernel.org>; Wed, 24 May 2023 08:33:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684942429; x=1687534429;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EWhp3bFE5YGNYZTeqnLuyw/BwJKRfP8fBMMP2Kg8LVA=;
        b=OXE8XIZ9tjrZOYwf1E3EbsZCIyT23BzW+ver6onPLWjxbFHyABeh4UZxuPvITVrEBK
         yTsMriVfVpWRZiq9vSge5nKs9/7gVQoqex4XZcwCh54xxblZ8aOnmQHHsrHCA4caspVC
         bH0c6wuMF3ZJN9zJj6TIN01nhJwCRuXPGdVfPFhFnUiCNRdY3WpZnxukFMBJn2AG0bDW
         lxJAPP9kO309lxVZs6o4kDSrpr+71RV6Z/g/Aqhcmqk10s0i5chBXgioJcGGQT+j8nwQ
         xAB7gCvYEyDbToiNa8kziuM4yn/DaSPOX3ueqW0o5rgNfORMLw3s70jLAbxZ1h2zpr1F
         Rfpw==
X-Gm-Message-State: AC+VfDzlGYU+QUQa//JmW5Xkwu76vGHJgfwPAScYImLpRfqS2H7XnFQu
        s5x9Vlx6KZL1MCatFY0eVoBb7FVrob8BM2HZA+3R63MTuMfYq+FYfxt8EoXk7CVyKSd7WlBVgBG
        6i9fp58eJAJnOaLfhiiTQbqd7h573PlE+M2067WvCtPQLlxE=
X-Received: by 2002:a17:906:ee81:b0:96f:1629:3e9a with SMTP id wt1-20020a170906ee8100b0096f16293e9amr7864678ejb.34.1684942428985;
        Wed, 24 May 2023 08:33:48 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6FfHlSp740KFdG3fkWYcfhprliWqIMlIui+VfDoltbt8piUfLCsAuDVK0xOfy9qveDfEPafg==
X-Received: by 2002:a17:906:ee81:b0:96f:1629:3e9a with SMTP id wt1-20020a170906ee8100b0096f16293e9amr7864653ejb.34.1684942428590;
        Wed, 24 May 2023 08:33:48 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-088-074-206-207.088.074.pools.vodafone-ip.de. [88.74.206.207])
        by smtp.gmail.com with ESMTPSA id p26-20020a17090664da00b0096f7105b3a6sm5986979ejn.189.2023.05.24.08.33.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 08:33:48 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 00/13] ceph: support idmapped mounts
Date:   Wed, 24 May 2023 17:33:02 +0200
Message-Id: <20230524153316.476973-1-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Dear friends,

This patchset was originally developed by Christian Brauner but I'll continue
to push it forward. Christian allowed me to do that :)

This feature is already actively used/tested with LXD/LXC project.

v2 is just a rebased version of the original series with some small field naming change.

Git tree (based on https://github.com/ceph/ceph-client.git master):
https://github.com/mihalicyn/linux/tree/fs.idmapped.ceph.v2

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

Alexander Mikhalitsyn (1):
  fs: export mnt_idmap_get/mnt_idmap_put

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

 fs/ceph/acl.c                 |  2 +-
 fs/ceph/dir.c                 |  4 ++++
 fs/ceph/file.c                | 10 ++++++++--
 fs/ceph/inode.c               | 15 +++++++++++----
 fs/ceph/mds_client.c          | 29 +++++++++++++++++++++++++----
 fs/ceph/mds_client.h          |  1 +
 fs/ceph/super.c               |  2 +-
 fs/mnt_idmapping.c            |  2 ++
 include/linux/mnt_idmapping.h |  3 +++
 9 files changed, 56 insertions(+), 12 deletions(-)

-- 
2.34.1

