Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09ABA7725A2
	for <lists+ceph-devel@lfdr.de>; Mon,  7 Aug 2023 15:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbjHGN2n (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 7 Aug 2023 09:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbjHGN2l (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 7 Aug 2023 09:28:41 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D1E21BDC
        for <ceph-devel@vger.kernel.org>; Mon,  7 Aug 2023 06:28:21 -0700 (PDT)
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 2A64A44275
        for <ceph-devel@vger.kernel.org>; Mon,  7 Aug 2023 13:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1691414879;
        bh=2QYRCXIE9egJt4LNBYOA/f+a+SuPW1YIlf3WwssDc/Q=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=TVP8886ccTZ/RYgsXh6qy/Gy6oMfZWMIjVEJ9jj8vhMmfYb0YtDxDh5NCDNzs/foQ
         pq7EF2fkdPmHIb+hnMkHYb8HTncOjnxD+PbrqIR1ZgsLdc7U9bnrflQkSWd21AyyEF
         uzJ0HNITBJSp8oal/jo3sWADkq6l9+UQ1u0RK4khz8J3LY6OOM8nrrqSpGvWncKRuJ
         rWo26e/ZY1ZSuOpJX0m53kqjXTmLgDQKnIOKuH5Q4cXqitnRn2Iy5fFaAE2OYNwfOl
         2CVgsjDpSp+AQKaGuc6b+KZhR3p+4ym9OEwAhbZgRMmMLd/israEGX/ewbxKQAEIX6
         QpmSkVCprV3rA==
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-94a34a0b75eso300596366b.1
        for <ceph-devel@vger.kernel.org>; Mon, 07 Aug 2023 06:27:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691414878; x=1692019678;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2QYRCXIE9egJt4LNBYOA/f+a+SuPW1YIlf3WwssDc/Q=;
        b=S7mEDq8VLw6qQ7qCG8gUYl8KXDXF7qVfFx64taumHz5fuPKe0VdE2ytPKv3Lts1cRg
         9KUiYFfk7l7lWIrH4aUBC/GoaImA9VKwfoXXRcgR8Mn0kZ1T3Ld/AYzGlRHB5M4Y6nmC
         21sSJART/GeulRTwwMxjmZW/eNXuD0EotpFA5qlOVjAuYdvdVdfK655RG92iwZjURNA1
         /N3zQZzwiVt9+9X4V2+QXhaT1zLjP97OmL4xRKK5D/zwprJZKirQnuwcWvhEzeOsqxma
         9Kac/ZqgHNO8wZ+0fus+XKkD14HX5zkdZy38yTIZv5B7PLNY8Ukl1t92MYXmQUgEe9or
         uqoA==
X-Gm-Message-State: AOJu0YzbmsPNAmoVR0Gz89RjxYctmcFtWrC2+ww0IRzOXg4olYi53jf7
        1ud5cpGlIcNmI60wFcPHbY7Oicdoi4Jyv5dkjBzDkMAo9NyYNyxjzYJSOo6VtgySGQyeZR0oaid
        lJlSLCN+fyW03IbOzyp2PTXstAztz1L9oY75guduC6EqViQ0=
X-Received: by 2002:a17:906:209c:b0:99b:5abb:8caf with SMTP id 28-20020a170906209c00b0099b5abb8cafmr8504023ejq.44.1691414878576;
        Mon, 07 Aug 2023 06:27:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFG2MQ0NouywHwul3BGS48tlDC8KJIxUyQcuJtzyIWBoeBWdcppx10iLcmdF9bi7XDvJtPXYw==
X-Received: by 2002:a17:906:209c:b0:99b:5abb:8caf with SMTP id 28-20020a170906209c00b0099b5abb8cafmr8504004ejq.44.1691414878223;
        Mon, 07 Aug 2023 06:27:58 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-088-066-182-192.088.066.pools.vodafone-ip.de. [88.66.182.192])
        by smtp.gmail.com with ESMTPSA id lg12-20020a170906f88c00b00992ca779f42sm5175257ejb.97.2023.08.07.06.27.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Aug 2023 06:27:57 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v10 00/12] ceph: support idmapped mounts
Date:   Mon,  7 Aug 2023 15:26:14 +0200
Message-Id: <20230807132626.182101-1-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Dear friends,

This patchset was originally developed by Christian Brauner but I'll continue
to push it forward. Christian allowed me to do that :)

This feature is already actively used/tested with LXD/LXC project.

