Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5C151351C
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Apr 2022 15:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241440AbiD1NcV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 28 Apr 2022 09:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234938AbiD1NcT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 28 Apr 2022 09:32:19 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7118BB2449
        for <ceph-devel@vger.kernel.org>; Thu, 28 Apr 2022 06:29:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AB75ACE2AE4
        for <ceph-devel@vger.kernel.org>; Thu, 28 Apr 2022 13:29:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57A04C385A0;
        Thu, 28 Apr 2022 13:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651152541;
        bh=TDdhrF+2KxInRYlxGGL1PMUr8GHBT/nvL6hH90RX3UU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fmMqC3GGwWaFbipvbgMAjyXl7RPmbvOeYVsSYJuficY66ssKRlnRQ895j2OslLw9S
         iRirHbPMAm6prPotStTEnmHaMrdW74nS17ODInyX+pcebuFcagOFKXOK6ozI83OnxU
         nsCWad622SR/O937cHTlSQ2cUWj5gylNNuJnsaPldc46ESnldLpgOJ6ndqD4jU0XgK
         CDTK7rBKFld6eG1VAHYHHM0TsYs8nZUdLeihW1HvCsFQJW/Ekoelor2fIL50zBw2rP
         WMpq2+CezopXqHEv6L9KvgHqh1yx/1qa+s+DHQcxrf4Bkrhl5LJb0QUGnpyDfdNNL/
         8nParmFtlKXdQ==
Message-ID: <9a7549be9fda80b7223b2704cc97afec485a01e9.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: don't retain the caps if they're being revoked
 and not used
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Thu, 28 Apr 2022 09:28:56 -0400
In-Reply-To: <20220428132344.94413-1-xiubli@redhat.com>
References: <20220428132344.94413-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2022-04-28 at 21:23 +0800, Xiubo Li wrote:
> For example if the Frwcb caps are being revoked, but only the Fr
> caps is still being used then the kclient will skip releasing them
> all. But in next turn if the Fr caps is ready to be released the
> Fw caps maybe just being used again. So in corner case, such as
> heavy load IOs, the revocation maybe stuck for a long time.
> 
> URL: https://tracker.ceph.com/issues/46904
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/caps.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 22dae29be64d..bf9243795f3b 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -1978,6 +1978,12 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
>  		}
>  	}
>  
> +	/*
> +	 * Do not retain the capabilities if they are being revoked
> +	 * but not used, this could help speed up the revoking.
> +	 */
> +	retain &= ~(revoking & ~used);
> +
>  	dout("check_caps %llx.%llx file_want %s used %s dirty %s flushing %s"
>  	     " issued %s revoking %s retain %s %s%s\n", ceph_vinop(inode),
>  	     ceph_cap_string(file_wanted),

Reviewed-by: Jeff Layton <jlayton@kernel.org>
