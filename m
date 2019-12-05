Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2525E1142AE
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Dec 2019 15:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729240AbfLEO1v (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 5 Dec 2019 09:27:51 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33855 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729099AbfLEO1u (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 5 Dec 2019 09:27:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575556069;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z5iA0GGbSWVRIrJpxqreIFaCrP3R35UY8flqQ3D3tjo=;
        b=bvXfPIK2aiepL3sElS7UtZlm4a89ZbOp8AzRAc2W/lHGrBmWbPXyHo6qJK5nqWjisOQXqu
        wnBSjibrrjU5rIcQY/NFq/KrCwFjAxGSDksaHqBjfcjU+Q/0Iyw39xg2VdiOV+JNK63z5K
        GarN/dv6a0og2z9N2UySUsF128Fy9GM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-hQaVgjxKNXepKrgZpLy4ng-1; Thu, 05 Dec 2019 09:27:45 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6BE6F1010FE1;
        Thu,  5 Dec 2019 14:27:44 +0000 (UTC)
Received: from [10.72.12.69] (ovpn-12-69.pek2.redhat.com [10.72.12.69])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8F5E33C1D;
        Thu,  5 Dec 2019 14:27:40 +0000 (UTC)
Subject: Re: [PATCH] ceph: drop unused ttl_from parameter from fill_inode
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com
References: <20191204203120.12355-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <eba38db7-38ca-8990-8e0a-b5cc22ada344@redhat.com>
Date:   Thu, 5 Dec 2019 22:27:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191204203120.12355-1-jlayton@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: hQaVgjxKNXepKrgZpLy4ng-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2019/12/5 4:31, Jeff Layton wrote:
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/inode.c | 15 ++++++---------
>   1 file changed, 6 insertions(+), 9 deletions(-)
>
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index c07407586ce8..5bdc1afc2bee 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -728,8 +728,7 @@ void ceph_fill_file_time(struct inode *inode, int issued,
>   static int fill_inode(struct inode *inode, struct page *locked_page,
>   		      struct ceph_mds_reply_info_in *iinfo,
>   		      struct ceph_mds_reply_dirfrag *dirinfo,
> -		      struct ceph_mds_session *session,
> -		      unsigned long ttl_from, int cap_fmode,
> +		      struct ceph_mds_session *session, int cap_fmode,
>   		      struct ceph_cap_reservation *caps_reservation)
>   {
>   	struct ceph_mds_client *mdsc = ceph_inode_to_client(inode)->mdsc;
> @@ -1237,7 +1236,7 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
>   		if (dir) {
>   			err = fill_inode(dir, NULL,
>   					 &rinfo->diri, rinfo->dirfrag,
> -					 session, req->r_request_started, -1,
> +					 session, -1,
>   					 &req->r_caps_reservation);
>   			if (err < 0)
>   				goto done;
> @@ -1305,9 +1304,9 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
>   		req->r_target_inode = in;
>   
>   		err = fill_inode(in, req->r_locked_page, &rinfo->targeti, NULL,
> -				session, req->r_request_started,
> +				session,
>   				(!test_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags) &&
> -				rinfo->head->result == 0) ?  req->r_fmode : -1,
> +				 rinfo->head->result == 0) ?  req->r_fmode : -1,
>   				&req->r_caps_reservation);
>   		if (err < 0) {
>   			pr_err("fill_inode badness %p %llx.%llx\n",
> @@ -1493,8 +1492,7 @@ static int readdir_prepopulate_inodes_only(struct ceph_mds_request *req,
>   			continue;
>   		}
>   		rc = fill_inode(in, NULL, &rde->inode, NULL, session,
> -				req->r_request_started, -1,
> -				&req->r_caps_reservation);
> +				-1, &req->r_caps_reservation);
>   		if (rc < 0) {
>   			pr_err("fill_inode badness on %p got %d\n", in, rc);
>   			err = rc;
> @@ -1694,8 +1692,7 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
>   		}
>   
>   		ret = fill_inode(in, NULL, &rde->inode, NULL, session,
> -				 req->r_request_started, -1,
> -				 &req->r_caps_reservation);
> +				 -1, &req->r_caps_reservation);
>   		if (ret < 0) {
>   			pr_err("fill_inode badness on %p\n", in);
>   			if (d_really_is_negative(dn)) {

Looks good to me.

BRs

