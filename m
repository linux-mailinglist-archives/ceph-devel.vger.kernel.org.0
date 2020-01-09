Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC998135139
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Jan 2020 03:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727797AbgAICFR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Jan 2020 21:05:17 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:58644 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727754AbgAICFR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Jan 2020 21:05:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578535516;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Is9+XpUwctB6N8JjNMp+e+lV5Z3WYWXHEl1GuFSJn44=;
        b=TEea/SJmULARSuo2X7seDbk4IMGRV70joF1/3BOCtLUvqEzW/cS9glwnic+Yr81eUzmE+l
        NLbz5/x7+ie7HP/IdJTfAP6PgujUiptyDtF0mix32m6ntajXLf0ly5Hi9LY3qC9xz/cywY
        7eF831rsPRAV7vxS3owgTc1UUuVyEQE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-7ENgSSpePX-ew62sx-419w-1; Wed, 08 Jan 2020 21:05:13 -0500
X-MC-Unique: 7ENgSSpePX-ew62sx-419w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F5C8180747E;
        Thu,  9 Jan 2020 02:05:12 +0000 (UTC)
Received: from [10.72.12.70] (ovpn-12-70.pek2.redhat.com [10.72.12.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 92CC4100EBAF;
        Thu,  9 Jan 2020 02:05:07 +0000 (UTC)
Subject: Re: [PATCH 2/6] ceph: hold extra reference to r_parent over life of
 request
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com
References: <20200106153520.307523-1-jlayton@kernel.org>
 <20200106153520.307523-3-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <e8e28503-bda4-df57-6a42-33761e716fe4@redhat.com>
Date:   Thu, 9 Jan 2020 10:05:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200106153520.307523-3-jlayton@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/1/6 23:35, Jeff Layton wrote:
> Currently, we just assume that it will stick around by virtue of the
> submitter's reference, but later patches will allow the syscall to
> return early and we can't rely on that reference at that point.
>
> Take an extra reference to the inode when setting r_parent and release
> it when releasing the request.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/mds_client.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 94cce2ab92c4..b7122f682678 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -708,8 +708,10 @@ void ceph_mdsc_release_request(struct kref *kref)
>   		/* avoid calling iput_final() in mds dispatch threads */
>   		ceph_async_iput(req->r_inode);
>   	}
> -	if (req->r_parent)
> +	if (req->r_parent) {
>   		ceph_put_cap_refs(ceph_inode(req->r_parent), CEPH_CAP_PIN);
> +		ceph_async_iput(req->r_parent);
> +	}
>   	ceph_async_iput(req->r_target_inode);
>   	if (req->r_dentry)
>   		dput(req->r_dentry);
> @@ -2706,8 +2708,10 @@ int ceph_mdsc_submit_request(struct ceph_mds_cli=
ent *mdsc, struct inode *dir,
>   	/* take CAP_PIN refs for r_inode, r_parent, r_old_dentry */
>   	if (req->r_inode)
>   		ceph_get_cap_refs(ceph_inode(req->r_inode), CEPH_CAP_PIN);
> -	if (req->r_parent)
> +	if (req->r_parent) {
>   		ceph_get_cap_refs(ceph_inode(req->r_parent), CEPH_CAP_PIN);
> +		ihold(req->r_parent);
> +	}

This might also fix another issue when the mdsc request is timedout and=20
returns to the vfs, then the r_parent maybe released in vfs. And then if=20
we reference it again in mdsc handle_reply() -->=20
ceph_mdsc_release_request(),=A0 some unknown issues may happen later ??

>   	if (req->r_old_dentry_dir)
>   		ceph_get_cap_refs(ceph_inode(req->r_old_dentry_dir),
>   				  CEPH_CAP_PIN);


