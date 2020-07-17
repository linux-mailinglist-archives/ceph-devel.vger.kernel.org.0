Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57201223CCA
	for <lists+ceph-devel@lfdr.de>; Fri, 17 Jul 2020 15:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbgGQNcF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 17 Jul 2020 09:32:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:57908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726071AbgGQNcF (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 17 Jul 2020 09:32:05 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A30C02067D;
        Fri, 17 Jul 2020 13:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594992725;
        bh=lypO88vViudCCBqi2yqYxbtZLyKrjPgi3zWkx5CX8TE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=2f+/S1o9JadnUG183BhR8/oJsLd46Iy8EsyV3Z5PL4dWJjGSnlXdg1H/olfl5LHhj
         u/pnY4yKBUByMDgScaQ7StrPW+sYCiuBg2BpLsN82PcJNFhSCCaDHxOONvgyUIm/r2
         G2OmwuBLKQ4rn/FI/AREuZ0fJJvgPg2gnQdif0oM=
Message-ID: <efcd42ccc33c8e4a78ceb3c749e56a952e3989b2.camel@kernel.org>
Subject: Re: [PATCH] ceph: check the sesion state and return false in case
 it is closed
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, zyan@redhat.com,
        pdonnell@redhat.com, vshankar@redhat.com
Date:   Fri, 17 Jul 2020 09:32:03 -0400
In-Reply-To: <20200717132513.8845-1-xiubli@redhat.com>
References: <20200717132513.8845-1-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2020-07-17 at 09:25 -0400, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> If the session is already in closed state, we should skip it.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mds_client.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 887874f8ad2c..2af773168a0a 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4302,6 +4302,7 @@ bool check_session_state(struct ceph_mds_session *s)
>  	}
>  	if (s->s_state == CEPH_MDS_SESSION_NEW ||
>  	    s->s_state == CEPH_MDS_SESSION_RESTARTING ||
> +	    s->s_state == CEPH_MDS_SESSION_CLOSED ||
>  	    s->s_state == CEPH_MDS_SESSION_REJECTED)
>  		/* this mds is failed or recovering, just wait */
>  		return false;

Looks good. I merged this into testing and rebased the metrics patches
on top.

Thanks!
-- 
Jeff Layton <jlayton@kernel.org>

