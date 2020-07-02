Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 849E0211B37
	for <lists+ceph-devel@lfdr.de>; Thu,  2 Jul 2020 06:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbgGBEn4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 2 Jul 2020 00:43:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41964 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725994AbgGBEnz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 2 Jul 2020 00:43:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593665034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zq8uAZvXEjskrDaHpsoitFHpjm6H2gAHz06ltxiF+XI=;
        b=GMilt+mwhum+USo+w6UToowUl5eHEkUOtC7j01ShzXDK2qUWrwDSYbE/aXZ03cFQiEDT0a
        P3URScmuBPo1NNr+j60UBGJ2E9OVq+ZKQp26UTGOG0auSZ5LAqR1a8mZkKYaLqskCJ+YJS
        +OXAXOBDxNfmgKYtHisPA7ghzZKA2Iw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-83-ClYuYNxENk-J7ibzL9YmWw-1; Thu, 02 Jul 2020 00:43:53 -0400
X-MC-Unique: ClYuYNxENk-J7ibzL9YmWw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1B01F57092;
        Thu,  2 Jul 2020 04:43:52 +0000 (UTC)
Received: from [10.72.12.116] (ovpn-12-116.pek2.redhat.com [10.72.12.116])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2CB375C1C5;
        Thu,  2 Jul 2020 04:43:50 +0000 (UTC)
Subject: Re: [PATCH] ceph: clean up and optimize ceph_check_delayed_caps
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
References: <20200701133500.26613-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <cc37c363-077d-559e-5643-d54674f22260@redhat.com>
Date:   Thu, 2 Jul 2020 12:43:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200701133500.26613-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/7/1 21:35, Jeff Layton wrote:
> Make this loop look a bit more sane. Also optimize away the spinlock
> release/reacquire if we can't get an inode reference.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/caps.c | 10 ++++------
>   1 file changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 5f4894063a73..55ccccf77cea 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -4189,10 +4189,8 @@ void ceph_check_delayed_caps(struct ceph_mds_client *mdsc)
>   	struct ceph_inode_info *ci;
>   
>   	dout("check_delayed_caps\n");
> -	while (1) {
> -		spin_lock(&mdsc->cap_delay_lock);
> -		if (list_empty(&mdsc->cap_delay_list))
> -			break;
> +	spin_lock(&mdsc->cap_delay_lock);
> +	while (!list_empty(&mdsc->cap_delay_list)) {
>   		ci = list_first_entry(&mdsc->cap_delay_list,
>   				      struct ceph_inode_info,
>   				      i_cap_delay_list);
> @@ -4202,13 +4200,13 @@ void ceph_check_delayed_caps(struct ceph_mds_client *mdsc)
>   		list_del_init(&ci->i_cap_delay_list);
>   
>   		inode = igrab(&ci->vfs_inode);
> -		spin_unlock(&mdsc->cap_delay_lock);
> -
>   		if (inode) {
> +			spin_unlock(&mdsc->cap_delay_lock);
>   			dout("check_delayed_caps on %p\n", inode);
>   			ceph_check_caps(ci, 0, NULL);
>   			/* avoid calling iput_final() in tick thread */
>   			ceph_async_iput(inode);
> +			spin_lock(&mdsc->cap_delay_lock);
>   		}
>   	}
>   	spin_unlock(&mdsc->cap_delay_lock);

Reviewed-by: Xiubo Li <xiubli@redhat.com>


