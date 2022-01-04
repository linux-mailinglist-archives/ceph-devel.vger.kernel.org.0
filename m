Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 877484842F4
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jan 2022 15:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbiADOEe (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 4 Jan 2022 09:04:34 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49598 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232505AbiADOEb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 4 Jan 2022 09:04:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A04C361466
        for <ceph-devel@vger.kernel.org>; Tue,  4 Jan 2022 14:04:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DDF6C36AE9;
        Tue,  4 Jan 2022 14:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641305070;
        bh=xU/jNIZycr76+baXizyRvQE4Hw9NeJINxpePo1NqU/k=;
        h=From:To:Cc:Subject:Date:From;
        b=tDhIh3mvON+NuhYMZ7HbKXq7dJgsIk0eROdBSfCiQ8NV56mgoKGpj9fJ+Z1HircrR
         1By6W9RcCwKsiPLo21nWAduM0Mfa8rAhSjuMv4qcJqnp4UbymvZUjVuBI9ETrxNN6L
         DLIuZN7IJRUmAU3H4+oISPPAN0U/ajAofoKJjpvXidxW/z/OCQyDk9FipMT8W6gkxZ
         Ov/IvvBwNxEjDiKIl2Wt8SOT6m5ZUxrU0GKBDjWHzSPWIa4t1l6JKdY/O344zwJQia
         i12NMQjcCekP4zhmCD6drg9oOFTubZ3/vnSvJRb3kWlriHu86ZM16wzIUz8d8ffn8a
         Dm23NX+k5VOXA==
From:   Christian Brauner <brauner@kernel.org>
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     Ilya Dryomov <idryomov@gmail.com>, Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 00/12] ceph: support idmapped mounts
Date:   Tue,  4 Jan 2022 15:04:02 +0100
Message-Id: <20220104140414.155198-1-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2777; h=from:subject; bh=GLJJPj4oHnUihgUsdrzYCkLQic2yIDoosZBtamSf0nQ=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSReCV5vu8LlcL4/x7096+6HtYSfuvTOZrGuQl7/7sffjX8Y hX1a2FHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRK2IMf/jTuwzm2v2s7iyPLXh7Ib NgT9eU8rR7Bv9SXlZHvZrbcp7hf6bjjer1DUlzJtyZdmvakaOdVUxrRTN+FX7xCNL+zS/OwQYA
X-Developer-Key: i=christian.brauner@ubuntu.com; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

Hey everyone,

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

The patch series is on top of my patches scheduled for v5.17. The
easiest way is to either fetch the branch (fs.idmapped.ceph.v1) or the
tag (tag.fs.idmapped.ceph.v1):

git fetch git://git.kernel.org/pub/scm/linux/kernel/git/brauner/linux.git fs.idmapped.ceph.v1
git fetch git://git.kernel.org/pub/scm/linux/kernel/git/brauner/linux.git tag.fs.idmapped.ceph.v1

Thanks!
Christian

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

 fs/ceph/acl.c        |  2 +-
 fs/ceph/dir.c        |  4 ++++
 fs/ceph/file.c       | 16 ++++++++++++----
 fs/ceph/inode.c      | 15 +++++++++++----
 fs/ceph/mds_client.c | 29 +++++++++++++++++++++++++----
 fs/ceph/mds_client.h |  1 +
 fs/ceph/super.c      |  2 +-
 7 files changed, 55 insertions(+), 14 deletions(-)

-- 
2.32.0

