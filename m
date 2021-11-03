Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA914441F8
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Nov 2021 13:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbhKCM6m (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 3 Nov 2021 08:58:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:37084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230152AbhKCM6l (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 3 Nov 2021 08:58:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D31F961076;
        Wed,  3 Nov 2021 12:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635944165;
        bh=+35WDhFj0uBSpj41hq1Ok0Exv7I7I7j8uadQsxJdKCI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=HqM6Ma888udck7Nydkf8WgtFJiQc47ObvZi010fgXzNZsvsj8WcWF70K/oa4tvuCX
         YnWtu8d9OBwnbSHNEQH3WIPTofZY0nZRyVvHntZUOHVy4v7roykIOmT/Fn39ZOtLV2
         PDrdCE7YBDvAzrJjGj2p+X3k1MnuuCsMXyK47fAM1yXwwLqiF/TwjOl+blMTpiOEyU
         Q6LZnBVt3ZQ4T99MkTj1DUhUCwE9ynQ9ggemopZx0+50ZlLwNvAd2Qc0Znp3dPdqaq
         puCqsA+fcCG4z8fmAkBL1hQJCn5EiznpB6CH+1Blz483mOwJKEkNZmQ/bTAtn8oCGe
         bwKviTGOmlAJA==
Message-ID: <cedf7aeb9bca77c0e31ceef0d3044f474674d0b6.camel@kernel.org>
Subject: Re: [PATCH v5 0/8] ceph: size handling for the fscrypt
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org
Date:   Wed, 03 Nov 2021 08:56:03 -0400
In-Reply-To: <20211103012232.14488-1-xiubli@redhat.com>
References: <20211103012232.14488-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.0 (3.42.0-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2021-11-03 at 09:22 +0800, xiubli@redhat.com wrote:
> From: Jeff Layton <jlayton@kernel.org>
> 
> This patch series is based on the "wip-fscrypt-fnames" branch in
> repo https://github.com/ceph/ceph-client.git.
> 
> And I have picked up 5 patches from the "ceph-fscrypt-size-experimental"
> branch in repo
> https://git.kernel.org/pub/scm/linux/kernel/git/jlayton/linux.git.
> 
> ====
> 
> This approach is based on the discussion from V1 and V2, which will
> pass the encrypted last block contents to MDS along with the truncate
> request.
> 
> This will send the encrypted last block contents to MDS along with
> the truncate request when truncating to a smaller size and at the
> same time new size does not align to BLOCK SIZE.
> 
> The MDS side patch is raised in PR
> https://github.com/ceph/ceph/pull/43588, which is also based Jeff's
> previous great work in PR https://github.com/ceph/ceph/pull/41284.
> 
> The MDS will use the filer.write_trunc(), which could update and
> truncate the file in one shot, instead of filer.truncate().
> 
> This just assume kclient won't support the inline data feature, which
> will be remove soon, more detail please see:
> https://tracker.ceph.com/issues/52916
> 
> Changed in V5:
> - Rebase to "wip-fscrypt-fnames" branch in ceph-client.git repo.
> - Pick up 5 patches from Jeff's "ceph-fscrypt-size-experimental" branch
>   in linux.git repo.
> - Add "i_truncate_pagecache_size" member support in ceph_inode_info
>   struct, this will be used to truncate the pagecache only in kclient
>   side, because the "i_truncate_size" will always be aligned to BLOCK
>   SIZE. In fscrypt case we need to use the real size to truncate the
>   pagecache.
> 
> 
> Changed in V4:
> - Retry the truncate request by 20 times before fail it with -EAGAIN.
> - Remove the "fill_last_block" label and move the code to else branch.
> - Remove the #3 patch, which has already been sent out separately, in
>   V3 series.
> - Improve some comments in the code.
> 
> Changed in V3:
> - Fix possibly corrupting the file just before the MDS acquires the
>   xlock for FILE lock, another client has updated it.
> - Flush the pagecache buffer before reading the last block for the
>   when filling the truncate request.
> - Some other minore fixes.
> 
> 
> 
> Jeff Layton (5):
>   libceph: add CEPH_OSD_OP_ASSERT_VER support
>   ceph: size handling for encrypted inodes in cap updates
>   ceph: fscrypt_file field handling in MClientRequest messages
>   ceph: get file size from fscrypt_file when present in inode traces
>   ceph: handle fscrypt fields in cap messages from MDS
> 
> Xiubo Li (3):
>   ceph: add __ceph_get_caps helper support
>   ceph: add __ceph_sync_read helper support
>   ceph: add truncate size handling support for fscrypt
> 
>  fs/ceph/caps.c                  | 136 ++++++++++++++----
>  fs/ceph/crypto.h                |   4 +
>  fs/ceph/dir.c                   |   3 +
>  fs/ceph/file.c                  |  43 ++++--
>  fs/ceph/inode.c                 | 236 +++++++++++++++++++++++++++++---
>  fs/ceph/mds_client.c            |   9 +-
>  fs/ceph/mds_client.h            |   2 +
>  fs/ceph/super.h                 |  10 ++
>  include/linux/ceph/crypto.h     |  28 ++++
>  include/linux/ceph/osd_client.h |   6 +-
>  include/linux/ceph/rados.h      |   4 +
>  net/ceph/osd_client.c           |   5 +
>  12 files changed, 427 insertions(+), 59 deletions(-)
>  create mode 100644 include/linux/ceph/crypto.h
> 

Thanks Xiubo,

This looks like a great start. I set up an environment vs. a cephadm
cluster with your fscrypt changes, and started running xfstests against
it with test_dummy_encryption enabled. It got to generic/014 and the
test hung waiting on a SETATTR call to come back:

[root@client1 f3cf8b7a-38ec-11ec-a0e4-52540031ba78.client74208]# cat mdsc
89447	mds0	setattr	 #1000003b19c

Looking at the MDS that it was talking to, I see:

Nov 03 08:25:09 cephadm2 ceph-mds[3133]: log_channel(cluster) log [WRN] : 1 slow requests, 1 included below; oldest blocked for > 31.627241 secs
Nov 03 08:25:09 cephadm2 ceph-mds[3133]: log_channel(cluster) log [WRN] : slow request 31.627240 seconds old, received at 2021-11-03T12:24:37.911553+0000: client_request(client.74208:89447 setattr size=102498304 #0x1000003b19c 2021-11-03T12:24:37.895292+0000 caller_uid=0, caller_gid=0{0,}) currently acquired locks
Nov 03 08:25:14 cephadm2 ceph-mds[3133]: log_channel(cluster) log [WRN] : 1 slow requests, 0 included below; oldest blocked for > 36.627323 secs
Nov 03 08:25:19 cephadm2 ceph-mds[3133]: log_channel(cluster) log [WRN] : 1 slow requests, 0 included below; oldest blocked for > 41.627389 secs

...and it still hasn't resolved.

I'll keep looking around a bit more, but I think there are still some
bugs in here. Let me know if you have thoughts as to what the issue is.

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>
