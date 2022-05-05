Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6ADC51B47B
	for <lists+ceph-devel@lfdr.de>; Thu,  5 May 2022 02:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbiEEAS3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 4 May 2022 20:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiEEAS2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 4 May 2022 20:18:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4FFCE488BB
        for <ceph-devel@vger.kernel.org>; Wed,  4 May 2022 17:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651709690;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NL6kCfWNkdphJnV4oRw2YcLQPVbE//4Y+6oXMFyD+Ks=;
        b=TohEu2gcQvsDRNkcmQAi0jNpZb1qA1PH9I3n99i/lBvESNFjtzY0kUXvQe4pzUiJAUFOPv
        +InIuHenG3fHzEXW1Xs8lGZj/1lkb0fVgFIvCu/Yy0MDqzmBgq1Etrltn61GclYpHq5Jj0
        soJGkciO8U129bl1+HWenLm+MiIyglU=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-177-aKstPuLvNgKsObUssou-oQ-1; Wed, 04 May 2022 20:14:49 -0400
X-MC-Unique: aKstPuLvNgKsObUssou-oQ-1
Received: by mail-pj1-f69.google.com with SMTP id o8-20020a17090a9f8800b001dc9f554c7fso1163328pjp.4
        for <ceph-devel@vger.kernel.org>; Wed, 04 May 2022 17:14:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=NL6kCfWNkdphJnV4oRw2YcLQPVbE//4Y+6oXMFyD+Ks=;
        b=ar+1Kai3VRk2Vz+aIgauOAkU+KXae/L3c8PU3mWPc/hu07ABUi6bU3LWUdmJZ9X746
         KypQegWI4iXmM7OkSKh7VaOd/w2PTsxBbpCzmHLkkZvsPd1BIs6Bb9b9GHBs03oo5i/7
         WBMaVDPERXkEu59exyxgSjVh07Of92FEYRE7eUZnwXNsbm3N520nP/e1DuBOP2p0+wpz
         WQWUoEbRrrDr36OzJpqQJf/4KQMqxssnrQ80m+NqEqO1IMOmyRaa59hordjqGC2H5lyy
         kjepJwlkrHMiJj4kxEcoFEkJCP1fVWno8kTM0dF4BfA8AroUGkcQQjSag4Wvd3CcHQFw
         vAZQ==
X-Gm-Message-State: AOAM532xUc8FlX7bGpz6yOyv+cEZ8cy79C8bodQRZgsLiMH8ryfJeD8X
        +ENHA5NUdExVDBx6g2NuvBRolLNXBg077DYbOQmTtL4vRIIsQ1kC2rpffludoLnxr5CUD+YiXmQ
        OaVsYsgYHgCs4HJ0edTX95Q==
X-Received: by 2002:a63:8ac7:0:b0:3aa:fa62:5a28 with SMTP id y190-20020a638ac7000000b003aafa625a28mr20102634pgd.400.1651709687993;
        Wed, 04 May 2022 17:14:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxjBUjcGtrPFaC6MNlqv9ygjk6VXoU9zuoc3UG0LZAZYuAty7WLg8IBZvTAci3eTuVreIAXDQ==
X-Received: by 2002:a63:8ac7:0:b0:3aa:fa62:5a28 with SMTP id y190-20020a638ac7000000b003aafa625a28mr20102617pgd.400.1651709687785;
        Wed, 04 May 2022 17:14:47 -0700 (PDT)
Received: from [10.72.12.122] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id im22-20020a170902bb1600b0015e8d4eb1d9sm91725plb.35.2022.05.04.17.14.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 May 2022 17:14:47 -0700 (PDT)
Subject: Re: [PATCH] ceph: report STATX_ATTR_ENCRYPTED on encrypted inodes
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     lhenriques@suse.de, idryomov@gmail.com
References: <20220504110536.13418-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <e1453800-723a-cc62-a34f-96611e7ead39@redhat.com>
Date:   Thu, 5 May 2022 08:14:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220504110536.13418-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 5/4/22 7:05 PM, Jeff Layton wrote:
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/inode.c | 4 ++++
>   1 file changed, 4 insertions(+)
>
> ...another minor patch for the fscrypt pile.
>
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index ae9afc149da1..f7d56aaea27d 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -2979,6 +2979,10 @@ int ceph_getattr(struct user_namespace *mnt_userns, const struct path *path,
>   			stat->nlink = 1 + 1 + ci->i_subdirs;
>   	}
>   
> +	if (IS_ENCRYPTED(inode))
> +		stat->attributes |= STATX_ATTR_ENCRYPTED;
> +	stat->attributes_mask |= STATX_ATTR_ENCRYPTED;
> +
>   	stat->result_mask = request_mask & valid_mask;
>   	return err;
>   }
Reviewed-by: Xiubo Li <xiubli@redhat.com>

