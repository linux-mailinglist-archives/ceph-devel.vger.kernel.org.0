Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02DC84419D2
	for <lists+ceph-devel@lfdr.de>; Mon,  1 Nov 2021 11:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbhKAK3x (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 1 Nov 2021 06:29:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:35406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231841AbhKAK3x (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 1 Nov 2021 06:29:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50249610A2;
        Mon,  1 Nov 2021 10:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635762439;
        bh=vtcLqYX6hRLydWRtiOha9+t+PluqhRxj1c2pU17ZtTw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RWnEI1QUMycKnWFvRe1z4sCavVqxiF5eBnnGudCy5vX9sU5/kZTYLKLS+8GTlWoUs
         dXapiuERyVVLcn2dDgV3HjYAwMDN64Ulmn9s+315HOepu8S+iW5bbYQiCQ+G37zhuq
         CeZCB0q+kTmsHq9tIlv3xBgJ/kQIgr33ZNnIjqJ7VaNZQMHEZAJinPH/5PqI/enpG5
         OQ3SWqfZzCEE8AsuXHv4ohqGl07Tg9zpT+Z4D3yLOzBsNVUgcBU6lnhw3ZC9mZ0Q/t
         uUEJBRi+aGLwvSUUz7K2gALgepKdofcEOD8YaLisryX723dak1oHSXYIiag2tpt8lb
         Cuamm8RXuRKVg==
Message-ID: <5c5d98f06c0a70271b324d9f144f44f8dddd91e5.camel@kernel.org>
Subject: Re: [PATCH v4 0/4] ceph: size handling for the fscrypt
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org
Date:   Mon, 01 Nov 2021 06:27:18 -0400
In-Reply-To: <20211101020447.75872-1-xiubli@redhat.com>
References: <20211101020447.75872-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2021-11-01 at 10:04 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> This patch series is based on the "fscrypt_size_handling" branch in
> https://github.com/lxbsz/linux.git, which is based Jeff's
> "ceph-fscrypt-content-experimental" branch in
> https://git.kernel.org/pub/scm/linux/kernel/git/jlayton/linux.git
> and added two upstream commits, which should be merged already.
> 
> These two upstream commits should be removed after Jeff rebase
> his "ceph-fscrypt-content-experimental" branch to upstream code.
> 

I don't think I was clear last time. I'd like for you to post the
_entire_ stack of patches that is based on top of
ceph-client/wip-fscrypt-fnames. wip-fscrypt-fnames is pretty stable at
this point, so I think it's a reasonable place for you to base your
work. That way you're not beginning with a revert.

Again, feel free to cherry-pick any of the patches in any of my other
branches for your series, but I'd like to see a complete series of
patches.

Thanks,
Jeff


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
> Changed in V4:
> - Retry the truncate request by 20 times before fail it with -EAGAIN.
> - Remove the "fill_last_block" label and move the code to else branch.
> - Remove the #3 patch, which has already been sent out separately, in
>   V3 series.
> - Improve some comments in the code.
> 
> 
> Changed in V3:
> - Fix possibly corrupting the file just before the MDS acquires the
>   xlock for FILE lock, another client has updated it.
> - Flush the pagecache buffer before reading the last block for the
>   when filling the truncate request.
> - Some other minore fixes.
> 
> Xiubo Li (4):
>   Revert "ceph: make client zero partial trailing block on truncate"
>   ceph: add __ceph_get_caps helper support
>   ceph: add __ceph_sync_read helper support
>   ceph: add truncate size handling support for fscrypt
> 
>  fs/ceph/caps.c              |  21 ++--
>  fs/ceph/file.c              |  44 +++++---
>  fs/ceph/inode.c             | 203 ++++++++++++++++++++++++++++++------
>  fs/ceph/super.h             |   6 +-
>  include/linux/ceph/crypto.h |  28 +++++
>  5 files changed, 251 insertions(+), 51 deletions(-)
>  create mode 100644 include/linux/ceph/crypto.h
> 

-- 
Jeff Layton <jlayton@kernel.org>

