Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2985122260
	for <lists+ceph-devel@lfdr.de>; Tue, 17 Dec 2019 04:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbfLQDI5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 16 Dec 2019 22:08:57 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:44357 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725836AbfLQDI5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 16 Dec 2019 22:08:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576552135;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oHgo59hJQAxnpIX24jb8GAjovreVd+cb46ZEvUXBFNo=;
        b=bTMbaI5krhc6zB9mL7J7rNcUTBC80QL09h1NYw3gcIJ5ik3CZ/5rwC9zdUn5ayjSVAR64b
        QcS1ITMIKEO7CrKeVlYlm2LBKdqu6iJTp96ga3vDNGAQOKov7WjcVLYmRrb2YnGw36Wqzo
        0p57x9N/Tg/zcKFWsvlhkMoBo8Utc5s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-y1lRQklYMpeLMYTT1MTN2w-1; Mon, 16 Dec 2019 22:08:40 -0500
X-MC-Unique: y1lRQklYMpeLMYTT1MTN2w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C7001800053;
        Tue, 17 Dec 2019 03:08:39 +0000 (UTC)
Received: from [10.72.12.95] (ovpn-12-95.pek2.redhat.com [10.72.12.95])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C10075C1B5;
        Tue, 17 Dec 2019 03:08:35 +0000 (UTC)
Subject: Re: [PATCH] ceph: don't clear I_NEW until inode metadata is fully
 populated
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, sage@redhat.com, zyan@redhat.com
References: <20191212142717.23656-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <701d9acb-4a2c-cecb-a76a-12bf6e2b1430@redhat.com>
Date:   Tue, 17 Dec 2019 11:08:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191212142717.23656-1-jlayton@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2019/12/12 22:27, Jeff Layton wrote:
> Currently, we could have an open-by-handle (or NFS server) call
> into the filesystem and start working with an inode before it's
> properly filled out.
>
> Don't clear I_NEW until we have filled out the inode, and discard it
> properly if that fails. Note that we occasionally take an extra
> reference to the inode to ensure that we don't put the last reference in
> discard_new_inode, but rather leave it for ceph_async_iput.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/inode.c | 25 +++++++++++++++++++++----
>   1 file changed, 21 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 5bdc1afc2bee..11672f8192b9 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -55,11 +55,9 @@ struct inode *ceph_get_inode(struct super_block *sb, struct ceph_vino vino)
>   	inode = iget5_locked(sb, t, ceph_ino_compare, ceph_set_ino_cb, &vino);
>   	if (!inode)
>   		return ERR_PTR(-ENOMEM);
> -	if (inode->i_state & I_NEW) {
> +	if (inode->i_state & I_NEW)
>   		dout("get_inode created new inode %p %llx.%llx ino %llx\n",
>   		     inode, ceph_vinop(inode), (u64)inode->i_ino);
> -		unlock_new_inode(inode);
> -	}
>   
>   	dout("get_inode on %lu=%llx.%llx got %p\n", inode->i_ino, vino.ino,
>   	     vino.snap, inode);
> @@ -88,6 +86,10 @@ struct inode *ceph_get_snapdir(struct inode *parent)
>   	inode->i_fop = &ceph_snapdir_fops;
>   	ci->i_snap_caps = CEPH_CAP_PIN; /* so we can open */
>   	ci->i_rbytes = 0;
> +
> +	if (inode->i_state & I_NEW)
> +		unlock_new_inode(inode);
> +
>   	return inode;
>   }
>   
> @@ -1301,7 +1303,6 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
>   			err = PTR_ERR(in);
>   			goto done;
>   		}
> -		req->r_target_inode = in;
>   
>   		err = fill_inode(in, req->r_locked_page, &rinfo->targeti, NULL,
>   				session,
> @@ -1311,8 +1312,13 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
>   		if (err < 0) {
>   			pr_err("fill_inode badness %p %llx.%llx\n",
>   				in, ceph_vinop(in));
> +			if (in->i_state & I_NEW)
> +				discard_new_inode(in);
>   			goto done;
>   		}
> +		req->r_target_inode = in;
> +		if (in->i_state & I_NEW)
> +			unlock_new_inode(in);
>   	}
>   
>   	/*
> @@ -1496,7 +1502,12 @@ static int readdir_prepopulate_inodes_only(struct ceph_mds_request *req,
>   		if (rc < 0) {
>   			pr_err("fill_inode badness on %p got %d\n", in, rc);
>   			err = rc;
> +			ihold(in);
> +			discard_new_inode(in);

Will it be warning when the inode is not a new one ?


> +		} else if (in->i_state & I_NEW) {
> +			unlock_new_inode(in);
>   		}
> +

Maybe to be simple, we can switch ihold() & discard_new_inode() to 
unlock_new_inode() instead all over the ceph cold, since we do not care 
about the I_CREATING state.


>   		/* avoid calling iput_final() in mds dispatch threads */
>   		ceph_async_iput(in);
>   	}
> @@ -1698,12 +1709,18 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
>   			if (d_really_is_negative(dn)) {
>   				/* avoid calling iput_final() in mds
>   				 * dispatch threads */
> +				if (in->i_state & I_NEW) {
> +					ihold(in);
> +					discard_new_inode(in);
> +				}
>   				ceph_async_iput(in);
>   			}
>   			d_drop(dn);
>   			err = ret;
>   			goto next_item;
>   		}
> +		if (in->i_state & I_NEW)
> +			unlock_new_inode(in);
>   
>   		if (d_really_is_negative(dn)) {
>   			if (ceph_security_xattr_deadlock(in)) {


