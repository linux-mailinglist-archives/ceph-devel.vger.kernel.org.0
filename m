Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05C9B445187
	for <lists+ceph-devel@lfdr.de>; Thu,  4 Nov 2021 11:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbhKDKXE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 4 Nov 2021 06:23:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:54298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230148AbhKDKXD (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 4 Nov 2021 06:23:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4087A611C9;
        Thu,  4 Nov 2021 10:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636021225;
        bh=vAKRjo66BNxOHxUo7T32GvMr/tVjRuCl83UYlSMN5JM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=OSMkXvCgx1sBkT+SC9VKXJ7VuV+KUyD9FtHF7S6F0iocQn+uYfP6hX6TG1e+1WLI+
         Qr8pKmYWQOs1eil+8Dd1bChCN50pXfyVP2/l6Q/ODTtsqbxw0FtE53tOSrQIqam6RJ
         54zTWJ6cHeWFFYG9YAaySZ4LWl/71IFr2yMQqvhdbFlusfftVHS1WJLytB2EWhZ1vF
         udhk6KhBqEOujwnzBO8UI5eoJh3A/iHEaNM//w7pZEaxGSpXmm15eBLHHJf+6qItCe
         /w/i8XYq7TFzAXn+ZR1I68TxVaMruUpuGXeg+ioTdZyL+5A+WbliApMn6FtkbkSpqj
         lHIqKkIn0UdWA==
Message-ID: <2e0feabf7ff29708c3d2a9608041e3ca9e78acb9.camel@kernel.org>
Subject: Re: [PATCH v6 0/9] ceph: size handling for the fscrypt
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org
Date:   Thu, 04 Nov 2021 06:20:24 -0400
In-Reply-To: <eafc91dc-c423-4400-e4f9-b1e031c1d19a@redhat.com>
References: <20211104055248.190987-1-xiubli@redhat.com>
         <eafc91dc-c423-4400-e4f9-b1e031c1d19a@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.0 (3.42.0-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Thanks. I'm now seeing a MDS crash when I run that test, but my MDS
branch isn't quite up to date with yours. I'll rebuild that and re-test.

Thanks,
Jeff

On Thu, 2021-11-04 at 14:00 +0800, Xiubo Li wrote:
> The xfstests generic/014 test passed:
> 
> [root@ceph1 xfstests]# pwd
> /mnt/kcephfs/xfstests
> [root@ceph1 xfstests]# cat ./local.config
> export FSTYP=ceph
> export TEST_DEV=10.72.49.127:40084:/test
> export TEST_DIR=/mnt/kcephfs/test/_brpcfnn
> export TEST_FS_MOUNT_OPTS="-o 
> test_dummy_encryption,name=admin,secret=AQDS3IFhEtxvORAAxn1d4FVN2bRUsc/TZMpQvQ=="
> 
> [root@ceph1 xfstests]# ./check generic/014
> 
> FSTYP         -- ceph
> PLATFORM      -- Linux/x86_64 ceph1 5.15.0-rc6+
> 
> generic/014 533s ... 558s
> Ran: generic/014
> Passed all 1 tests
> 
> 
> 
> 
> On 11/4/21 1:52 PM, xiubli@redhat.com wrote:
> > From: Xiubo Li <xiubli@redhat.com>
> > 
> > This patch series is based on the "wip-fscrypt-fnames" branch in
> > repo https://github.com/ceph/ceph-client.git.
> > 
> > And I have picked up 5 patches from the "ceph-fscrypt-size-experimental"
> > branch in repo
> > https://git.kernel.org/pub/scm/linux/kernel/git/jlayton/linux.git.
> > 
> > ====
> > 
> > This approach is based on the discussion from V1 and V2, which will
> > pass the encrypted last block contents to MDS along with the truncate
> > request.
> > 
> > This will send the encrypted last block contents to MDS along with
> > the truncate request when truncating to a smaller size and at the
> > same time new size does not align to BLOCK SIZE.
> > 
> > The MDS side patch is raised in PR
> > https://github.com/ceph/ceph/pull/43588, which is also based Jeff's
> > previous great work in PR https://github.com/ceph/ceph/pull/41284.
> > 
> > The MDS will use the filer.write_trunc(), which could update and
> > truncate the file in one shot, instead of filer.truncate().
> > 
> > This just assume kclient won't support the inline data feature, which
> > will be remove soon, more detail please see:
> > https://tracker.ceph.com/issues/52916
> > 
> > 
> > Changed in V6:
> > - Fixed the file hole bug, also have updated the MDS side PR.
> > - Add add object version support for sync read in #8.
> > 
> > 
> > Changed in V5:
> > - Rebase to "wip-fscrypt-fnames" branch in ceph-client.git repo.
> > - Pick up 5 patches from Jeff's "ceph-fscrypt-size-experimental" branch
> >    in linux.git repo.
> > - Add "i_truncate_pagecache_size" member support in ceph_inode_info
> >    struct, this will be used to truncate the pagecache only in kclient
> >    side, because the "i_truncate_size" will always be aligned to BLOCK
> >    SIZE. In fscrypt case we need to use the real size to truncate the
> >    pagecache.
> > 
> > 
> > Changed in V4:
> > - Retry the truncate request by 20 times before fail it with -EAGAIN.
> > - Remove the "fill_last_block" label and move the code to else branch.
> > - Remove the #3 patch, which has already been sent out separately, in
> >    V3 series.
> > - Improve some comments in the code.
> > 
> > 
> > Changed in V3:
> > - Fix possibly corrupting the file just before the MDS acquires the
> >    xlock for FILE lock, another client has updated it.
> > - Flush the pagecache buffer before reading the last block for the
> >    when filling the truncate request.
> > - Some other minore fixes.
> > 
> > 
> > 
> > Jeff Layton (5):
> >    libceph: add CEPH_OSD_OP_ASSERT_VER support
> >    ceph: size handling for encrypted inodes in cap updates
> >    ceph: fscrypt_file field handling in MClientRequest messages
> >    ceph: get file size from fscrypt_file when present in inode traces
> >    ceph: handle fscrypt fields in cap messages from MDS
> > 
> > Xiubo Li (4):
> >    ceph: add __ceph_get_caps helper support
> >    ceph: add __ceph_sync_read helper support
> >    ceph: add object version support for sync read
> >    ceph: add truncate size handling support for fscrypt
> > 
> >   fs/ceph/caps.c                  | 136 ++++++++++++++----
> >   fs/ceph/crypto.h                |   4 +
> >   fs/ceph/dir.c                   |   3 +
> >   fs/ceph/file.c                  |  76 ++++++++--
> >   fs/ceph/inode.c                 | 243 +++++++++++++++++++++++++++++---
> >   fs/ceph/mds_client.c            |   9 +-
> >   fs/ceph/mds_client.h            |   2 +
> >   fs/ceph/super.h                 |  25 ++++
> >   include/linux/ceph/crypto.h     |  28 ++++
> >   include/linux/ceph/osd_client.h |   6 +-
> >   include/linux/ceph/rados.h      |   4 +
> >   net/ceph/osd_client.c           |   5 +
> >   12 files changed, 482 insertions(+), 59 deletions(-)
> >   create mode 100644 include/linux/ceph/crypto.h
> > 
> 

-- 
Jeff Layton <jlayton@kernel.org>
