Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 845DD53E349
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Jun 2022 10:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbiFFHNG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Jun 2022 03:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbiFFHNF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 6 Jun 2022 03:13:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EC6C0E3DC8
        for <ceph-devel@vger.kernel.org>; Mon,  6 Jun 2022 00:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654499583;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u/h9Fl7Le8G0pv+d767+a5LApIF1KsvN4oLeitbJe8Y=;
        b=W7P3FuTQo8ONL7DIsogvTkIOuEYSK0yOjK88+3MtIyt8lmVbRn1bD4N7HXnx9bWY4zG5bS
        NgZJ0/3x2hdvGUPW2yCJ0t5pRMGRKkWrrCADV6+JZWguIis8wtCI3fH0KUeYm8Oa+qAvpw
        M56z2AMOFVJM64kn0YSAgrxpHGPOWyw=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-629-D4mdOhl4NruzIacKIlG47w-1; Mon, 06 Jun 2022 03:13:02 -0400
X-MC-Unique: D4mdOhl4NruzIacKIlG47w-1
Received: by mail-pj1-f70.google.com with SMTP id r1-20020a17090a0ac100b001e0ab5fc247so7254569pje.8
        for <ceph-devel@vger.kernel.org>; Mon, 06 Jun 2022 00:13:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=u/h9Fl7Le8G0pv+d767+a5LApIF1KsvN4oLeitbJe8Y=;
        b=Q5O0oIPRrzmh4251+6dsq2rha2Kz1IMFM0V2ei1buqSCePX/7XWJfLwQKQ2dU4ht99
         qiNbAPicYhp/Hna/rPMFUdBfroUxZATzl0q2WIulPr1A9NZY7PuZF/cXw0dhKjlPIipd
         JlcdYkzHQoALv5IYr2XrHwCpASe5aDeq0H24/0zltTke7LkEJs7X776qYXuwm+S4DA8V
         RqtQwouggnlD4S7a3lKNS4RfrdTLEB8jWvzvn2gPljXU+SKRfn5PTsCP1ucTCMKEpJJO
         6mkz+mT+c7t4J00wM1bNFLvD2X3c07I4yiaR/L5KJY/eqT/mxFoBRrwn1XWqbptgg/0v
         mKdQ==
X-Gm-Message-State: AOAM531zGbHwo1R7fMj19dbQRXtKXsdIbXtS/2XBls3H+IwjM1P5ZkCn
        vzpAhdxQwPc5wyvCAEG0L2KgaZFyEXYHYYJwAhbMXfOfaRVeosHr5tvkkZCeCaPSOJroTJPhsqo
        RV3oHbbmE9ooAmPkytm0fDPSeweFI7cFLX/TlnesErF6P8ysZN2cgmEd3xoF6Dzh8/0qgCW0=
X-Received: by 2002:a17:902:d4cf:b0:167:735a:e7a1 with SMTP id o15-20020a170902d4cf00b00167735ae7a1mr6803016plg.161.1654499580016;
        Mon, 06 Jun 2022 00:13:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx1Z5aes/fKbVnLEWNK+ImANwGVxm4trtVvXWwe78ntMsohgBUiC7cbHXiKzpJgAW+ixWDb+g==
X-Received: by 2002:a17:902:d4cf:b0:167:735a:e7a1 with SMTP id o15-20020a170902d4cf00b00167735ae7a1mr6802995plg.161.1654499579681;
        Mon, 06 Jun 2022 00:12:59 -0700 (PDT)
Received: from [10.72.12.54] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k7-20020aa79987000000b005104c6d7941sm10100582pfh.31.2022.06.06.00.12.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jun 2022 00:12:58 -0700 (PDT)
Subject: Re: [PATCH] ceph: don't leak snap_rwsem in handle_cap_grant
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org
References: <20220603203957.55337-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <9cccc136-8a86-6ae6-99f1-29e7c6643354@redhat.com>
Date:   Mon, 6 Jun 2022 15:12:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220603203957.55337-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/4/22 4:39 AM, Jeff Layton wrote:
> When handle_cap_grant is called on an IMPORT op, then the snap_rwsem is
> held and the function is expected to release it before returning. It
> currently fails to do that in all cases which could lead to a deadlock.
>
> URL: https://tracker.ceph.com/issues/55857
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/caps.c | 27 +++++++++++++--------------
>   1 file changed, 13 insertions(+), 14 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 258093e9074d..0a48bf829671 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -3579,24 +3579,23 @@ static void handle_cap_grant(struct inode *inode,
>   			fill_inline = true;
>   	}
>   
> -	if (ci->i_auth_cap == cap &&
> -	    le32_to_cpu(grant->op) == CEPH_CAP_OP_IMPORT) {
> -		if (newcaps & ~extra_info->issued)
> -			wake = true;
> +	if (le32_to_cpu(grant->op) == CEPH_CAP_OP_IMPORT) {
> +		if (ci->i_auth_cap == cap) {
> +			if (newcaps & ~extra_info->issued)
> +				wake = true;
> +
> +			if (ci->i_requested_max_size > max_size ||
> +			    !(le32_to_cpu(grant->wanted) & CEPH_CAP_ANY_FILE_WR)) {
> +				/* re-request max_size if necessary */
> +				ci->i_requested_max_size = 0;
> +				wake = true;
> +			}
>   
> -		if (ci->i_requested_max_size > max_size ||
> -		    !(le32_to_cpu(grant->wanted) & CEPH_CAP_ANY_FILE_WR)) {
> -			/* re-request max_size if necessary */
> -			ci->i_requested_max_size = 0;
> -			wake = true;
> +			ceph_kick_flushing_inode_caps(session, ci);
>   		}
> -
> -		ceph_kick_flushing_inode_caps(session, ci);
> -		spin_unlock(&ci->i_ceph_lock);
>   		up_read(&session->s_mdsc->snap_rwsem);
> -	} else {
> -		spin_unlock(&ci->i_ceph_lock);
>   	}
> +	spin_unlock(&ci->i_ceph_lock);
>   
>   	if (fill_inline)
>   		ceph_fill_inline_data(inode, NULL, extra_info->inline_data,

Anyhow the snap_rwsem should be released.

Merged into testing branch. Thanks Jeff.

-- Xiubo


