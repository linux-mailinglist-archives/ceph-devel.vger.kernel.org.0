Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC521815C5
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Mar 2020 11:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729007AbgCKK2U (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Mar 2020 06:28:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:40716 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726000AbgCKK2U (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 11 Mar 2020 06:28:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 99B84B1DA;
        Wed, 11 Mar 2020 10:28:18 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 11 Mar 2020 11:28:18 +0100
From:   Roman Penyaev <rpenyaev@suse.de>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org
Subject: Re: [PATCH] libceph: fix alloc_msg_with_page_vector() memory leaks
In-Reply-To: <20200310195037.9518-1-idryomov@gmail.com>
References: <20200310195037.9518-1-idryomov@gmail.com>
Message-ID: <285a12636f1d70c09ae4e9b04b7dd3c7@suse.de>
X-Sender: rpenyaev@suse.de
User-Agent: Roundcube Webmail
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020-03-10 20:50, Ilya Dryomov wrote:

[skip]

> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index 51810db4130a..998e26b75a78 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -962,7 +962,7 @@ static void ceph_osdc_msg_data_add(struct ceph_msg 
> *msg,
>  		BUG_ON(length > (u64) SIZE_MAX);
>  		if (length)
>  			ceph_msg_data_add_pages(msg, osd_data->pages,
> -					length, osd_data->alignment);
> +					length, osd_data->alignment, false);

Now I got the point when you were saying "that would break OSDs which
supply its own page vector". The callers of ceph_osdc_msg_data_add()
always own the pages, understood.

If necessary
Reviewed-by: Roman Penyaev <rpenyaev@suse.de>

--
Roman

