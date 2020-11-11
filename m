Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1506C2AF777
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Nov 2020 18:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgKKRkj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Nov 2020 12:40:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:38516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725916AbgKKRki (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 11 Nov 2020 12:40:38 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C99C206D9;
        Wed, 11 Nov 2020 17:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605116437;
        bh=7OP/oaAY/uEOdScS/YzDQ/QRsojV9U51GcolACqa6ZU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=STG85v6lXcKdXvFnNR7eA4uLoV1yYLQiL6CXyc9SeYlWu7us+V/ahL2WOjd0XiuPg
         mkCYDq33avkurYsWGlYZUA8gLRBHQI0gi22Bkeix5FQezeRPHImovVuxUs+CWzyeGM
         I1VmFzcjxd+3gN4BqvSuj6TrjyMz7B+7VXiwi8WY=
Message-ID: <0609b9014d4032e4fc4a8c8b74c935bf0cf4524a.camel@kernel.org>
Subject: Re: [RFC PATCH] ceph: fix cross quota realms renames with new
 truncated files
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.de>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 11 Nov 2020 12:40:35 -0500
In-Reply-To: <20201111153915.23426-1-lhenriques@suse.de>
References: <20201111153915.23426-1-lhenriques@suse.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 (3.38.1-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2020-11-11 at 15:39 +0000, Luis Henriques wrote:
> When doing a rename across quota realms, there's a corner case that isn't
> handled correctly.  Here's a testcase:
> 
>   mkdir files limit
>   truncate files/file -s 10G
>   setfattr limit -n ceph.quota.max_bytes -v 1000000
>   mv files limit/
> 
> The above will succeed because ftruncate(2) won't result in an immediate
> notification of the MDSs with the new file size, and thus the quota realms
> stats won't be updated.
> 
> This patch forces a sync with the MDS every time there's an ATTR_SIZE that
> sets a new i_size, even if we have Fx caps.
> 
> Cc: stable@vger.kernel.org
> Fixes: dffdcd71458e ("ceph: allow rename operation under different quota realms")
> URL: https://tracker.ceph.com/issues/36593
> Signed-off-by: Luis Henriques <lhenriques@suse.de>
> ---
>  fs/ceph/inode.c | 11 ++---------
>  1 file changed, 2 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 526faf4778ce..30e3f240ac96 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -2136,15 +2136,8 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr)
>  	if (ia_valid & ATTR_SIZE) {
>  		dout("setattr %p size %lld -> %lld\n", inode,
>  		     inode->i_size, attr->ia_size);
> -		if ((issued & CEPH_CAP_FILE_EXCL) &&
> -		    attr->ia_size > inode->i_size) {
> -			i_size_write(inode, attr->ia_size);
> -			inode->i_blocks = calc_inode_blocks(attr->ia_size);
> -			ci->i_reported_size = attr->ia_size;
> -			dirtied |= CEPH_CAP_FILE_EXCL;
> -			ia_valid |= ATTR_MTIME;
> -		} else if ((issued & CEPH_CAP_FILE_SHARED) == 0 ||
> -			   attr->ia_size != inode->i_size) {
> +		if ((issued & (CEPH_CAP_FILE_EXCL|CEPH_CAP_FILE_SHARED)) ||
> +		    (attr->ia_size != inode->i_size)) {
>  			req->r_args.setattr.size = cpu_to_le64(attr->ia_size);
>  			req->r_args.setattr.old_size =
>  				cpu_to_le64(inode->i_size);

Hmm...this makes truncates more expensive when we have caps. I'd rather
not do that if we can help it.

What about instead having the client mimic a fsync when there is a
rename across quota realms? If we can't tell that reliably then we could
also just do an effective fsync ahead of any cross-directory rename?
-- 
Jeff Layton <jlayton@kernel.org>

