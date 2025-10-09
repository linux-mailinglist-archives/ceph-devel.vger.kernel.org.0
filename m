Return-Path: <ceph-devel+bounces-3792-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id CFCFFBC7D83
	for <lists+ceph-devel@lfdr.de>; Thu, 09 Oct 2025 09:59:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3D29C4F5FE3
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Oct 2025 07:59:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 111392D193C;
	Thu,  9 Oct 2025 07:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mIb5BFDa"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4ECC2D0C7F
	for <ceph-devel@vger.kernel.org>; Thu,  9 Oct 2025 07:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759996782; cv=none; b=qnLqkEp4c9xFGZrmmLejHi1r2vYJ/Hb/rlRGM7ElW4HLkPg+FNwRkQerGwHxBetViOHgJG9gC3WVbQeHU/PI/Ym1Q4h7k0pxuMhyWLQXKYKEqQoQgui9dY9rRQ17AcaYMT9jc8Ozltko42VKGcFQYxdgMMKFOSr36oyq3+Hrtv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759996782; c=relaxed/simple;
	bh=8KM3XRYIjTwuzpr/lrxk58FYUfQaYzmfu1nCUPuKAcs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=F6gI90hFTcu2kcayzoeAXxJpllRLoR7/sJw8JN/zZZhuw0NoGPESeHwiYC9lJp57rhf8Hv9bDAJVAzcjgET9rqZgy1NUvs+TY9Lj8sgtldDQD9hXiRwH8/Soesmy4iQT/pa1mfpqEiI9nfbf7kmR0m7caZQfhDBPKr4AGjWGL/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mIb5BFDa; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b00a9989633so1856566b.0
        for <ceph-devel@vger.kernel.org>; Thu, 09 Oct 2025 00:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759996779; x=1760601579; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BDY30uCLUAl+2ZHS218rVwJb7fqTgFel4NJt/414PVE=;
        b=mIb5BFDa9XEUY2p+dX0mZuwiC7p+bKlkOfIsY7J6EO3dkqkqvUqxcipp2wNkgV5X3g
         e4RXNLgqzNayaZEzz0pLQqFQbg3iJZ07pQmHVfyq4lo059IJjIzAkYXW14HWSD1oX/i7
         m0urz2YXugkfEkx4YQAuug91RXH+6kmuXMiV+JI82ArveWpfA5auetoFj7GMM+Ojivac
         jEtp6K4w9Nsv46zeScoS/fXRcodhhh79GOT2Fve5VNTnMGs74ksO0tfOKOjA0JhbxhA9
         OQ75og3vdRvPzxCYMCx5doiB/8X0KPW3DH+4pMBeFl9XzPVcO7PBWD7zx8lUGLpsesDo
         D4Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759996779; x=1760601579;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BDY30uCLUAl+2ZHS218rVwJb7fqTgFel4NJt/414PVE=;
        b=YvN7aQE962kYkLVgK3NBdp1kn4A0gaNPZcnowwG2fy8tsKMJgdGYSHNel1dL6V3Kas
         Il1T1VrWlymNwpnDKLSjz/WaRABVDB0we1KvakHRzvge9ExadG3xwiaNWiBjFMYiskiH
         ynjZCauk6t0a4xGxwc1K3eAWJCLC1S1S5Jeudad71oISOvAzehGoKyz3gqJ9NFeuKPGc
         lCzFoqJDhjRrkfi7RZCj7IMyzvalYrKHFAMAkbwjzkGHc3DV8l3HvEpAqFqTIuxeBUHf
         n6aAcjNAvpJXBU5dZmjDKiQVjAS3q3n6YFZIZutMkS1Niohw0jWr2mnIXRWV1uquYc7R
         OADA==
X-Forwarded-Encrypted: i=1; AJvYcCWcqfin+oQRCJgweTbl5ZO9HzACA8TAybfLABM8/iPw15wL4NtwySwukfOY4i5Bschlmu812nhuDwDJ@vger.kernel.org
X-Gm-Message-State: AOJu0YxtrwV8IvUGbsmePiAF8dfgsecmDHrwtHBXEHybOS1VRQyNWHMH
	AXmx71rWsAneB54o0Atj0abqbTGljC6+lirOILgA+6w0Mvkg2UdA1x03
