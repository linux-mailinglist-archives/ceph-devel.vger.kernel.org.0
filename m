Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7455556BCE
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Jun 2019 16:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbfFZOZr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 26 Jun 2019 10:25:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33762 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727516AbfFZOZp (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 26 Jun 2019 10:25:45 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 25304330265;
        Wed, 26 Jun 2019 14:25:45 +0000 (UTC)
Received: from [10.72.12.33] (ovpn-12-33.pek2.redhat.com [10.72.12.33])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 543375D719;
        Wed, 26 Jun 2019 14:25:39 +0000 (UTC)
Subject: Re: [PATCH] MAINTAINERS: take over for Zheng as CephFS kernel client
 maintainer
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com,
        sage@redhat.com
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190626112633.12267-1-jlayton@kernel.org>
From:   "Yan, Zheng" <zyan@redhat.com>
Message-ID: <fabceaeb-abe8-243a-8978-157cbd0bbcca@redhat.com>
Date:   Wed, 26 Jun 2019 22:25:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190626112633.12267-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Wed, 26 Jun 2019 14:25:45 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 6/26/19 7:26 PM, Jeff Layton wrote:
> Zheng wants to be able to spend more time working on the MDS, so I've
> volunteered to take over for him as the CephFS kernel client maintainer.
> 

ACK

Thanks
Yan, Zheng

> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   MAINTAINERS | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Zheng, I'm assuming for now that you don't want to stay on as
> co-maintainer. Let me know if that's incorrect and I'll resend.
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index d0ed735994a5..8836f9eb2ff0 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3715,7 +3715,7 @@ F:	arch/powerpc/platforms/cell/
>   
>   CEPH COMMON CODE (LIBCEPH)
>   M:	Ilya Dryomov <idryomov@gmail.com>
> -M:	"Yan, Zheng" <zyan@redhat.com>
> +M:	Jeff Layton <jlayton@kernel.org>
>   M:	Sage Weil <sage@redhat.com>
>   L:	ceph-devel@vger.kernel.org
>   W:	http://ceph.com/
> @@ -3727,7 +3727,7 @@ F:	include/linux/ceph/
>   F:	include/linux/crush/
>   
>   CEPH DISTRIBUTED FILE SYSTEM CLIENT (CEPH)
> -M:	"Yan, Zheng" <zyan@redhat.com>
> +M:	Jeff Layton <jlayton@kernel.org>
>   M:	Sage Weil <sage@redhat.com>
>   M:	Ilya Dryomov <idryomov@gmail.com>
>   L:	ceph-devel@vger.kernel.org
> 

