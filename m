Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ACD54D168D
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Mar 2022 12:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346567AbiCHLqd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Mar 2022 06:46:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346566AbiCHLq3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 8 Mar 2022 06:46:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34CB21B798
        for <ceph-devel@vger.kernel.org>; Tue,  8 Mar 2022 03:45:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC03DB817D3
        for <ceph-devel@vger.kernel.org>; Tue,  8 Mar 2022 11:45:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28DD3C340EC;
        Tue,  8 Mar 2022 11:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646739930;
        bh=32MCDnsEtWRe7PSV9KT4mrX4GY5QfybO1kcDky7hJK0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=g3rWxSLhMZRESMF0ObjbQj5ggxyJcqF152nq2dZIGlWtM0IFn3kfn5KDveO4gD7qd
         6wku5tCpQ5dr5cq8JK8foCA8ik3v8j7WpubT2qBZoaY3gWT0RuijrmLEUJ+y1LODqQ
         nkN57KSEN7kokm9fDgzgRnUslYIfkkWxWMtSNRcAf4vB/C+OouI+HOGam8get781of
         0yIGAciby86wo8AusWvWtZD19zzx0Itybt4vtowuQoLnk9jvDaXmkv8JSYSqSE0mDG
         r6mPHrwlqUDQzlcPYtKqcoaQICEyiloDfSB44Mk+2RVZGtKLKL/NVQceLW1knUsvV7
         HCaASwjVQRoVw==
Message-ID: <5c8f08abf692f7f4f4f0112d90c72b8aaa1ab63b.camel@kernel.org>
Subject: Re: [RFC PATCH] libceph: wait for con->work to finish when
 cancelling con
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Tue, 08 Mar 2022 06:45:28 -0500
In-Reply-To: <20220308095948.1294468-1-xiubli@redhat.com>
References: <20220308095948.1294468-1-xiubli@redhat.com>
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

On Tue, 2022-03-08 at 17:59 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> When reconnecting MDS it will reopen the con with new ip address,
> but the when opening the con with new address it couldn't be sure
> that the stale work has finished. So it's possible that the stale
> work queued will use the new data.
> 
> This will use cancel_delayed_work_sync() instead.
> 
> URL: https://tracker.ceph.com/issues/54461
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  net/ceph/messenger.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
> index d3bb656308b4..32eb5dc00583 100644
> --- a/net/ceph/messenger.c
> +++ b/net/ceph/messenger.c
> @@ -1416,7 +1416,7 @@ static void queue_con(struct ceph_connection *con)
>  
>  static void cancel_con(struct ceph_connection *con)
>  {
> -	if (cancel_delayed_work(&con->work)) {
> +	if (cancel_delayed_work_sync(&con->work)) {
>  		dout("%s %p\n", __func__, con);
>  		con->ops->put(con);
>  	}

Won't this deadlock?

This function is called from ceph_con_close with the con->mutex held.
The work will try to take the same mutex and will get stuck. If you want
to do this, then you may also need to change it to call cancel_con after
dropping the mutex.
-- 
Jeff Layton <jlayton@kernel.org>