X-Gm-Gg: ASbGnctIYhf4ILFkc7q3xGMkOD2gEgLyVHG0iu6rjUm+Xuf8/VzPdJTxSh9D7X9sSta
	vtAmtSPVKtXrSmdCb9Li+r7hspxCAtm3Okp0Rj3nA3cbbnIhueoqq6cpDH7s38Lmj54WrV3DYQE
	Xe4Ep9G+v2O8bBbVD9in9UZLXlWMyh+SoA+bQRn3sRN6pNHewYd5+oSQ0MNlqgJ08grHwnMIcyY
	GOdhTBGqFQV6Dg3SW+nK+g4adiCshfqPJynVzk4lGDHKpFnjgdRdXxL/y4Emp9vyufUJbtZZ8SD
	/qT49/kORrAI9MiIWS8zKfIXq55+h2ca65KWc5fxoE/qRjDeME/k30QQMl1df+7TpFA1tx1Hnmr
	phVyvKsWsMYPUPVU06bytCQj23BHuKtPEw6T0C45E8YK5aLmhItDvi864D4D96x3nDVh17yltuy
	9iDoLCFEaKNrvdrYMvk186wQ==
X-Google-Smtp-Source: AGHT+IGCRoblKt0f/ND3yZrgi//Fmws8IyMEBWOboU8aP0sv4OpoASXW7HqSnMRjLZtNQA8UxsxpIw==
X-Received: by 2002:a17:906:794b:b0:b41:8ad3:1b5c with SMTP id a640c23a62f3a-b50bd23ebebmr891429166b.13.1759996778537;
        Thu, 09 Oct 2025 00:59:38 -0700 (PDT)
Received: from f.. (cst-prg-66-155.cust.vodafone.cz. [46.135.66.155])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b5007639379sm553509366b.48.2025.10.09.00.59.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 00:59:37 -0700 (PDT)
From: Mateusz Guzik <mjguzik@gmail.com>
To: brauner@kernel.org
Cc: viro@zeniv.linux.org.uk,
	jack@suse.cz,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	josef@toxicpanda.com,
	kernel-team@fb.com,
	amir73il@gmail.com,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: [PATCH v7 00/14] hide ->i_state behind accessors
Date: Thu,  9 Oct 2025 09:59:14 +0200
Message-ID: <20251009075929.1203950-1-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit message from the patch adding helpers quoted verbatim with rationable + API:

[quote]
Open-coded accesses prevent asserting they are done correctly. One
obvious aspect is locking, but significantly more can checked. For
example it can be detected when the code is clearing flags which are
already missing, or is setting flags when it is illegal (e.g., I_FREEING
when ->i_count > 0).

In order to keep things manageable this patchset merely gets the thing
off the ground with only lockdep checks baked in.

Current consumers can be trivially converted.

Suppose flags I_A and I_B are to be handled.

If ->i_lock is held, then:

state = inode->i_state          => state = inode_state_read(inode)
inode->i_state |= (I_A | I_B)   => inode_state_set(inode, I_A | I_B)
inode->i_state &= ~(I_A | I_B)  => inode_state_clear(inode, I_A | I_B)
inode->i_state = I_A | I_B      => inode_state_assign(inode, I_A | I_B)

If ->i_lock is not held or only held conditionally:

state = inode->i_state          => state = inode_state_read_once(inode)
inode->i_state |= (I_A | I_B)   => inode_state_set_raw(inode, I_A | I_B)
inode->i_state &= ~(I_A | I_B)  => inode_state_clear_raw(inode, I_A | I_B)
inode->i_state = I_A | I_B      => inode_state_assign_raw(inode, I_A | I_B)

The "_once" vs "_raw" discrepancy stems from the read variant differing
by READ_ONCE as opposed to just lockdep checks.

Finally, if you want to atomically clear flags and set new ones, the
following:

state = inode->i_state;
state &= ~I_A;
state |= I_B;
inode->i_state = state;

turns into:

inode_state_replace(inode, I_A, I_B);
[/quote]

In order to manage bisectability vs total patch count, I decided to only
split out fs conversion if manual intervention went beyond altering
inode_state_read into inode_state_read_once in a place or two.

