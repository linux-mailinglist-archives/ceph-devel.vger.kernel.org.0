Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA07D446290
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Nov 2021 12:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbhKELST (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 5 Nov 2021 07:18:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:38510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232115AbhKELST (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 5 Nov 2021 07:18:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 201FA61183;
        Fri,  5 Nov 2021 11:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636110939;
        bh=rDgeZUa8GfsXgWvCCKc/ApD/1BoBwK+DokgNqmI7Op0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bR4Bxd0zex4wCeEv5Ov2skPraB3i4b2JPJrg8bhtbGcbofMd/duVoVntxlBSDzIdk
         U2v90t8RC3dIUyA5L+HnzfNlma/UtO6iXks+6xZdqgCOVROS9pHfrHNLQd+lHIiCs3
         f8kJWms9NYlvZgUFTCAhovMDNKdWZr+jetqXqsazxFCjCA1RPo443ewJ0vG3ecgf2h
         cK0eCd8r4XeF2rm2TnoQ2EzRZDqzVS4YKVTCpvQCG7jXgzi3MXTI+V/RH4eCnAx6Tk
         8k3/lGzS/4we6jyuaAvYqTNoAP5tlZIfmko3w337j28hFCaHHhNzApUnupUjGeX3xD
         1YtNbsiZ1v6wQ==
Message-ID: <8d5b8ba694c1137d4663c32a151c9e2e4d68eac7.camel@kernel.org>
Subject: Re: [PATCH v5 0/8] ceph: size handling for the fscrypt
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org
Date:   Fri, 05 Nov 2021 07:15:37 -0400
In-Reply-To: <ea27cc27-77f1-d09a-3bfd-33db3034dfe5@redhat.com>
References: <20211103012232.14488-1-xiubli@redhat.com>
         <f4b219eb57b373f99b755c6398be6e6c9562deee.camel@kernel.org>
         <ea27cc27-77f1-d09a-3bfd-33db3034dfe5@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2021-11-05 at 08:50 +0800, Xiubo Li wrote:
> On 11/5/21 8:13 AM, Jeff Layton wrote:
> > On Wed, 2021-11-03 at 09:22 +0800, xiubli@redhat.com wrote:
> > > From: Jeff Layton <jlayton@kernel.org>
> > > 
> > > This patch series is based on the "wip-fscrypt-fnames" branch in
> > > repo https://github.com/ceph/ceph-client.git.
> > > 
> > > And I have picked up 5 patches from the "ceph-fscrypt-size-experimental"
> > > branch in repo
> > > https://git.kernel.org/pub/scm/linux/kernel/git/jlayton/linux.git.
> > > 
> > > ====
> > > 
> > > This approach is based on the discussion from V1 and V2, which will
> > > pass the encrypted last block contents to MDS along with the truncate
> > > request.
> > > 
> > > This will send the encrypted last block contents to MDS along with
> > > the truncate request when truncating to a smaller size and at the
> > > same time new size does not align to BLOCK SIZE.
> > > 
> > > The MDS side patch is raised in PR
> > > https://github.com/ceph/ceph/pull/43588, which is also based Jeff's
> > > previous great work in PR https://github.com/ceph/ceph/pull/41284.
> > > 
> > > The MDS will use the filer.write_trunc(), which could update and
> > > truncate the file in one shot, instead of filer.truncate().
> > > 
> > > This just assume kclient won't support the inline data feature, which
> > > will be remove soon, more detail please see:
> > > https://tracker.ceph.com/issues/52916
> > > 
> > > Changed in V5:
> > > - Rebase to "wip-fscrypt-fnames" branch in ceph-client.git repo.
> > > - Pick up 5 patches from Jeff's "ceph-fscrypt-size-experimental" branch
> > >    in linux.git repo.
> > > - Add "i_truncate_pagecache_size" member support in ceph_inode_info
> > >    struct, this will be used to truncate the pagecache only in kclient
> > >    side, because the "i_truncate_size" will always be aligned to BLOCK
> > >    SIZE. In fscrypt case we need to use the real size to truncate the
> > >    pagecache.
> > > 
> > > 
> > > Changed in V4:
> > > - Retry the truncate request by 20 times before fail it with -EAGAIN.
> > > - Remove the "fill_last_block" label and move the code to else branch.
> > > - Remove the #3 patch, which has already been sent out separately, in
> > >    V3 series.
> > > - Improve some comments in the code.
> > > 
> > > Changed in V3:
> > > - Fix possibly corrupting the file just before the MDS acquires the
> > >    xlock for FILE lock, another client has updated it.
> > > - Flush the pagecache buffer before reading the last block for the
> > >    when filling the truncate request.
> > > - Some other minore fixes.
> > > 
> > > 
> > > 
> > > Jeff Layton (5):
> > >    libceph: add CEPH_OSD_OP_ASSERT_VER support
> > >    ceph: size handling for encrypted inodes in cap updates
> > >    ceph: fscrypt_file field handling in MClientRequest messages
> > >    ceph: get file size from fscrypt_file when present in inode traces
> > >    ceph: handle fscrypt fields in cap messages from MDS
> > > 
> > > Xiubo Li (3):
> > >    ceph: add __ceph_get_caps helper support
> > >    ceph: add __ceph_sync_read helper support
> > >    ceph: add truncate size handling support for fscrypt
> > > 
> > >   fs/ceph/caps.c                  | 136 ++++++++++++++----
> > >   fs/ceph/crypto.h                |   4 +
> > >   fs/ceph/dir.c                   |   3 +
> > >   fs/ceph/file.c                  |  43 ++++--
> > >   fs/ceph/inode.c                 | 236 +++++++++++++++++++++++++++++---
> > >   fs/ceph/mds_client.c            |   9 +-
> > >   fs/ceph/mds_client.h            |   2 +
> > >   fs/ceph/super.h                 |  10 ++
> > >   include/linux/ceph/crypto.h     |  28 ++++
> > >   include/linux/ceph/osd_client.h |   6 +-
> > >   include/linux/ceph/rados.h      |   4 +
> > >   net/ceph/osd_client.c           |   5 +
> > >   12 files changed, 427 insertions(+), 59 deletions(-)
> > >   create mode 100644 include/linux/ceph/crypto.h
> > > 
> > Nice work, Xiubo. This looks good.
> > 
> > I've been testing it some today and it seems to work fine so far.
> 
> Cool.
> 
> 
> >   I've
> > got a bit more testing that I want to do tomorrow,
> 
> At the same time I will test more.
> 
> 
> > but this should
> > hopefully clear the way for us to finish the content encryption piece!
> Yeah, the experimental branch for the content encryption is not working 
> well as the fname branch does, we may need more review and testing about it.
> 

Definitely. That work is not at all complete yet. We need to make sure
the size handling is rock-solid before we add in content encryption
though. If we get the size handling wrong then it will probably just
manifest as data corruption once encryption is in play.

Heck, we may want to consider an fscrypt mode that just does no-op
encryption for testing this sort of thing.

On another note...one interesting this with this patchset:

[jlayton@client1 scratch]$ ls -l /mnt/scratch/crypt
total 12
-rw-r--r--. 1 jlayton jlayton 1025 Nov  5 06:55 1025
-rw-r--r--. 1 jlayton jlayton 1024 Nov  5 06:54 1k
-rw-r--r--. 1 jlayton jlayton 2048 Nov  5 06:54 2k
-rw-r--r--. 1 jlayton jlayton 7168 Nov  5 06:55 7k
-rw-r--r--. 1 jlayton jlayton    4 Nov  5 06:54 foo

...but when the same client doesn't have the key, the real sizes are
still presented:

[jlayton@client1 ~]$ ls -l /mnt/scratch/crypt
total 12
-rw-r--r--. 1 jlayton jlayton    4 Nov  5 06:54 mmyetGFDwaf_PPqhm2ofMkNOFxBPFyrYJc_uif1vXL8
-rw-r--r--. 1 jlayton jlayton 1024 Nov  5 06:54 OGkEeGaqqLj7YVceGN5SkCF80et25ZkPUwdrd9nqtsg
-rw-r--r--. 1 jlayton jlayton 7168 Nov  5 06:55 RL6qlqBvpAkZEku3SKrTmGqTkJWkWjqM7KtPvYJBAf8
-rw-r--r--. 1 jlayton jlayton 1025 Nov  5 06:55 w1rCnxYQLJTbxHtZC2qtRnDdoIO9-vf_OlKjY0WcwH8
-rw-r--r--. 1 jlayton jlayton 2048 Nov  5 06:54 YcwUK3htDdBkSqJVMebaKgR5xLO6BXz-NpABPa-mUA

On a client that doesn't support fscrypt, the sizes show the rounded-up values (as expected):

[jlayton@client2 ~]$ ls -l /mnt/scratch/crypt/
total 24
-rw-r--r--. 1 jlayton jlayton 4096 Nov  5 06:54 mmyetGFDwaf_PPqhm2ofMkNOFxBPFyrYJc_uif1vXL8
-rw-r--r--. 1 jlayton jlayton 4096 Nov  5 06:54 OGkEeGaqqLj7YVceGN5SkCF80et25ZkPUwdrd9nqtsg
-rw-r--r--. 1 jlayton jlayton 8192 Nov  5 06:55 RL6qlqBvpAkZEku3SKrTmGqTkJWkWjqM7KtPvYJBAf8
-rw-r--r--. 1 jlayton jlayton 4096 Nov  5 06:55 w1rCnxYQLJTbxHtZC2qtRnDdoIO9-vf_OlKjY0WcwH8
-rw-r--r--. 1 jlayton jlayton 4096 Nov  5 06:54 YcwUK3htDdBkSqJVMebaKgR5xLO6BXz-NpABPa-mUAU

Question: should we present the rounded-up sizes to applications on
clients that support fscrypt but do not have the key?

I tend to think that that makes for better opsec, overall. Are there
reasons not to hide the real size when the user doesn't have the key?
-- 
Jeff Layton <jlayton@kernel.org>
