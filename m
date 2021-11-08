Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADAE94479D0
	for <lists+ceph-devel@lfdr.de>; Mon,  8 Nov 2021 06:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233715AbhKHFMj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 8 Nov 2021 00:12:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50956 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229988AbhKHFMj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 8 Nov 2021 00:12:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636348194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3+5hapKIdUPcBv9KiTx49+qcJGVnuve8mSmHbo0mRm4=;
        b=WqxXxLeM6uVrkwaMcM1qnaiOsTlvixjVdsa7HDzGKBjmgUQuCxYGRozXHBggDXLdQB7tA8
        0WVIEKtbd/2R8Rj7ew4tv4wBu82hjwyHobqr/rexHbU2hr24j+FQYER9untAiTY1z5OsUM
        L3iZnCn4hELQOGxGTKA4hnbv9kigE3U=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-_pO0z4QnPyilqjrwXMINCw-1; Mon, 08 Nov 2021 00:09:53 -0500
X-MC-Unique: _pO0z4QnPyilqjrwXMINCw-1
Received: by mail-pj1-f72.google.com with SMTP id y18-20020a17090abd1200b001a4dcd1501cso6314812pjr.4
        for <ceph-devel@vger.kernel.org>; Sun, 07 Nov 2021 21:09:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=3+5hapKIdUPcBv9KiTx49+qcJGVnuve8mSmHbo0mRm4=;
        b=Qj60nJWIyZweem07Vi/H8xj+BNJBpq8Q93CRPaob9d6FnYY5Ts6GFxAJWo5r8aU8t7
         j83mMg6auQ5W13GCKTyejIpy8Jc8+RHqc9NfKN0SumSrp9GV0l61jEYpNeNgn/kuKO57
         ykWs5VMohs8GjGx23QC9s9KetHXE6n913wQtgSScEHIS+uiOg8wizp6UY6kunCxuOGy+
         puK6QTfb1skJsC8YU119PnEP6u97wzLfUuwITw8ta4pl9qe21+S+30TG9KDXOSh9CrJ7
         8J5OCSKw2RcX/ux+rNMpKT4xsProw56u1Q69MhhjVCPmm67Ord6+gQtNZMRAMUGjzt9J
         3JKw==
X-Gm-Message-State: AOAM531gHDENfDo+foG/AflJvAuBudDuoTnp35Ecf6T4vGIg8qR30Kpd
        0bDT8F7Zs3LtcoFvIba4FFzYE7NULjkVifib7Y9HKo4bZtdD9TnOIuqWkwboUuRRWF3p9LUR9bV
        f126DoqpI3wihP4ThT5BKpY+eADbKM6ROPUD5CX88+Nq0f7+jXEmhv9poaAlsDGgg7cdzaGs=
X-Received: by 2002:a05:6a00:1994:b0:49f:c47f:6e10 with SMTP id d20-20020a056a00199400b0049fc47f6e10mr9229763pfl.45.1636348191586;
        Sun, 07 Nov 2021 21:09:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxxjINqfFd+bPmJyH5jTjKmW1U4qqexHq9h20fvG8CnND02IfZgkL/ntmXttPv8Ihxn66wXLQ==
X-Received: by 2002:a05:6a00:1994:b0:49f:c47f:6e10 with SMTP id d20-20020a056a00199400b0049fc47f6e10mr9229725pfl.45.1636348191190;
        Sun, 07 Nov 2021 21:09:51 -0800 (PST)
Received: from [10.72.12.80] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a26sm3586320pfh.161.2021.11.07.21.09.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Nov 2021 21:09:50 -0800 (PST)
Subject: Re: [PATCH v7 3/9] ceph: fscrypt_file field handling in
 MClientRequest messages
From:   Xiubo Li <xiubli@redhat.com>
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org
References: <20211105142215.345566-1-xiubli@redhat.com>
 <20211105142215.345566-4-xiubli@redhat.com>
