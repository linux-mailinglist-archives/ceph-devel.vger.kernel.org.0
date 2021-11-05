Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B56B445CF1
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Nov 2021 01:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232487AbhKEAQV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 4 Nov 2021 20:16:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:53282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232410AbhKEAQU (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 4 Nov 2021 20:16:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F02861213;
        Fri,  5 Nov 2021 00:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636071221;
        bh=8zR4lAPgGtk5Oh6VLrOR3teaFWPK63OWG49xP0Kq+eE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ocjfbSSfJR6oHMkhMMjcuaEQfvlCWcX6T801mOU2yFS0QIp5zLHGhEumTNXAg61hq
         sVAF4lovTboLNu/LpJOFLXJMVHzFf9cGfRWmNE2OAXmZzGWm1fKAuvhA107BH7cADE
         soDSTsaTUx9BzecjzV9//K5Lne3LE5adFtBy3Q7q/Ewgpc1oiDU2dvGcplTOX2UEjC
         olchSPhriZSsnRFgpJsZGOlmCzyqnFTD/xAUUCVnzbTYDAt+bPKWa/HbF5UhViER9S
         KjLTM+eqA4P8DDLqBE+8FOwK5xCoyvCP8eOV7tyf6LakzZtpRIBXhv4GgRBV9Nh8xv
         bV5Dc/krOO0wA==
Message-ID: <f4b219eb57b373f99b755c6398be6e6c9562deee.camel@kernel.org>
Subject: Re: [PATCH v5 0/8] ceph: size handling for the fscrypt
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org
Date:   Thu, 04 Nov 2021 20:13:40 -0400
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

Nice work, Xiubo. This looks good.

I've been testing it some today and it seems to work fine so far. I've
got a bit more testing that I want to do tomorrow, but this should
hopefully clear the way for us to finish the content encryption piece!

Many thanks!
-- 
Jeff Layton <jlayton@kernel.org>