Almost all places were patched by coccinelle generating a variant
requesting a lock, then patched up to use variants which don't expect
one as needed. Or to put it differently, if there is fallout, it should
be just lockdep complaining.

NOTES ON MERGING:

v6 got acked by Jan Kara and Dave Chinner. Given the extent of changes
made in v7 I decided to *not* add their ACKs.

More importantly though, this is generated against:
https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git/log/?h=vfs-6.19.inode

but that branch happens to be significantly lagging behind master,
notably it does not include some writeback changes and bcachefs removal.
Thus before generating the patchset I did a rebase on master.

Top commit at the time:
commit ec714e371f22f716a04e6ecb2a24988c92b26911 (origin/master, origin/HEAD, master)
Merge: 37bfdbc11b24 f3b601f90090
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Oct 8 19:24:24 2025 -0700

    Merge tag 'perf-tools-for-v6.18-1-2025-10-08' of git://git.kernel.org/pub/scm/linux/kernel/git/perf/perf-tools

v7:
- move wait_on_inode() to fs.h
- restructure the patchset a little bit
- add inode_state_replace()
- bring back lockdep now that the merge window was missed

v6:
- rename routines:
set -> assign; add -> set; del -> clear
- update commentary in patch 3 replacing smp_store/load with smp_wmb/rmb

v5:
- drop lockdep for the time being

v4:
https://lore.kernel.org/linux-fsdevel/CAGudoHFViBUZ4TPNuLWC7qyK0v8LRwxbpZd9Mx3rHdh5GW9CrQ@mail.gmail.com/T/#m866b3b5740691de9b4008184a9a3f922dfa8e439

