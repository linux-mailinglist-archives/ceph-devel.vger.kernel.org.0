Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01B9C43A42B
	for <lists+ceph-devel@lfdr.de>; Mon, 25 Oct 2021 22:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236825AbhJYUPw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 25 Oct 2021 16:15:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234878AbhJYUPr (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 25 Oct 2021 16:15:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E18560230;
        Mon, 25 Oct 2021 20:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635192805;
        bh=SDjkRF6LmkzcBN/YvcDWsrrAUzufDqhOzs0oQirBYc4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EaVt2NLlf1GpDo8D+j/O2oo0+fvMygkqd7TFoNGj23pAvrNkKw7wqr/UVf3SCmIFA
         r+ME0DuK2+TxCatHBkyPSaPZO+BmqmcCkzrKWag+6MAzx/V0CXXrMnCQ+kXf+tZFGa
         dBRd7M7v0K2n0UStN1S+pR+TASTD2gZGC0+KmXdBpL3LWL7fSC9wg3rmhR6OYyx+EC
         FKAmmN8VU1+2ozBxnoDNUffKz+9ZcU++T/OGhsg39Bn7gAdDNvcZksIm5dYJxqZxHY
         +1PG2tKxyuWEjfBOGRCpO+S+DBcKdJaNIzqIzcfGGZciO02XHZ6L4Dx5vZyABvJUYE
         f8xsf2jKJ0qxw==
Message-ID: <414dcc5f3b6c6009b0192668d44d7bc39baa0483.camel@kernel.org>
Subject: Re: [PATCH v2 0/4] ceph: size handling for the fscrypt
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, khiremat@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Mon, 25 Oct 2021 16:13:23 -0400
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

Ok, I think you're on a good start. It's a bit hard to review patchsets
that rely on other out-of-tree patches. The ceph-fscrypt-content-
experimental branch is _really_ experimental, and you start the series
by reverting one of the patches in there.

The goal here is for you to send a complete series that we'll want to
merge, without all of the interim churn of reverting patches and
changing the same code several times.

I think what would be best here is for you to put together and send a
complete patchset that is based on top of the
ceph-client/wip-fscrypt-fnames branch. I've just rebased that branch
onto the latest ceph-client/testing branch, but it has been fairly
stable for the last few weeks, and any changes we make in there probably
won't affect in the areas you're working as much.

Feel free to cherry-pick any patches from my ceph-fscrypt-content-
experimental branch that you think should part of the set. Also feel
free to modify any of those patches. We don't want buggy patches partway
through the merge of the series.

Does that sound OK?

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
> 
> 2), If another client has buffered the last block, we should flush
> it first. I am still thinking how to do this ? Any idea is welcome.
> 
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

