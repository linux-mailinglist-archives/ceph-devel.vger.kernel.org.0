Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20144138D5E
	for <lists+ceph-devel@lfdr.de>; Mon, 13 Jan 2020 10:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726133AbgAMJBX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 13 Jan 2020 04:01:23 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:55451 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725268AbgAMJBX (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 13 Jan 2020 04:01:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578906081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LYiEJSIBy3bSuCXm91dy1Apo8PiI552CcaKqcALehXY=;
        b=Dp0RB/rzmczfIONT9PrTAtGvyoj6SwIUVLM0XIypKLKoRNaST9RepCnjjBkph6a/kXIuyU
        nmutWg27Bv167Bp0IOcLxUFTV0M5Pf9jyO/3LcRQbFBfYPKQ8yCiia7BEM65JPzTvNGxD6
        pjXFe334LU/Uz2mgqaTysiqOl3CON3s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-Y94aBUUtMAipdaLfCQA9rg-1; Mon, 13 Jan 2020 04:01:18 -0500
X-MC-Unique: Y94aBUUtMAipdaLfCQA9rg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 397C1DB20;
        Mon, 13 Jan 2020 09:01:17 +0000 (UTC)
Received: from [10.72.12.218] (ovpn-12-218.pek2.redhat.com [10.72.12.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D668250A8F;
        Mon, 13 Jan 2020 09:01:11 +0000 (UTC)
Subject: Re: [RFC PATCH 8/9] ceph: copy layout, max_size and truncate_size on
 successful sync create
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, pdonnell@redhat.com
References: <20200110205647.311023-1-jlayton@kernel.org>
 <20200110205647.311023-9-jlayton@kernel.org>
From:   "Yan, Zheng" <zyan@redhat.com>
Message-ID: <b4dea395-11af-8a16-415e-da145c3def1f@redhat.com>
Date:   Mon, 13 Jan 2020 17:01:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200110205647.311023-9-jlayton@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 1/11/20 4:56 AM, Jeff Layton wrote:
> It doesn't do much good to do an asynchronous create unless we can do
> I/O to it before the create reply comes in. That means we need layout
> info the new file before we've gotten the response from the MDS.
> 
> All files created in a directory will initially inherit the same layout,
> so copy off the requisite info from the first synchronous create in the
> directory. Save it in the same fields in the directory inode, as those
> are otherwise unsed for dir inodes. This means we need to be a bit
> careful about only updating layout info on non-dir inodes.
> 
> Also, zero out the layout when we drop Dc caps in the dir.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/caps.c  | 24 ++++++++++++++++++++----
>   fs/ceph/file.c  | 24 +++++++++++++++++++++++-
>   fs/ceph/inode.c |  4 ++--
>   3 files changed, 45 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 7fc87b693ba4..b96fb1378479 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -2847,7 +2847,7 @@ int ceph_get_caps(struct file *filp, int need, int want,
>   			return ret;
>   		}
>   
> -		if (S_ISREG(ci->vfs_inode.i_mode) &&
> +		if (!S_ISDIR(ci->vfs_inode.i_mode) &&
>   		    ci->i_inline_version != CEPH_INLINE_NONE &&
>   		    (_got & (CEPH_CAP_FILE_CACHE|CEPH_CAP_FILE_LAZYIO)) &&
>   		    i_size_read(inode) > 0) {
> @@ -2944,9 +2944,17 @@ void ceph_put_cap_refs(struct ceph_inode_info *ci, int had)
>   	if (had & CEPH_CAP_FILE_RD)
>   		if (--ci->i_rd_ref == 0)
>   			last++;
> -	if (had & CEPH_CAP_FILE_CACHE)
> -		if (--ci->i_rdcache_ref == 0)
> +	if (had & CEPH_CAP_FILE_CACHE) {
> +		if (--ci->i_rdcache_ref == 0) {
>   			last++;
> +			/* Zero out layout if we lost CREATE caps */
> +			if (S_ISDIR(inode->i_mode) &&
> +			    !(__ceph_caps_issued(ci, NULL) & CEPH_CAP_DIR_CREATE)) {
> +				ceph_put_string(rcu_dereference_raw(ci->i_layout.pool_ns));
> +				memset(&ci->i_layout, 0, sizeof(ci->i_layout));
> +			}
> +		}
> +	}
>   	if (had & CEPH_CAP_FILE_EXCL)
>   		if (--ci->i_fx_ref == 0)
>   			last++;
> @@ -3264,7 +3272,8 @@ static void handle_cap_grant(struct inode *inode,
>   		ci->i_subdirs = extra_info->nsubdirs;
>   	}
>   
> -	if (newcaps & (CEPH_CAP_ANY_FILE_RD | CEPH_CAP_ANY_FILE_WR)) {
> +	if (!S_ISDIR(inode->i_mode) &&
> +	    (newcaps & (CEPH_CAP_ANY_FILE_RD | CEPH_CAP_ANY_FILE_WR))) {
>   		/* file layout may have changed */
>   		s64 old_pool = ci->i_layout.pool_id;
>   		struct ceph_string *old_ns;
> @@ -3336,6 +3345,13 @@ static void handle_cap_grant(struct inode *inode,
>   		     ceph_cap_string(cap->issued),
>   		     ceph_cap_string(newcaps),
>   		     ceph_cap_string(revoking));
> +
> +		if (S_ISDIR(inode->i_mode) &&
> +		    (revoking & CEPH_CAP_DIR_CREATE) && !ci->i_rdcache_ref) {
> +			ceph_put_string(rcu_dereference_raw(ci->i_layout.pool_ns));
> +			memset(&ci->i_layout, 0, sizeof(ci->i_layout));
> +		}
> +
>   		if (S_ISREG(inode->i_mode) &&
>   		    (revoking & used & CEPH_CAP_FILE_BUFFER))
>   			writeback = true;  /* initiate writeback; will delay ack */
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 1e6cdf2dfe90..d4d7a277faf1 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -430,6 +430,25 @@ int ceph_open(struct inode *inode, struct file *file)
>   	return err;
>   }
>   
> +/* Clone the layout from a synchronous create, if the dir now has Dc caps */
> +static void
> +copy_file_layout(struct inode *dst, struct inode *src)
> +{
> +	struct ceph_inode_info *cdst = ceph_inode(dst);
> +	struct ceph_inode_info *csrc = ceph_inode(src);
> +
> +	spin_lock(&cdst->i_ceph_lock);
> +	if ((__ceph_caps_issued(cdst, NULL) & CEPH_CAP_DIR_CREATE) &&
> +	    !ceph_file_layout_is_valid(&cdst->i_layout)) {
> +		memcpy(&cdst->i_layout, &csrc->i_layout,
> +			sizeof(cdst->i_layout));

directory's i_layout is used for other purpose. shouldn't modify it.

> +		rcu_assign_pointer(cdst->i_layout.pool_ns,
> +				   ceph_try_get_string(csrc->i_layout.pool_ns));
> +		cdst->i_max_size = csrc->i_max_size; > +		cdst->i_truncate_size = csrc->i_truncate_size;
no need to save above two. just set truncate size of new file to 
(u64)-1, set max_size of new file to its layout.stripe_unit;

max_size == layout.strip_unit ensure that client only write to the first 
object before its writeable range is persistent.

> +	}
> +	spin_unlock(&cdst->i_ceph_lock);
> +}
>   
>   /*
>    * Do a lookup + open with a single request.  If we get a non-existent
> @@ -518,7 +537,10 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>   	} else {
>   		dout("atomic_open finish_open on dn %p\n", dn);
>   		if (req->r_op == CEPH_MDS_OP_CREATE && req->r_reply_info.has_create_ino) {
> -			ceph_init_inode_acls(d_inode(dentry), &as_ctx);
> +			struct inode *newino = d_inode(dentry);
> +
> +			copy_file_layout(dir, newino);
> +			ceph_init_inode_acls(newino, &as_ctx);
>   			file->f_mode |= FMODE_CREATED;
>   		}
>   		err = finish_open(file, dentry, ceph_open);
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 9cfc093fd273..8b51051b79b0 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -848,8 +848,8 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
>   		ci->i_subdirs = le64_to_cpu(info->subdirs);
>   	}
>   
> -	if (new_version ||
> -	    (new_issued & (CEPH_CAP_ANY_FILE_RD | CEPH_CAP_ANY_FILE_WR))) {
> +	if (!S_ISDIR(inode->i_mode) && (new_version ||
> +	    (new_issued & (CEPH_CAP_ANY_FILE_RD | CEPH_CAP_ANY_FILE_WR)))) {
>   		s64 old_pool = ci->i_layout.pool_id;
>   		struct ceph_string *old_ns;
>   
> 