Git tree (based on https://github.com/ceph/ceph-client.git testing):
v10: https://github.com/mihalicyn/linux/commits/fs.idmapped.ceph.v10
current: https://github.com/mihalicyn/linux/tree/fs.idmapped.ceph

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

Changelog for version 5:
- a few commits were squashed into one (as suggested by Xiubo Li)
- started passing an idmapping everywhere (if possible), so a caller
UID/GID-s will be mapped almost everywhere (as suggested by Xiubo Li)

Changelog for version 6:
- rebased on top of testing branch
- passed an idmapping in a few places (readdir, ceph_netfs_issue_op_inline)

Changelog for version 7:
- rebased on top of testing branch
- this thing now requires a new cephfs protocol extension CEPHFS_FEATURE_HAS_OWNER_UIDGID
https://github.com/ceph/ceph/pull/52575

Changelog for version 8:
- rebased on top of testing branch
- added enable_unsafe_idmap module parameter to make idmapped mounts
work with old MDS server versions
- properly handled case when old MDS used with new kernel client

Changelog for version 9:
- added "struct_len" field in struct ceph_mds_request_head as requested by Xiubo Li

Changelog for version 10:
- fill struct_len field properly (use cpu_to_le32)
- add extra checks IS_CEPH_MDS_OP_NEWINODE(..) as requested by Xiubo to match
  userspace client behavior
- do not set req->r_mnt_idmap for MKSNAP operation
- atomic_open: set req->r_mnt_idmap only for CEPH_MDS_OP_CREATE as userspace client does

I can confirm that this version passes xfstests and
tested with old MDS (without CEPHFS_FEATURE_HAS_OWNER_UIDGID)
and with recent MDS version.

Links to previous versions:
v1: https://lore.kernel.org/all/20220104140414.155198-1-brauner@kernel.org/
v2: https://lore.kernel.org/lkml/20230524153316.476973-1-aleksandr.mikhalitsyn@canonical.com/
tree: https://github.com/mihalicyn/linux/commits/fs.idmapped.ceph.v2
v3: https://lore.kernel.org/lkml/20230607152038.469739-1-aleksandr.mikhalitsyn@canonical.com/#t
v4: https://lore.kernel.org/lkml/20230607180958.645115-1-aleksandr.mikhalitsyn@canonical.com/#t
tree: https://github.com/mihalicyn/linux/commits/fs.idmapped.ceph.v4
v5: https://lore.kernel.org/lkml/20230608154256.562906-1-aleksandr.mikhalitsyn@canonical.com/#t
tree: https://github.com/mihalicyn/linux/commits/fs.idmapped.ceph.v5
v6: https://lore.kernel.org/lkml/20230609093125.252186-1-aleksandr.mikhalitsyn@canonical.com/
tree: https://github.com/mihalicyn/linux/commits/fs.idmapped.ceph.v6
v7: https://lore.kernel.org/all/20230726141026.307690-1-aleksandr.mikhalitsyn@canonical.com/
tree: https://github.com/mihalicyn/linux/commits/fs.idmapped.ceph.v7
v8: https://lore.kernel.org/all/20230803135955.230449-1-aleksandr.mikhalitsyn@canonical.com/
tree: -
v9: https://lore.kernel.org/all/20230804084858.126104-1-aleksandr.mikhalitsyn@canonical.com/
tree: https://github.com/mihalicyn/linux/commits/fs.idmapped.ceph.v9

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

Alexander Mikhalitsyn (3):
  fs: export mnt_idmap_get/mnt_idmap_put
  ceph: add enable_unsafe_idmap module parameter
  ceph: pass idmap to __ceph_setattr

Christian Brauner (9):
  ceph: stash idmapping in mdsc request
  ceph: handle idmapped mounts in create_request_message()
  ceph: pass an idmapping to mknod/symlink/mkdir
  ceph: allow idmapped getattr inode op
  ceph: allow idmapped permission inode op
  ceph: allow idmapped setattr inode op
  ceph/acl: allow idmapped set_acl inode op
  ceph/file: allow idmapped atomic_open inode op
  ceph: allow idmapped mounts

 fs/ceph/acl.c                 |  6 +--
 fs/ceph/crypto.c              |  2 +-
 fs/ceph/dir.c                 |  4 ++
 fs/ceph/file.c                | 11 ++++-
 fs/ceph/inode.c               | 29 +++++++------
 fs/ceph/mds_client.c          | 78 ++++++++++++++++++++++++++++++++---
 fs/ceph/mds_client.h          |  8 +++-
 fs/ceph/super.c               |  7 +++-
 fs/ceph/super.h               |  3 +-
 fs/mnt_idmapping.c            |  2 +
 include/linux/ceph/ceph_fs.h  | 10 ++++-
 include/linux/mnt_idmapping.h |  3 ++
 12 files changed, 136 insertions(+), 27 deletions(-)

-- 
2.34.1

