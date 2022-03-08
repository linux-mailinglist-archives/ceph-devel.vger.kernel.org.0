Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D14A94D194E
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Mar 2022 14:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347146AbiCHNiH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Mar 2022 08:38:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347210AbiCHNiD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 8 Mar 2022 08:38:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E100448E78
        for <ceph-devel@vger.kernel.org>; Tue,  8 Mar 2022 05:37:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 833C3B81852
        for <ceph-devel@vger.kernel.org>; Tue,  8 Mar 2022 13:37:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 918B5C340EB;
        Tue,  8 Mar 2022 13:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646746624;
        bh=daV1h/ZNiGzIHJJjKlBniOoZG6YTDnjWe64AyygId/Q=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cplroXZFbGoRQ1+cjD2wk8sk+ja50CYvSpm7VNfcbqeU7m97NihXfS8SUBGF+H5hJ
         cCBBE5ZextF4ZEqso3BCWcHRjIxyhZxmiU1OwvJDgnYg4S9Z8beMF5PquS2BEP0D6k
         Tz6wLO/rFoNat8IcCEnm5VBRn4JxKOEYf2tLisHQI7itz/zbgIu1SRnJRJarZuBjkK
         fjvS4TzUoMF/blcdtublpvEWHAEcWM6bhwlS1mj83Nnlb4c7Wx9iNSOHCT5OPF+K05
         KlLod+aEptar3gLKqSOTwygiwSvK5izwDVmSOM34G5f9r5Pf7fkiEtS+fV/etDpUj5
         37idWvJKhVsbw==
Message-ID: <d8836bda20bdf1c23a42045e002d99165481230e.camel@kernel.org>
Subject: Re: [PATCH v2] libceph: wait for con->work to finish when
 cancelling con
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Tue, 08 Mar 2022 08:37:02 -0500
In-Reply-To: <20220308132322.1309992-1-xiubli@redhat.com>
References: <20220308132322.1309992-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2022-03-08 at 21:23 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> When reconnecting MDS it will reopen the con with new ip address,
> but the when opening the con with new address it couldn't be sure
> that the stale work has finished. So it's possible that the stale
> work queued will use the new data.
> 
> This will use cancel_delayed_work_sync() instead.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
> 
> V2:
> - Call cancel_con() after dropping the mutex
> 
> 
>  net/ceph/messenger.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
> index d3bb656308b4..62e39f63f94c 100644
> --- a/net/ceph/messenger.c
> +++ b/net/ceph/messenger.c
> @@ -581,8 +581,8 @@ void ceph_con_close(struct ceph_connection *con)
>  
>  	ceph_con_reset_protocol(con);
>  	ceph_con_reset_session(con);
> -	cancel_con(con);
>  	mutex_unlock(&con->mutex);
> +	cancel_con(con);


Now the question is: Is it safe to cancel this work outside the mutex or
will this open up any races. Unfortunately with coarse-grained locks
like this, it's hard to tell what the lock actually protects.

If we need to keep the cancel inside the lock for some reason, you could
instead just add a "flush_workqueue()" after dropping the mutex in the
above function.

So, this looks reasonable to me at first glance, but I'd like Ilya to
ack this before we merge it.


>  }
>  EXPORT_SYMBOL(ceph_con_close);
>  
> @@ -1416,7 +1416,7 @@ static void queue_con(struct ceph_connection *con)
>  
>  static void cancel_con(struct ceph_connection *con)
>  {
> -	if (cancel_delayed_work(&con->work)) {
> +	if (cancel_delayed_work_sync(&con->work)) {
>  		dout("%s %p\n", __func__, con);
>  		con->ops->put(con);
>  	}

-- 
Jeff Layton <jlayton@kernel.org>
