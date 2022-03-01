Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7AAD4C8E0E
	for <lists+ceph-devel@lfdr.de>; Tue,  1 Mar 2022 15:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbiCAOnx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 1 Mar 2022 09:43:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232374AbiCAOnv (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 1 Mar 2022 09:43:51 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9515F1EAD8
        for <ceph-devel@vger.kernel.org>; Tue,  1 Mar 2022 06:43:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 94E7CCE1BA9
        for <ceph-devel@vger.kernel.org>; Tue,  1 Mar 2022 14:43:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C2D6C340EE;
        Tue,  1 Mar 2022 14:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646145786;
        bh=k1vkrCbPRpzt13FMC3lK1W5xA+nG7vjqIRpNTL43QKk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=pmvcnuhhio7hkJWannyHywECCdWM7BBpTWY7sPCsWsUy7Lxx/VVDCJ8OAFAWIsNp6
         EAI/kntDG4KIu/aPhYqXQVuuTh7Q66bmmYokI+/TyIDpRyGVPFpPjMillDv4eXTMoT
         d3tls+le1rQCZpMFNH/IA6j0k8lkukZR8wS2IFQp9tf1lypAI/LuNmQVVmEPZNyZPM
         /kN5flNIXG7cSnD1kaBREuBU6f+B0XzZ1E3tD2EwseZvnjYU8EDjhNygSOUBhC1IXn
         J1EekMFGmLJ8YcT6OjEK1oXxETtmvYR0qqUmUOj/0qjCzSF42H349P+MgtA/oZXQ6j
         Tcrn90G+IY0IQ==
Message-ID: <5c32c1228db8bd8916665e02c0bf70d70ba89e4e.camel@kernel.org>
Subject: Re: [PATCH v3] ceph: skip the memories when received a higher
 version of message
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Tue, 01 Mar 2022 09:43:04 -0500
In-Reply-To: <20220301143927.513492-1-xiubli@redhat.com>
References: <20220301143927.513492-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2022-03-01 at 22:39 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> We should skip the extra memories which are from the higher version
> just likes the libcephfs client does.
> 
> URL: https://tracker.ceph.com/issues/54430
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mds_client.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 94b4c6508044..608d077f2eeb 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -313,6 +313,7 @@ static int parse_reply_info_lease(void **p, void *end,
>  {
>  	u8 struct_v;
>  	u32 struct_len;
> +	void *lend;
>  
>  	if (features == (u64)-1) {
>  		u8 struct_compat;
> @@ -332,6 +333,7 @@ static int parse_reply_info_lease(void **p, void *end,
>  		*altname = NULL;
>  	}
>  
> +	lend = *p + struct_len;
>  	ceph_decode_need(p, end, struct_len, bad);
>  	*lease = *p;
>  	*p += sizeof(**lease);
> @@ -347,6 +349,7 @@ static int parse_reply_info_lease(void **p, void *end,
>  			*altname_len = 0;
>  		}
>  	}
> +	*p = lend;
>  	return 0;
>  bad:
>  	return -EIO;

Feel free to fold this into the appropriate patch in wip-fscrypt if you
like...

Reviewed-by: Jeff Layton <jlayton@kernel.org>
