Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C729076EB74
	for <lists+ceph-devel@lfdr.de>; Thu,  3 Aug 2023 16:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235982AbjHCOAn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 3 Aug 2023 10:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236095AbjHCOAk (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 3 Aug 2023 10:00:40 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 854BB18B
        for <ceph-devel@vger.kernel.org>; Thu,  3 Aug 2023 07:00:12 -0700 (PDT)
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com [209.85.167.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 890703F10A
        for <ceph-devel@vger.kernel.org>; Thu,  3 Aug 2023 14:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1691071207;
        bh=t6MAEnkLNoqCWvA//rvU7/fbBIS7okN0fLCpk1ITROc=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=sokkyODjNvFdPpzyMvCBd8b+8Cvln1zppWD9EJjcyNDUC5uBZo5HnRdch8BPMcOhr
         0eViiEs51KJhNXat7scGJS2Sqkh8cZ0pD6/NPY8LQC7MVfJUd6WMn4Xnm50BImOfVG
         Q0j2f/F5PPop3QAU4nD6sLPWja/kVT50D5RmdH9I0g68gaOeXDGFzSl4z6x6gSBFI/
         lEnm2JRxgVrV5JAOCdF7yfwHmLdmb8V2pT+rMjYeXQcTm8HFMTv7qj97z0Aaoqomyy
         B5HM4XUxx25nODLWgd2tSTv8rW2covL3R9Z4jzGWvH/vGkJ0fg1Z+/g008sg3pD1qo
         rqhEnf4s0C82g==
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-4fe45da7815so964412e87.2
        for <ceph-devel@vger.kernel.org>; Thu, 03 Aug 2023 07:00:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691071206; x=1691676006;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t6MAEnkLNoqCWvA//rvU7/fbBIS7okN0fLCpk1ITROc=;
        b=PxZB/kpE0AILvzpSzefFIwORRM2gr+Ar6SR1Cwp/S9om33ivuctiSIlvPxRqmOvDa3
         sXxb0tU5UIsUMygStYgkfqlYLFYVu10p64jP+iveZMwydna5RTLOPyNAUuKee/Zl/aNX
         k3rQr0+9c0/IJVdT4l2lqwOdP8FE+eXPtMfcRapOWJk7br7B0Ymql/Zve2PKVebLiRwS
         vQXZ768dcGtTrzNtJ8PSbHoGZZHzZBJOIS1UK4zyKtBId6knvzeQfEu8qMQP2Rlv9fu7
         hw9mhnYG3YBRuJGV/5n6SzAzpr3NFFn9mkEsbznG7vEI6hE8BR1LIPxfYR1yjBKUGNj5
         2LLw==
X-Gm-Message-State: ABy/qLZ0kIJ2hpe7vlpG3mSWTsx9l8eQmpm16jqgpMICi60dZudRhvCv
        Hf/4BVGj7LW/0RvUjtAcNzp0675RRmLVbI3AE/4T0uDWtGh/XJrIKMxpzGycEHuwGUEe0fijkjn
        x3FdflKqOjESqkP0B8EQIsxyP0EyLFIi7V2+meDw=
X-Received: by 2002:a05:6512:214a:b0:4f8:631b:bf77 with SMTP id s10-20020a056512214a00b004f8631bbf77mr6915324lfr.22.1691071206005;
        Thu, 03 Aug 2023 07:00:06 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHMCkQkeYt1iqNbes+4OZlfACmQ7Qp6V7UJhWnzAbauWF0bu2sJnZMq1P/BypKnkakeK06qVg==
X-Received: by 2002:a05:6512:214a:b0:4f8:631b:bf77 with SMTP id s10-20020a056512214a00b004f8631bbf77mr6915300lfr.22.1691071205601;
        Thu, 03 Aug 2023 07:00:05 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-088-066-182-192.088.066.pools.vodafone-ip.de. [88.66.182.192])
        by smtp.gmail.com with ESMTPSA id bc21-20020a056402205500b0052229882fb0sm10114822edb.71.2023.08.03.07.00.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 07:00:04 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v8 00/12] ceph: support idmapped mounts
Date:   Thu,  3 Aug 2023 15:59:43 +0200
Message-Id: <20230803135955.230449-1-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
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

Git tree (based on https://github.com/ceph/ceph-client.git testing):
v7: https://github.com/mihalicyn/linux/commits/fs.idmapped.ceph.v7
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
 fs/ceph/dir.c                 |  3 ++
 fs/ceph/file.c                | 10 ++++-
 fs/ceph/inode.c               | 29 +++++++++------
 fs/ceph/mds_client.c          | 69 ++++++++++++++++++++++++++++++++---
 fs/ceph/mds_client.h          |  8 +++-
 fs/ceph/super.c               |  7 +++-
 fs/ceph/super.h               |  3 +-
 fs/mnt_idmapping.c            |  2 +
 include/linux/ceph/ceph_fs.h  |  4 +-
 include/linux/mnt_idmapping.h |  3 ++
 12 files changed, 119 insertions(+), 27 deletions(-)

-- 
2.34.1