Message-ID: <9c32ef87-fa4d-cb52-4112-95c584f2d3a1@redhat.com>
Date:   Mon, 8 Nov 2021 13:09:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211105142215.345566-4-xiubli@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 11/5/21 10:22 PM, xiubli@redhat.com wrote:
> From: Jeff Layton <jlayton@kernel.org>
>
> For encrypted inodes, transmit a rounded-up size to the MDS as the
> normal file size and send the real inode size in fscrypt_file field.
>
> Also, fix up creates and truncates to also transmit fscrypt_file.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/dir.c        |  3 +++
>   fs/ceph/file.c       |  2 ++
>   fs/ceph/inode.c      | 18 ++++++++++++++++--
>   fs/ceph/mds_client.c |  9 ++++++++-
>   fs/ceph/mds_client.h |  2 ++
>   5 files changed, 31 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index 37c9c589ee27..987c1579614c 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -916,6 +916,9 @@ static int ceph_mknod(struct user_namespace *mnt_userns, struct inode *dir,
>   		goto out_req;
>   	}
>   
> +	if (S_ISREG(mode) && IS_ENCRYPTED(dir))
> +		set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
> +
>   	req->r_dentry = dget(dentry);
>   	req->r_num_caps = 2;
>   	req->r_parent = dir;
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 126d2d80686c..8c0b9ed7f48b 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -715,6 +715,8 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>   	req->r_args.open.mask = cpu_to_le32(mask);
>   	req->r_parent = dir;
>   	ihold(dir);
> +	if (IS_ENCRYPTED(dir))
> +		set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
>   
>   	if (flags & O_CREAT) {
>   		struct ceph_file_layout lo;
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index d24d42c94d43..4a7b2b0d88f7 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -2383,11 +2383,25 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
>   			}
>   		} else if ((issued & CEPH_CAP_FILE_SHARED) == 0 ||
>   			   attr->ia_size != isize) {
> -			req->r_args.setattr.size = cpu_to_le64(attr->ia_size);
> -			req->r_args.setattr.old_size = cpu_to_le64(isize);
>   			mask |= CEPH_SETATTR_SIZE;
>   			release |= CEPH_CAP_FILE_SHARED | CEPH_CAP_FILE_EXCL |
>   				   CEPH_CAP_FILE_RD | CEPH_CAP_FILE_WR;
> +			if (IS_ENCRYPTED(inode)) {
It should be "if (IS_ENCRYPTED(inode) && attr->ia_size) {".

If new size is 0, no need to round up it to BLOCK SIZE.


> +				set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
> +				mask |= CEPH_SETATTR_FSCRYPT_FILE;
> +				req->r_args.setattr.size =
> +					cpu_to_le64(round_up(attr->ia_size,
> +							     CEPH_FSCRYPT_BLOCK_SIZE));
> +				req->r_args.setattr.old_size =
> +					cpu_to_le64(round_up(isize,
> +							     CEPH_FSCRYPT_BLOCK_SIZE));
> +				req->r_fscrypt_file = attr->ia_size;
> +				/* FIXME: client must zero out any partial blocks! */
> +			} else {
> +				req->r_args.setattr.size = cpu_to_le64(attr->ia_size);
> +				req->r_args.setattr.old_size = cpu_to_le64(isize);
> +				req->r_fscrypt_file = 0;
> +			}
>   		}
>   	}
>   	if (ia_valid & ATTR_MTIME) {
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 69caea1d2444..e2d1b98c61fc 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2653,7 +2653,12 @@ static void encode_mclientrequest_tail(void **p, const struct ceph_mds_request *
>   	} else {
>   		ceph_encode_32(p, 0);
>   	}
> -	ceph_encode_32(p, 0); // fscrypt_file for now
> +	if (test_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags)) {
> +		ceph_encode_32(p, sizeof(__le64));
> +		ceph_encode_64(p, req->r_fscrypt_file);
> +	} else {
> +		ceph_encode_32(p, 0);
> +	}
>   }
>   
>   /*
> @@ -2739,6 +2744,8 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
>   
>   	/* fscrypt_file */
>   	len += sizeof(u32);
> +	if (test_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags))
> +		len += sizeof(__le64);
>   
>   	msg = ceph_msg_new2(CEPH_MSG_CLIENT_REQUEST, len, 1, GFP_NOFS, false);
>   	if (!msg) {
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 6a2ac489e06e..149a3a828472 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -276,6 +276,7 @@ struct ceph_mds_request {
>   #define CEPH_MDS_R_DID_PREPOPULATE	(6) /* prepopulated readdir */
>   #define CEPH_MDS_R_PARENT_LOCKED	(7) /* is r_parent->i_rwsem wlocked? */
>   #define CEPH_MDS_R_ASYNC		(8) /* async request */
> +#define CEPH_MDS_R_FSCRYPT_FILE		(9) /* must marshal fscrypt_file field */
>   	unsigned long	r_req_flags;
>   
>   	struct mutex r_fill_mutex;
> @@ -283,6 +284,7 @@ struct ceph_mds_request {
>   	union ceph_mds_request_args r_args;
>   
>   	struct ceph_fscrypt_auth *r_fscrypt_auth;
> +	u64	r_fscrypt_file;
>   
>   	u8 *r_altname;		    /* fscrypt binary crypttext for long filenames */
>   	u32 r_altname_len;	    /* length of r_altname */

