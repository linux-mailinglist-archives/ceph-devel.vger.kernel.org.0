Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CEE810C23E
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Nov 2019 03:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbfK1CZZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Nov 2019 21:25:25 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:59520 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726695AbfK1CZZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 27 Nov 2019 21:25:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574907924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d9kX4A7lLCiI8eryUNTphgWrQr0tu1m9NnRQJn3d1Z0=;
        b=POMrJJLvDFKbcV8oJBP/5GeafFbJ8zpzK2QtbnpjQ3MpHyNm2+1ACXegGcXBSZAOEFgoEv
        gPGIkNdNGilKNAfwOwD9NL0E/GuykMbQfvAmPP/xGppsjd74FyZSYWQF6tQG7BserSGDhX
        pqvKk0ACkdk5CaZMMms/Y1YMyBj8cjM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-rBrLeKJIO02A0-KwXdsvKQ-1; Wed, 27 Nov 2019 21:25:22 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CA05E8017D9;
        Thu, 28 Nov 2019 02:25:21 +0000 (UTC)
Received: from [10.72.12.209] (ovpn-12-209.pek2.redhat.com [10.72.12.209])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B492D10016DA;
        Thu, 28 Nov 2019 02:25:16 +0000 (UTC)
Subject: Re: [RFC PATCH] ceph: fix cap revoke race
To:     xiubli@redhat.com, jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
References: <20191127104549.33305-1-xiubli@redhat.com>
From:   "Yan, Zheng" <zyan@redhat.com>
Message-ID: <26da58b0-9e6a-70a8-641e-65b2c6ee075a@redhat.com>
Date:   Thu, 28 Nov 2019 10:25:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191127104549.33305-1-xiubli@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: rBrLeKJIO02A0-KwXdsvKQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 11/27/19 6:45 PM, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> The cap->implemented is one subset of the cap->issued, the logic
> here want to exclude the revoking caps, but the following code
> will be (~cap->implemented | cap->issued) == 0xFFFF, so it will
> make no sense when we doing the "have &= 0xFFFF".
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>   fs/ceph/caps.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index c62e88da4fee..a9335402c2a5 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -812,7 +812,7 @@ int __ceph_caps_issued(struct ceph_inode_info *ci, int *implemented)
>   	 */
>   	if (ci->i_auth_cap) {
>   		cap = ci->i_auth_cap;
> -		have &= ~cap->implemented | cap->issued;
> +		have &= ~(cap->implemented & ~cap->issued);

The end result is the same.

See https://en.wikipedia.org/wiki/De_Morgan%27s_laws

>   	}
>   	return have;
>   }
> 

