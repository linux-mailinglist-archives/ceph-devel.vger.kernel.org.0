Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC345138D85
	for <lists+ceph-devel@lfdr.de>; Mon, 13 Jan 2020 10:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbgAMJRX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 13 Jan 2020 04:17:23 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48436 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726399AbgAMJRX (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 13 Jan 2020 04:17:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578907041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hSYalo05OBDmeVt35nA6/NcPZZO476eakh4B6d3MqbI=;
        b=cfCBxq4r4mZ/90/tHA2i2AnmgFYgHEU8lgd6Pw29Ng42SRFEhoDxicaECPOy16uLwFo+m1
        aAn0cBs/bEF6T/F/Va9ZCre0t6y1vFMMqhUktz0cDt3fELFTde4xrMCJ3wPj6GeHth3siC
        DFDQB+q9qU2QET8ZAE2EVtRgb84iMl0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-87-tTWTCQcMNT2YjyhS92R7qg-1; Mon, 13 Jan 2020 04:17:18 -0500
X-MC-Unique: tTWTCQcMNT2YjyhS92R7qg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E05AE801E76;
        Mon, 13 Jan 2020 09:17:16 +0000 (UTC)
Received: from [10.72.12.218] (ovpn-12-218.pek2.redhat.com [10.72.12.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EE8287D642;
        Mon, 13 Jan 2020 09:17:11 +0000 (UTC)
Subject: Re: [RFC PATCH 7/9] ceph: add flag to delegate an inode number for
 async create
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, pdonnell@redhat.com
References: <20200110205647.311023-1-jlayton@kernel.org>
 <20200110205647.311023-8-jlayton@kernel.org>
From:   "Yan, Zheng" <zyan@redhat.com>
Message-ID: <056df2f9-07b9-a5ac-f4f3-861b8a364ff3@redhat.com>
Date:   Mon, 13 Jan 2020 17:17:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200110205647.311023-8-jlayton@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 1/11/20 4:56 AM, Jeff Layton wrote:
> In order to issue an async create request, we need to send an inode
> number when we do the request, but we don't know which to which MDS
> we'll be issuing the request.
> 

the request should be sent to auth mds (dir_ci->i_auth_cap->session) of 
directory. I think grabing inode number in get_caps_for_async_create() 
is simpler.

> Add a new r_req_flag that tells the request sending machinery to
> grab an inode number from the delegated set, and encode it into the
> request. If it can't get one then have it return -ECHILD. The
> requestor can then reissue a synchronous request.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/inode.c      |  1 +
>   fs/ceph/mds_client.c | 19 ++++++++++++++++++-
>   fs/ceph/mds_client.h |  2 ++
>   3 files changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 79bb1e6af090..9cfc093fd273 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -1317,6 +1317,7 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
>   		err = ceph_fill_inode(in, req->r_locked_page, &rinfo->targeti,
>   				NULL, session,
>   				(!test_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags) &&
> +				 !test_bit(CEPH_MDS_R_DELEG_INO, &req->r_req_flags) &&
>   				 rinfo->head->result == 0) ?  req->r_fmode : -1,
>   				&req->r_caps_reservation);
>   		if (err < 0) {
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 852c46550d96..9e7492b21b50 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2623,7 +2623,10 @@ static int __prepare_send_request(struct ceph_mds_client *mdsc,
>   	rhead->flags = cpu_to_le32(flags);
>   	rhead->num_fwd = req->r_num_fwd;
>   	rhead->num_retry = req->r_attempts - 1;
> -	rhead->ino = 0;
> +	if (test_bit(CEPH_MDS_R_DELEG_INO, &req->r_req_flags))
> +		rhead->ino = cpu_to_le64(req->r_deleg_ino);
> +	else
> +		rhead->ino = 0;
>   
>   	dout(" r_parent = %p\n", req->r_parent);
>   	return 0;
> @@ -2736,6 +2739,20 @@ static void __do_request(struct ceph_mds_client *mdsc,
>   		goto out_session;
>   	}
>   
> +	if (test_bit(CEPH_MDS_R_DELEG_INO, &req->r_req_flags) &&
> +	    !req->r_deleg_ino) {
> +		req->r_deleg_ino = get_delegated_ino(req->r_session);
> +
> +		if (!req->r_deleg_ino) {
> +			/*
> +			 * If we can't get a deleg ino, exit with -ECHILD,
> +			 * so the caller can reissue a sync request
> +			 */
> +			err = -ECHILD;
> +			goto out_session;
> +		}
> +	}
> +
>   	/* send request */
>   	req->r_resend_mds = -1;   /* forget any previous mds hint */
>   
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 3db7ef47e1c9..e0b36be7c44f 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -258,6 +258,7 @@ struct ceph_mds_request {
>   #define CEPH_MDS_R_GOT_RESULT		(5) /* got a result */
>   #define CEPH_MDS_R_DID_PREPOPULATE	(6) /* prepopulated readdir */
>   #define CEPH_MDS_R_PARENT_LOCKED	(7) /* is r_parent->i_rwsem wlocked? */
> +#define CEPH_MDS_R_DELEG_INO		(8) /* attempt to get r_deleg_ino */
>   	unsigned long	r_req_flags;
>   
>   	struct mutex r_fill_mutex;
> @@ -307,6 +308,7 @@ struct ceph_mds_request {
>   	int               r_num_fwd;    /* number of forward attempts */
>   	int               r_resend_mds; /* mds to resend to next, if any*/
>   	u32               r_sent_on_mseq; /* cap mseq request was sent at*/
> +	unsigned long	  r_deleg_ino;
>   
>   	struct list_head  r_wait;
>   	struct completion r_completion;
> 

