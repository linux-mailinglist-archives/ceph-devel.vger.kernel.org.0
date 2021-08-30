Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46F623FB64F
	for <lists+ceph-devel@lfdr.de>; Mon, 30 Aug 2021 14:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236652AbhH3MqG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 30 Aug 2021 08:46:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:38818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229957AbhH3MqG (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 30 Aug 2021 08:46:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71E1760F35;
        Mon, 30 Aug 2021 12:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630327513;
        bh=YSTiM9bjcgYuxAoh1SgEuEVsn+8p8ADJDO/9sCeUCzg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=NEqX+hKz1s+vdLb1EOARpoG+tM80NuRAfpTIushRUD8T0ot4W4um/YMRJX74IeTFI
         +pkLGz17JodjH1CE0bIKUKSYSUv81fev04vx+kAFS0kR3ptWTQipfGJJ+FYlrUNvvK
         y4IK23u8OhEiX9P5H1msYdpXWZdixQ7mqgYByQYkxid1GEChug7AwKpUQHPqrYx+D8
         kg4e0eHXaU7wRL3IoLNO/Wtun5STqfQXNYifdniQAQmgFZMnE4+r5pEBHds5VQN9bu
         6NDtqqzmy88BfW+54k82L6UydKAoEyMUkMcdu2dLhDXmrK7uMvEBmoId5PsjBi1Evq
         CFhM84iXVXJ7A==
Message-ID: <4b2691ea8c503fcd0e1b25a61155bca8fe0cc2fd.camel@kernel.org>
Subject: Re: [PATCH] ceph: fix incorrectly counting the export targets
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
Date:   Mon, 30 Aug 2021 08:45:11 -0400
In-Reply-To: <20210830123326.487715-1-xiubli@redhat.com>
References: <20210830123326.487715-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2021-08-30 at 20:33 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mds_client.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 7ddc36c14b92..aa0ab069db40 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4434,7 +4434,7 @@ static void check_new_map(struct ceph_mds_client *mdsc,
>  			  struct ceph_mdsmap *newmap,
>  			  struct ceph_mdsmap *oldmap)
>  {
> -	int i, err;
> +	int i, j, err;
>  	int oldstate, newstate;
>  	struct ceph_mds_session *s;
>  	unsigned long targets[DIV_ROUND_UP(CEPH_MAX_MDS, sizeof(unsigned long))] = {0};
> @@ -4443,8 +4443,10 @@ static void check_new_map(struct ceph_mds_client *mdsc,
>  	     newmap->m_epoch, oldmap->m_epoch);
>  
>  	if (newmap->m_info) {
> -		for (i = 0; i < newmap->m_info->num_export_targets; i++)
> -			set_bit(newmap->m_info->export_targets[i], targets);
> +		for (i = 0; i < newmap->m_num_active_mds; i++) {
> +			for (j = 0; j < newmap->m_info[i].num_export_targets; j++)
> +				set_bit(newmap->m_info[i].export_targets[j], targets);
> +		}
>  	}
>  
>  	for (i = 0; i < oldmap->possible_max_rank && i < mdsc->max_sessions; i++) {

Looks sane. I'll plan to fold this into "ceph: reconnect to the export
targets on new mdsmaps".

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

