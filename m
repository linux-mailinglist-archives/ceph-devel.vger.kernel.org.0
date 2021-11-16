Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31696453A88
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Nov 2021 21:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234309AbhKPUJM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 16 Nov 2021 15:09:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:40092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231980AbhKPUJL (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 16 Nov 2021 15:09:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E793761BAA;
        Tue, 16 Nov 2021 20:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637093174;
        bh=K2TCRfiItG43oqcjZ/iaAWIZFoXLyeWLYfxuzlmStmY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=C/1sxSHGG3dNsnqT2MP+J7GQOrC2etz1A3GLZi8bG1m5nRPQF4W7v89XeODh5AklX
         f8Lb1RniN1mUYgQR8JWZkAPTJ537MC8NT+KWkexslXexl84UuP3hEjVQqDAfBggLww
         4q24ulquay6srMuebbsJqmHrU0bQ8DaQZf+ztkDriLoLdN47u0UdoTcuw99AKiZ0/h
         BmVEaO3pjPByNV3ZM4e7tIs+NV64TzbynuwExkTVHgjR8zRLmKZrZFJ70KJ+SO2DeC
         Fe1bV7GN+axsVm+HHTEfn72W4E5ypVH6K9bEDEAOCxAY/hJxYEbUPf8mwle4j69fXK
         qz/FpnUPJH+AQ==
Message-ID: <d37b49e0048ba3cf6763b83c82ad2fd8f8f36663.camel@kernel.org>
Subject: Re: [PATCH] ceph: do not truncate pagecache if truncate size
 doesn't change
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Tue, 16 Nov 2021 15:06:12 -0500
In-Reply-To: <20211116092002.99439-1-xiubli@redhat.com>
References: <20211116092002.99439-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2021-11-16 at 17:20 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> In case truncating a file to a smaller sizeA, the sizeA will be kept
> in truncate_size. And if truncate the file to a bigger sizeB, the
> MDS will only increase the truncate_seq, but still using the sizeA as
> the truncate_size.
> 

Do you mean "kept in ci->i_truncate_size" ? If so, is this really the
correct fix? I'll note this in the sources:

        u32 i_truncate_seq;        /* last truncate to smaller size */                              
        u64 i_truncate_size;       /*  and the size we last truncated down to */                    

Maybe the MDS ought not bump the truncate_seq unless it was truncating
to a smaller size? If not, then that comment seems wrong at least.


> So when filling the inode it will truncate the pagecache by using
> truncate_sizeA again, which makes no sense and will trim the inocent
> pages.
> 

Is there a reproducer for this? It would be nice to put something in
xfstests for it if so.

> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/inode.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 1b4ce453d397..b4f784684e64 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -738,10 +738,11 @@ int ceph_fill_file_size(struct inode *inode, int issued,
>  			 * don't hold those caps, then we need to check whether
>  			 * the file is either opened or mmaped
>  			 */
> -			if ((issued & (CEPH_CAP_FILE_CACHE|
> +			if (ci->i_truncate_size != truncate_size &&
> +			    ((issued & (CEPH_CAP_FILE_CACHE|
>  				       CEPH_CAP_FILE_BUFFER)) ||
>  			    mapping_mapped(inode->i_mapping) ||
> -			    __ceph_is_file_opened(ci)) {
> +			    __ceph_is_file_opened(ci))) {
>  				ci->i_truncate_pending++;
>  				queue_trunc = 1;
>  			}

-- 
Jeff Layton <jlayton@kernel.org>
