Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF0F187142
	for <lists+ceph-devel@lfdr.de>; Mon, 16 Mar 2020 18:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732216AbgCPRe5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 16 Mar 2020 13:34:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:38388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730437AbgCPRez (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 16 Mar 2020 13:34:55 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5F9C20679;
        Mon, 16 Mar 2020 17:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584380095;
        bh=lyqtCLrXofPu1yk6ZcsGZsEyWjI2a4e9/XBHX5Zq6q4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=n8UoKjdoIDI6ChF//n1vH7Vo+upcGiZTjnvna1N5R/5XNisi06EikoTZd6SHAW5by
         Y6LHWXEDvRRgrzqTPF+98vPzJ16s5sHHFnDr3qF1bnQT+/gh3lBChNEDzE2cY1Givp
         EsTvoKbePvYNf5ZLc+BXySWENSH1KwR51xBDCVO8=
Message-ID: <414d5d568ed3aad086e56bfc2e27c17d9865b504.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: fix snapshot directory timestamps
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.com>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     Marc Roos <M.Roos@f1-outsourcing.eu>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 16 Mar 2020 13:34:53 -0400
In-Reply-To: <20200311110538.GB58729@suse.com>
References: <20200311110538.GB58729@suse.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2020-03-11 at 11:05 +0000, Luis Henriques wrote:
> The .snap directory timestamps are kept at 0 (1970-01-01 00:00), which
> isn't consistent with what the fuse client does.  This patch makes the
> behaviour consistent, by setting these timestamps (atime, btime, ctime,
> mtime) to those of the parent directory.
> 
> Cc: Marc Roos <M.Roos@f1-outsourcing.eu>
> Signed-off-by: Luis Henriques <lhenriques@suse.com>
> ---
>  fs/ceph/inode.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index d01710a16a4a..968d55ca898d 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -82,10 +82,14 @@ struct inode *ceph_get_snapdir(struct inode *parent)
>  	inode->i_mode = parent->i_mode;
>  	inode->i_uid = parent->i_uid;
>  	inode->i_gid = parent->i_gid;
> +	inode->i_mtime = parent->i_mtime;
> +	inode->i_ctime = parent->i_ctime;
> +	inode->i_atime = parent->i_atime;
>  	inode->i_op = &ceph_snapdir_iops;
>  	inode->i_fop = &ceph_snapdir_fops;
>  	ci->i_snap_caps = CEPH_CAP_PIN; /* so we can open */
>  	ci->i_rbytes = 0;
> +	ci->i_btime = ceph_inode(parent)->i_btime;
>  
>  	if (inode->i_state & I_NEW)
>  		unlock_new_inode(inode);

Merged into testing branch -- thanks for the patch!
-- 
Jeff Layton <jlayton@kernel.org>