Mateusz Guzik (14):
  fs: move wait_on_inode() from writeback.h to fs.h
  fs: spell out fenced ->i_state accesses with explicit smp_wmb/smp_rmb
  fs: provide accessors for ->i_state
  Coccinelle-based conversion to use ->i_state accessors
  Manual conversion to use ->i_state accessors of all places not covered
    by coccinelle
  btrfs: use the new ->i_state accessors
  ceph: use the new ->i_state accessors
  smb: use the new ->i_state accessors
  f2fs: use the new ->i_state accessors
  gfs2: use the new ->i_state accessors
  overlayfs: use the new ->i_state accessors
  nilfs2: use the new ->i_state accessors
  xfs: use the new ->i_state accessors
  fs: make plain ->i_state access fail to compile

 Documentation/filesystems/porting.rst |   2 +-
 block/bdev.c                          |   4 +-
 drivers/dax/super.c                   |   2 +-
 fs/9p/vfs_inode.c                     |   2 +-
 fs/9p/vfs_inode_dotl.c                |   2 +-
 fs/affs/inode.c                       |   2 +-
 fs/afs/dynroot.c                      |   6 +-
 fs/afs/inode.c                        |   8 +-
 fs/befs/linuxvfs.c                    |   2 +-
 fs/bfs/inode.c                        |   2 +-
 fs/btrfs/inode.c                      |  10 +--
 fs/buffer.c                           |   4 +-
 fs/ceph/cache.c                       |   2 +-
 fs/ceph/crypto.c                      |   4 +-
 fs/ceph/file.c                        |   4 +-
 fs/ceph/inode.c                       |  28 +++---
 fs/coda/cnode.c                       |   4 +-
 fs/cramfs/inode.c                     |   2 +-
 fs/crypto/keyring.c                   |   2 +-
 fs/crypto/keysetup.c                  |   2 +-
 fs/dcache.c                           |   8 +-
 fs/drop_caches.c                      |   2 +-
 fs/ecryptfs/inode.c                   |   6 +-
 fs/efs/inode.c                        |   2 +-
 fs/erofs/inode.c                      |   2 +-
 fs/ext2/inode.c                       |   2 +-
 fs/ext4/inode.c                       |  10 +--
 fs/ext4/orphan.c                      |   4 +-
 fs/f2fs/data.c                        |   2 +-
 fs/f2fs/inode.c                       |   2 +-
 fs/f2fs/namei.c                       |   4 +-
 fs/f2fs/super.c                       |   2 +-
 fs/freevxfs/vxfs_inode.c              |   2 +-
 fs/fs-writeback.c                     | 123 +++++++++++++-------------
 fs/fuse/inode.c                       |   4 +-
 fs/gfs2/file.c                        |   2 +-
 fs/gfs2/glops.c                       |   2 +-
 fs/gfs2/inode.c                       |   4 +-
 fs/gfs2/ops_fstype.c                  |   2 +-
 fs/hfs/btree.c                        |   2 +-
 fs/hfs/inode.c                        |   2 +-
 fs/hfsplus/super.c                    |   2 +-
 fs/hostfs/hostfs_kern.c               |   2 +-
 fs/hpfs/dir.c                         |   2 +-
 fs/hpfs/inode.c                       |   2 +-
 fs/inode.c                            | 106 +++++++++++-----------
 fs/isofs/inode.c                      |   2 +-
 fs/jffs2/fs.c                         |   4 +-
 fs/jfs/file.c                         |   4 +-
 fs/jfs/inode.c                        |   2 +-
 fs/jfs/jfs_txnmgr.c                   |   2 +-
 fs/kernfs/inode.c                     |   2 +-
 fs/libfs.c                            |   6 +-
 fs/minix/inode.c                      |   2 +-
 fs/namei.c                            |   8 +-
 fs/netfs/misc.c                       |   8 +-
 fs/netfs/read_single.c                |   6 +-
 fs/nfs/inode.c                        |   2 +-
 fs/nfs/pnfs.c                         |   2 +-
 fs/nfsd/vfs.c                         |   2 +-
 fs/nilfs2/cpfile.c                    |   2 +-
 fs/nilfs2/dat.c                       |   2 +-
 fs/nilfs2/ifile.c                     |   2 +-
 fs/nilfs2/inode.c                     |  10 +--
 fs/nilfs2/sufile.c                    |   2 +-
 fs/notify/fsnotify.c                  |   2 +-
 fs/ntfs3/inode.c                      |   2 +-
 fs/ocfs2/dlmglue.c                    |   2 +-
 fs/ocfs2/inode.c                      |   4 +-
 fs/omfs/inode.c                       |   2 +-
 fs/openpromfs/inode.c                 |   2 +-
 fs/orangefs/inode.c                   |   2 +-
 fs/orangefs/orangefs-utils.c          |   6 +-
 fs/overlayfs/dir.c                    |   2 +-
 fs/overlayfs/inode.c                  |   6 +-
 fs/overlayfs/util.c                   |  10 +--
 fs/pipe.c                             |   2 +-
 fs/qnx4/inode.c                       |   2 +-
 fs/qnx6/inode.c                       |   2 +-
 fs/quota/dquot.c                      |   2 +-
 fs/romfs/super.c                      |   2 +-
 fs/smb/client/cifsfs.c                |   2 +-
 fs/smb/client/inode.c                 |  14 +--
 fs/squashfs/inode.c                   |   2 +-
 fs/sync.c                             |   2 +-
 fs/ubifs/file.c                       |   2 +-
 fs/ubifs/super.c                      |   2 +-
 fs/udf/inode.c                        |   2 +-
 fs/ufs/inode.c                        |   2 +-
 fs/xfs/scrub/common.c                 |   2 +-
 fs/xfs/scrub/inode_repair.c           |   2 +-
 fs/xfs/scrub/parent.c                 |   2 +-
 fs/xfs/xfs_bmap_util.c                |   2 +-
 fs/xfs/xfs_health.c                   |   4 +-
 fs/xfs/xfs_icache.c                   |   6 +-
 fs/xfs/xfs_inode.c                    |   6 +-
 fs/xfs/xfs_inode_item.c               |   4 +-
 fs/xfs/xfs_iops.c                     |   2 +-
 fs/xfs/xfs_reflink.h                  |   2 +-
 fs/zonefs/super.c                     |   4 +-
 include/linux/backing-dev.h           |   5 +-
 include/linux/fs.h                    |  99 ++++++++++++++++++++-
 include/linux/writeback.h             |  13 +--
 include/trace/events/writeback.h      |   8 +-
 mm/backing-dev.c                      |   2 +-
 security/landlock/fs.c                |   2 +-
 106 files changed, 395 insertions(+), 315 deletions(-)

-- 
2.34.1


