Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09742434F1B
	for <lists+ceph-devel@lfdr.de>; Wed, 20 Oct 2021 17:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbhJTPfF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 20 Oct 2021 11:35:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:53580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229570AbhJTPfE (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 20 Oct 2021 11:35:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCB9961373;
        Wed, 20 Oct 2021 15:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634743970;
        bh=Psve+KgjKnBmpIkuWguUrhAPad5kecxUZMASDCPSKmY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=G5SqeBU1NOMCtDkrkCoKMpCxGxlbsd5q7vOFLmnVexruonU0oRjQ7hiYOHUF4uOOW
         3VMhryKIs7p1631CZv//yEV5mELswrooaOXeHrpEWsVazXaj03nwxXp04sNGXwAn9/
         wOhg960DghJOSP6UKiMKRbVabuT2247F7ajdAqyHbZLgAHCJI5ILmoC1SpEBcoEDWj
         APBw5thJrPcH/mvbmjLCiD8uUsCU5sv4tzzwk2taedEty2LYkup8Azws//wZx3MmSS
         ycNWlT6oGS15j7OgEK2H6tdLplQ0ff4Js+c3Z0Z7fvExz1yVMkuRplmkHvfj510keY
         N7V4vrffZlSYA==
Message-ID: <d88365035eb11560425e67aa34444086c80c628f.camel@kernel.org>
Subject: Re: [PATCH v2 0/4] ceph: size handling for the fscrypt
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, khiremat@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Wed, 20 Oct 2021 11:32:48 -0400
In-Reply-To: <20211020132813.543695-1-xiubli@redhat.com>
References: <20211020132813.543695-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2021-10-20 at 21:28 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> This patch series is based on the fscrypt_size_handling branch in
> https://github.com/lxbsz/linux.git, which is based Jeff's
> ceph-fscrypt-content-experimental branch in
> https://git.kernel.org/pub/scm/linux/kernel/git/jlayton/linux.git,
> has reverted one useless commit and added some upstream commits.
> 
> I will keep this patch set as simple as possible to review since
> this is still one framework code. It works and still in developing
> and need some feedbacks and suggestions for two corner cases below.
> 
> ====
> 
> This approach is based on the discussion from V1, which will pass
> the encrypted last block contents to MDS along with the truncate
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
> I have removed the inline data related code since we are remove
> this feature, more detail please see:
> https://tracker.ceph.com/issues/52916
> 
> 
> Note: There still has two CORNER cases we need to deal with:
> 
> 1), If a truncate request with the last block is sent to the MDS and
> just before the MDS has acquired the xlock for FILE lock, if another
> client has updated that last block content, we will over write the
> last block with old data.
> 
> For this case we could send the old encrypted last block data along
> with the truncate request and in MDS side read it and then do compare
> just before updating it, if the comparasion fails, then fail the
> truncate and let the kclient retry it.

Right -- this is the tricky bit. We're doing a truncate with a read-
modify-write cycle for the last block rolled in. We _must_ gate the
truncate+write vs. intervening changes to that extent.

You may be able to use the object version instead of comparing the old
block. The ceph-fscrypt-content branch has a patch that adds support for
CEPH_OSD_OP_ASSERT_VER, but I seem to recall that the OSD supports a way
to assert that an extent hasn't changed.

So, basically my thinking was something like:

client reads the data from the object and fetches the object version
send the object version along with the last block, and then the MDS's
write+truncate operation could assert on that version.

The catch here is that tracking those object versions is sort of nasty.
Having it do comparisons of the extent contents might be simpler.

> 2), If another client has buffered the last block, we should flush
> it first. I am still thinking how to do this ? Any idea is welcome.
> 

I think by asserting on the contents of the last block or the object
version, this problem is also solved.

> Thanks.
> 
> 
> Xiubo Li (4):
>   ceph: add __ceph_get_caps helper support
>   ceph: add __ceph_sync_read helper support
>   ceph: return the real size readed when hit EOF
>   ceph: add truncate size handling support for fscrypt
> 
>  fs/ceph/caps.c  |  28 ++++---
>  fs/ceph/file.c  |  41 ++++++----
>  fs/ceph/inode.c | 210 ++++++++++++++++++++++++++++++++++++++++++------
>  fs/ceph/super.h |   4 +
>  4 files changed, 234 insertions(+), 49 deletions(-)
> 

-- 
Jeff Layton <jlayton@kernel.org>

