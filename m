Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9BA10AE69
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Nov 2019 12:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbfK0LDV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Nov 2019 06:03:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:34924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726194AbfK0LDU (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 27 Nov 2019 06:03:20 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0E8A206BF;
        Wed, 27 Nov 2019 11:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574852600;
        bh=ZxpmnJ4SlafAXmCbzmH/xaAr8A3KuzrHxWBIJzL9dYA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=aXSIT5PpPTytD3XkV0/yt2Ei/48Ge2qFS4n/bCW3QA99EJ7lJr6W87STYebSulw9g
         cXJXJDjzNttWXnfbxTU6F/TmhqFBrPa3a97jXIcdZ45XGDpaKLMbDzsNg4XAmYXWBw
         s3Moy0vWDJu3n6M5vW4+Ky22LQPz7wNFFrwTmYpc=
Message-ID: <59aea4ba392b1d9af65913d0da39f27b14dd0fcc.camel@kernel.org>
Subject: Re: [RFC PATCH] ceph: fix cap revoke race
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Wed, 27 Nov 2019 06:03:18 -0500
In-Reply-To: <20191127104549.33305-1-xiubli@redhat.com>
References: <20191127104549.33305-1-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1 (3.34.1-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2019-11-27 at 05:45 -0500, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> The cap->implemented is one subset of the cap->issued, the logic
> here want to exclude the revoking caps, but the following code
> will be (~cap->implemented | cap->issued) == 0xFFFF, so it will
> make no sense when we doing the "have &= 0xFFFF".
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/caps.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index c62e88da4fee..a9335402c2a5 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -812,7 +812,7 @@ int __ceph_caps_issued(struct ceph_inode_info *ci, int *implemented)
>  	 */
>  	if (ci->i_auth_cap) {
>  		cap = ci->i_auth_cap;
> -		have &= ~cap->implemented | cap->issued;
> +		have &= ~(cap->implemented & ~cap->issued);
>  	}
>  	return have;
>  }

Nice catch. This patch looks correct to me. I'll merge it into the
testing branch and we'll see if anything breaks.
-- 
Jeff Layton <jlayton@kernel.org>

