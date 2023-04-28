Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 792696F0FD0
	for <lists+ceph-devel@lfdr.de>; Fri, 28 Apr 2023 02:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344757AbjD1Ayz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 27 Apr 2023 20:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344707AbjD1Ayt (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 27 Apr 2023 20:54:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A3C2D6B
        for <ceph-devel@vger.kernel.org>; Thu, 27 Apr 2023 17:54:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682643241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PxSe1ibjl7QhE4NAgHqoRYpV1IeiEc6uRZlJxggFn0Y=;
        b=b83MNCFOkZBiO9Ye3NWcIUQdeyDOkrKIbjCPCFsy1C8m33MVidQyetBJgNhmpDnddeIr27
        hDbJshzcDPsw1x21ibZGldNsLZYSh+RduQTqUkJDNAiJ1OflpcfnpQQmZucsKJcuNhY7rS
        arwi9dhYcGZv9KGbhVmFJvlAnZxilp8=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-283-o0BOYpNoPoy9rDL_AKTlFQ-1; Thu, 27 Apr 2023 20:54:00 -0400
X-MC-Unique: o0BOYpNoPoy9rDL_AKTlFQ-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-246fc31ebc5so5289928a91.0
        for <ceph-devel@vger.kernel.org>; Thu, 27 Apr 2023 17:54:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682643239; x=1685235239;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PxSe1ibjl7QhE4NAgHqoRYpV1IeiEc6uRZlJxggFn0Y=;
        b=TuolbWbb0Vb+VTEXmCxyHRTDCxQtbp5ikOKBCobRMtpWFEWPWCiwQksh+PQTyTKqHr
         T61dUhI15k9Ta8EqeqQ+dul7lsK/58QysvLxpdLfwc3uIEOMgiSu0oozCUL9f+JzeiMB
         8YDdBIF8XR4y/l69UR/GPCg0II7kbCuuPPTAzJ1V0wgeaO1TbiHA9mCkvJw/cnFhKk2f
         9KF2BIy1bUZQhWygHDy7+mfZaMN4GUgYonjx6akyVx6WxCZbzMGYPSXc+J/3okDS3s7G
         9QYpKoYJ+/Aq0Qo0pq/jZlkiSxMYNmNsN5DHdGQbYhl+Xd1rGjktILvKn1gWa+te3Los
         wYVw==
X-Gm-Message-State: AC+VfDwxFZ9bPIGHOiTkHFEuauJjePFeX2wCiVee+51T3XdMmAakwDG+
        eiAnQFAIaEc4rk0UU962FqGac94ZRi9j7SIhtHqF2uNdYLxrUvyvLEOXBDQk80KWDBmD34NX5Cm
        5R92d/Lu3Z0EoE0eUPYha6Q==
X-Received: by 2002:a17:90a:8f01:b0:246:5968:43f0 with SMTP id g1-20020a17090a8f0100b00246596843f0mr3770048pjo.10.1682643239195;
        Thu, 27 Apr 2023 17:53:59 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4QFCu274PAQK76ENh6rNV13iokMW0ni1iLv162C7eM3kWJa4mRcYGntcFXwQbSWmcTW6F5Ew==
X-Received: by 2002:a17:90a:8f01:b0:246:5968:43f0 with SMTP id g1-20020a17090a8f0100b00246596843f0mr3770035pjo.10.1682643238887;
        Thu, 27 Apr 2023 17:53:58 -0700 (PDT)
Received: from [10.72.12.41] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e9-20020a17090a804900b00246cf1a8d3dsm345302pjw.17.2023.04.27.17.53.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Apr 2023 17:53:58 -0700 (PDT)
Message-ID: <f6b869ea-979c-efda-d454-8dc688d1986b@redhat.com>
Date:   Fri, 28 Apr 2023 08:53:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] ceph: Reorder fields in 'struct ceph_snapid_map'
Content-Language: en-US
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        ceph-devel@vger.kernel.org
References: <559c9a70419846e0cfc319505d3d5fffd45b3358.1682618727.git.christophe.jaillet@wanadoo.fr>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <559c9a70419846e0cfc319505d3d5fffd45b3358.1682618727.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 4/28/23 02:05, Christophe JAILLET wrote:
> Group some variables based on their sizes to reduce holes.
> On x86_64, this shrinks the size of 'struct ceph_snapid_map' from 72 to 64
> bytes.
>
> When such a structure is allocated, because of the way memory allocation
> works, when 72 bytes were requested, 96 bytes were allocated.
>
> So, on x86_64, this change saves 32 bytes per allocation and has the
> structure fit in a single cacheline.
>
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> Using pahole
>
> Before:
> ======
> struct ceph_snapid_map {
> 	struct rb_node             node __attribute__((__aligned__(8))); /*     0    24 */
> 	struct list_head           lru;                  /*    24    16 */
> 	atomic_t                   ref;                  /*    40     4 */
>
> 	/* XXX 4 bytes hole, try to pack */
>
> 	u64                        snap;                 /*    48     8 */
> 	dev_t                      dev;                  /*    56     4 */
>
> 	/* XXX 4 bytes hole, try to pack */
>
> 	/* --- cacheline 1 boundary (64 bytes) --- */
> 	long unsigned int          last_used;            /*    64     8 */
>
> 	/* size: 72, cachelines: 2, members: 6 */
> 	/* sum members: 64, holes: 2, sum holes: 8 */
> 	/* forced alignments: 1 */
> 	/* last cacheline: 8 bytes */
> } __attribute__((__aligned__(8)));
> ---
>   fs/ceph/mds_client.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 0598faa50e2e..2328dbda5ab6 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -355,8 +355,8 @@ struct ceph_snapid_map {
>   	struct rb_node node;
>   	struct list_head lru;
>   	atomic_t ref;
> -	u64 snap;
>   	dev_t dev;
> +	u64 snap;
>   	unsigned long last_used;
>   };
>   

This looks good to me. Thanks.

Will apply it to the testing branch.

- Xiubo



